#include <systemc.h>
#include <ac_reset_signal_is.h>
#include <nvhls_connections.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <iomanip>

#include "PECore.h"
#include "../ActUnit/ActUnit.h"

template <typename T>
void load_bin(const char* filename, std::vector<T>& buffer, size_t size) {
    std::ifstream file(filename, std::ios::binary);
    if (!file) {
        std::cerr << "Error: Could not open " << filename << std::endl;
        sc_stop();
        return;
    }
    buffer.resize(size);
    file.read(reinterpret_cast<char*>(buffer.data()), size * sizeof(T));
    file.close();
}

SC_MODULE(Source) {
    sc_in<bool> clk;
    sc_in<bool> rst;

    Connections::Out<bool> act_start;
    Connections::Out<spec::ActVectorType> act_port;
    Connections::Out<spec::Axi::SubordinateToRVA::Write> act_rva_in;
    Connections::Out<bool> pe_start;
    Connections::Out<spec::StreamType> pe_in;
    Connections::Out<spec::Axi::SubordinateToRVA::Write> pe_rva_in;
    Connections::In<spec::StreamType> act_out; 

    SC_CTOR(Source) {
        SC_THREAD(run);
        sensitive << clk.pos();
        async_reset_signal_is(rst, false);
    }

    void act_axi_write(NVUINT8 local_index, NVUINTW(128) data) {
        spec::Axi::SubordinateToRVA::Write cmd; cmd.rw = 1;
        cmd.addr = 0x800000 | ((NVUINTW(24))local_index << 4);
        cmd.data = data; act_rva_in.Push(cmd);
    }

    void pe_axi_write(NVUINT4 region, NVUINT16 local_index, NVUINTW(128) data) {
        spec::Axi::SubordinateToRVA::Write cmd; cmd.rw = 1;
        cmd.addr = ((NVUINTW(24))region << 20) | ((NVUINTW(24))local_index << 4);
        cmd.data = data; pe_rva_in.Push(cmd);
    }

    void run() {
        act_start.Reset(); act_port.Reset(); act_rva_in.Reset();
        pe_start.Reset(); pe_in.Reset(); pe_rva_in.Reset(); act_out.Reset();

        wait(20);

        const int TOKENS = 208;
        const int VECS_IN = 24;  // 384 input channels
        const int VECS_OUT = 96; // 1536 output channels
        
        std::vector<int16_t> x_tok, norm_a, norm_b;
        std::vector<int8_t> fc1_w;
        
        load_bin<int16_t>("../../../../../software/tb_data/hw_in_x_tok.bin", x_tok, TOKENS*VECS_IN*16);
        load_bin<int16_t>("../../../../../software/tb_data/hw_w_norm2_alpha.bin", norm_a, VECS_IN*16);
        load_bin<int16_t>("../../../../../software/tb_data/hw_w_norm2_beta.bin", norm_b, VECS_IN*16);
        load_bin<int8_t>("../../../../../software/tb_data/hw_w_fc1_weight.bin", fc1_w, VECS_OUT*16*VECS_IN*16);

        std::cout << "\n=== PHASE 1: AXI Configuration ===" << std::endl;
        std::cout << "Loading 36,864 weight vectors into PECore SRAM (This will take a moment)..." << std::endl;
        
        for(int v_out = 0; v_out < VECS_OUT; v_out++) {
            if (v_out % 24 == 0) std::cout << "  Loaded " << v_out << "/" << VECS_OUT << " output channel blocks..." << std::endl;
            for(int v_in = 0; v_in < VECS_IN; v_in++) {
                for(int c = 0; c < 16; c++) {
                    NVUINTW(128) w_data = 0;
                    for(int j = 0; j < 16; j++) {
                        int flat_idx = ((v_out * 16) + c) * 384 + (v_in * 16) + j;
                        w_data.set_slc(8*j, (NVUINT8)fc1_w[flat_idx]);
                    }
                    int addr = (v_out * VECS_IN + v_in) * 16 + c;
                    pe_axi_write(0x5, addr, w_data);
                }
                wait(1); // Small delay to allow memory port clearance
            }
        }

        // PECore: 24 input vectors, 96 output vectors
        NVUINTW(128) mcfg = 0; mcfg.set_slc(8, (NVUINT8)VECS_IN); 
        pe_axi_write(0x4, 0x2, mcfg); wait(2);
        
        NVUINTW(128) pcfg = 0; 
        pcfg.set_slc(0, (NVUINT1)1); pcfg.set_slc(32, (NVUINT4)1); pcfg.set_slc(40, (NVUINT8)VECS_OUT); 
        pe_axi_write(0x4, 0x1, pcfg); wait(2);

        // ActUnit: Microcode loops 24 times per token
        NVUINT8 mcode[6] = {0x34, 0x38, 0x99, 0x34, 0x89, 0x48};
        NVUINTW(128) idata = 0; for (int i=0; i<6; i++) idata.set_slc(8*i, mcode[i]);
        act_axi_write(0x02, idata); wait();

        NVUINTW(128) cdata = 0;
        cdata.set_slc(0, (NVUINT1)1); cdata.set_slc(24, (NVUINT6)6); cdata.set_slc(32, (NVUINT8)VECS_IN);
        act_axi_write(0x01, cdata); wait();
        
        std::cout << "\n=== PHASE 2: Full Tensor Streaming ===" << std::endl;
        std::cout << "Streaming 208 Tokens through full datapath..." << std::endl;

        for (int t = 0; t < TOKENS; t++) {
            act_start.Push(true); wait();
            
            for (int v = 0; v < VECS_IN; v++) {
                spec::ActVectorType va, vx, vb;
                for (int i=0; i<16; i++) {
                    va[i] = norm_a[v*16 + i]; 
                    vb[i] = norm_b[v*16 + i];
                    vx[i] = x_tok[t * (VECS_IN*16) + v*16 + i]; 
                }
                
                act_port.Push(va); wait(); act_port.Push(vx); wait(); act_port.Push(vb); wait();
                spec::StreamType act_result = act_out.Pop();
                
                // Blocks thread until PECore completes the previous token and returns to IDLE
                pe_in.Push(act_result); wait(); 
            }
            // Trigger MatMul for this Token
            pe_start.Push(true); wait();
        }
        while (1) { wait(); }
    }
};

SC_MODULE(Sink) {
    sc_in<bool> clk;
    sc_in<bool> rst;

    Connections::In<spec::ActVectorType> pe_out;
    Connections::In<spec::Axi::SubordinateToRVA::Read> pe_rva_out;
    Connections::In<spec::Axi::SubordinateToRVA::Read> act_rva_out;
    Connections::In<bool> act_done;

    SC_CTOR(Sink) {
        SC_THREAD(run);
        sensitive << clk.pos();
        async_reset_signal_is(rst, false);
    }

    void run() {
        pe_out.Reset(); pe_rva_out.Reset(); act_rva_out.Reset(); act_done.Reset();
        wait(20);

        const int TOKENS = 208;
        const int VECS_OUT = 96;

        std::vector<int16_t> golden_pe;
        load_bin<int16_t>("../../../../../software/tb_data/golden_2_fc1_matmul.bin", golden_pe, TOKENS*VECS_OUT*16);

        int errors = 0;
        std::cout << "\n=== VERIFICATION: PECore Output ===" << std::endl;

        for (int t = 0; t < TOKENS; t++) {
            act_done.Pop(); 
            
            for (int out_vec = 0; out_vec < VECS_OUT; out_vec++) {
                spec::ActVectorType pe_result = pe_out.Pop();
                for (int i = 0; i < 16; i++) {
                    int hw_val = (int16_t)pe_result[i].to_int(); 
                    int flat_idx = t * (VECS_OUT * 16) + out_vec * 16 + i;
                    int g_val  = golden_pe[flat_idx];

                    if (hw_val != g_val) {
                        errors++;
                        if (errors < 15) {
                            std::cout << "Mismatch at Token " << t << " Ch " << out_vec*16+i 
                                      << " | HW=" << hw_val << " Gold=" << g_val << std::endl;
                        }
                    }
                }
            }
            if (t > 0 && t % 20 == 0) std::cout << "  Verified " << t << "/" << TOKENS << " tokens..." << std::endl;
        }

        if (errors == 0) std::cout << "\nSUCCESS: Full 208x1536 Matrix Verified! 0 Mismatches." << std::endl;
        else std::cout << "\nFAILED with " << errors << " mismatches." << std::endl;
        sc_stop();
    }
};

SC_MODULE(Testbench) {
    sc_clock clk;
    sc_signal<bool> rst;

    Connections::Combinational<bool> act_start_ch;
    Connections::Combinational<spec::ActVectorType> act_port_in_ch;
    Connections::Combinational<spec::Axi::SubordinateToRVA::Write> act_rva_in_ch;
    Connections::Combinational<spec::Axi::SubordinateToRVA::Read> act_rva_out_ch;
    Connections::Combinational<bool> act_done_ch;

    Connections::Combinational<bool> pe_start_ch;
    Connections::Combinational<spec::StreamType> pe_in_port_ch;
    Connections::Combinational<spec::Axi::SubordinateToRVA::Write> pe_rva_in_ch;
    Connections::Combinational<spec::Axi::SubordinateToRVA::Read> pe_rva_out_ch;
    Connections::Combinational<spec::ActVectorType> pe_out_port_ch;
    
    Connections::Combinational<spec::StreamType> router_ch;
    sc_signal<NVUINT32> sram_config;

    ActUnit act_inst;
    PECore pe_inst;
    Source src;
    Sink snk;

    SC_CTOR(Testbench) : clk("clk", 1, SC_NS), act_inst("act_inst"), pe_inst("pe_inst"), src("src"), snk("snk") {
        act_inst.clk(clk); act_inst.rst(rst); act_inst.start(act_start_ch); act_inst.act_port(act_port_in_ch); 
        act_inst.rva_in(act_rva_in_ch); act_inst.rva_out(act_rva_out_ch); act_inst.output_port(router_ch); act_inst.done(act_done_ch);

        pe_inst.clk(clk); pe_inst.rst(rst); pe_inst.start(pe_start_ch); pe_inst.input_port(pe_in_port_ch); 
        pe_inst.rva_in(pe_rva_in_ch); pe_inst.rva_out(pe_rva_out_ch); pe_inst.act_port(pe_out_port_ch); pe_inst.SC_SRAM_CONFIG(sram_config);

        src.clk(clk); src.rst(rst); src.act_start(act_start_ch); src.act_port(act_port_in_ch); src.act_rva_in(act_rva_in_ch);
        src.pe_start(pe_start_ch); src.pe_in(pe_in_port_ch); src.pe_rva_in(pe_rva_in_ch); src.act_out(router_ch);

        snk.clk(clk); snk.rst(rst); snk.pe_out(pe_out_port_ch); snk.pe_rva_out(pe_rva_out_ch); snk.act_rva_out(act_rva_out_ch); snk.act_done(act_done_ch);

        SC_THREAD(reset_driver);
    }
    void reset_driver() { rst.write(false); wait(5, SC_NS); rst.write(true); wait(5, SC_NS); }
};

int sc_main(int argc, char *argv[]) {
    Testbench tb("tb"); sc_start(); return 0;
}