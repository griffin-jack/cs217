#include <systemc.h>
#include <ac_reset_signal_is.h>
#include <nvhls_connections.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <iomanip>
#include <cmath>

#include "PECore/PECore.h"
#include "ActUnit/ActUnit.h"

const int TOKENS = 208;
const int VECS_384 = 24;
const int VECS_1536 = 96;

template <typename T>
void load_bin(const char* filename, std::vector<T>& buffer, size_t size) {
    std::ifstream file(filename, std::ios::binary);
    if (!file) { std::cerr << "Error: Could not open " << filename << std::endl; sc_stop(); return; }
    buffer.resize(size);
    file.read(reinterpret_cast<char*>(buffer.data()), size * sizeof(T));
    file.close();
}

spec::ActVectorType get_vec(const std::vector<int16_t>& arr, int idx) {
    spec::ActVectorType out;
    for(int i=0; i<16; i++) out[i] = arr[idx*16 + i];
    return out;
}

spec::ActVectorType promote(spec::StreamType in) {
    spec::ActVectorType out;
    for(int i=0; i<16; i++) out[i] = ((int16_t)((int8_t)in.data[i].to_int())) << 8;
    return out;
}

SC_MODULE(Orchestrator) {
    sc_in<bool> clk, rst;

    Connections::Out<bool> act_start;
    Connections::Out<spec::ActVectorType> act_port;
    Connections::Out<spec::Axi::SubordinateToRVA::Write> act_rva_in;
    Connections::In<spec::StreamType> act_out; 
    Connections::In<bool> act_done;

    Connections::Out<bool> pe_start;
    Connections::Out<spec::StreamType> pe_in;
    Connections::Out<spec::Axi::SubordinateToRVA::Write> pe_rva_in;
    Connections::In<spec::ActVectorType> pe_out;

    SC_CTOR(Orchestrator) { SC_THREAD(run); sensitive << clk.pos(); async_reset_signal_is(rst, false); }

    void act_config(NVUINT8 count, NVUINT8* mcode, int loops) {
        NVUINTW(128) idata = 0; for (int i=0; i<count; i++) idata.set_slc(8*i, mcode[i]);
        spec::Axi::SubordinateToRVA::Write cmd; cmd.rw = 1;
        cmd.addr = 0x800020; cmd.data = idata; act_rva_in.Push(cmd); wait();
        
        NVUINTW(128) cdata = 0; cdata.set_slc(0, (NVUINT1)1); cdata.set_slc(24, (NVUINT6)count); cdata.set_slc(32, (NVUINT8)loops);
        cmd.addr = 0x800010; cmd.data = cdata; act_rva_in.Push(cmd); wait();
    }

    void pe_config(int in_ch, int out_ch, int base) {
        NVUINTW(128) mcfg = 0; mcfg.set_slc(8, (NVUINT8)in_ch); mcfg.set_slc(16, (NVUINT16)base);
        spec::Axi::SubordinateToRVA::Write cmd; cmd.rw = 1; cmd.addr = 0x400020; cmd.data = mcfg; pe_rva_in.Push(cmd); wait(2);
        
        NVUINTW(128) pcfg = 0; pcfg.set_slc(0, (NVUINT1)1); pcfg.set_slc(32, (NVUINT4)1); pcfg.set_slc(40, (NVUINT8)out_ch);
        cmd.addr = 0x400010; cmd.data = pcfg; pe_rva_in.Push(cmd); wait(2);
    }

    void load_w(const std::vector<int8_t>& w, int v_in, int v_out, int base) {
        for(int o=0; o<v_out; o++) {
            if (o > 0 && o % 24 == 0) std::cout << "  Loaded " << o << "/" << v_out << " channel blocks..." << std::endl;
            for(int i=0; i<v_in; i++) {
                for(int c=0; c<16; c++) {
                    NVUINTW(128) w_data = 0;
                    for(int j=0; j<16; j++) w_data.set_slc(8*j, (NVUINT8)w[((o*16)+c)*(v_in*16) + (i*16)+j]);
                    spec::Axi::SubordinateToRVA::Write cmd; cmd.rw = 1;
                    cmd.addr = 0x500000 | (((o*v_in+i)*16+c+base) << 4); cmd.data = w_data; pe_rva_in.Push(cmd);
                }
            }
            wait(1);
        }
    }

    void run() {
        act_start.Reset(); act_port.Reset(); act_rva_in.Reset(); act_out.Reset(); act_done.Reset();
        pe_start.Reset(); pe_in.Reset(); pe_rva_in.Reset(); pe_out.Reset();
        wait(20);

        std::vector<int16_t> x, tok_out, ls1, n2a, n2b, fc1_b, fc2_b, ls2;
        std::vector<int8_t> fc1_w, fc2_w, gold;
        
        load_bin<int16_t>("../../../../software/tb_data/in_x.bin", x, TOKENS*VECS_384*16);
        load_bin<int16_t>("../../../../software/tb_data/in_tok_out.bin", tok_out, TOKENS*VECS_384*16);
        load_bin<int16_t>("../../../../software/tb_data/w_ls1.bin", ls1, VECS_384*16);
        load_bin<int16_t>("../../../../software/tb_data/w_n2_a.bin", n2a, VECS_384*16);
        load_bin<int16_t>("../../../../software/tb_data/w_n2_b.bin", n2b, VECS_384*16);
        load_bin<int16_t>("../../../../software/tb_data/w_fc1_b.bin", fc1_b, VECS_1536*16);
        load_bin<int16_t>("../../../../software/tb_data/w_fc2_b.bin", fc2_b, VECS_384*16);
        load_bin<int16_t>("../../../../software/tb_data/w_ls2.bin", ls2, VECS_384*16);
        
        load_bin<int8_t>("../../../../software/tb_data/w_fc1_w.bin", fc1_w, VECS_1536*16*VECS_384*16);
        load_bin<int8_t>("../../../../software/tb_data/w_fc2_w.bin", fc2_w, VECS_384*16*VECS_1536*16);
        load_bin<int8_t>("../../../../software/tb_data/g6_final.bin", gold, TOKENS*VECS_384*16);

        NVUINT8 mc_base[] = {0x34, 0x38, 0x99, 0x34, 0x89, 0x48}; 
        NVUINT8 mc_gelu[] = {0x34, 0x38, 0x89, 0xF8, 0x48};       
        NVUINT8 mc_res[]  = {0x38, 0x34, 0x89, 0x34, 0x99, 0x34, 0x89, 0x48}; 

        // Buffers to hold intermediate layer data
        std::vector<spec::StreamType> ch_hid_buf(TOKENS * VECS_1536);
        std::vector<spec::ActVectorType> x_tok_promoted_buf(TOKENS * VECS_384);
        spec::StreamType x_scl[VECS_384];
        spec::ActVectorType raw1[VECS_1536], raw2[VECS_384];

        std::cout << "\n=== HARDWARE INIT (PART 1) ===" << std::endl;
        load_w(fc1_w, VECS_384, VECS_1536, 0); // Load FC1 at Address 0

        std::cout << "\n=== PHASE 1-4: Processing All Tokens ===" << std::endl;
        for (int t = 0; t < TOKENS; t++) {
            // Phase 1: LS1 + Res
            act_config(6, mc_base, VECS_384); act_start.Push(true); wait();
            for(int v=0; v<VECS_384; v++) {
                act_port.Push(get_vec(ls1, v)); act_port.Push(get_vec(tok_out, t*VECS_384 + v)); act_port.Push(get_vec(x, t*VECS_384 + v));
                spec::StreamType res = act_out.Pop();
                x_tok_promoted_buf[t*VECS_384 + v] = promote(res); // Save for Phase 6
            }
            act_done.Pop();

            // Phase 2: Norm 2
            act_config(6, mc_base, VECS_384); act_start.Push(true); wait();
            for(int v=0; v<VECS_384; v++) {
                act_port.Push(get_vec(n2a, v)); act_port.Push(x_tok_promoted_buf[t*VECS_384 + v]); act_port.Push(get_vec(n2b, v));
                x_scl[v] = act_out.Pop();
            }
            act_done.Pop();

            // Phase 3: MatMul 1
            pe_config(VECS_384, VECS_1536, 0); 
            for(int v=0; v<VECS_384; v++) pe_in.Push(x_scl[v]); 
            pe_start.Push(true); wait();                         
            for(int v=0; v<VECS_1536; v++) raw1[v] = pe_out.Pop();

            // Phase 4: Bias 1 + GELU
            act_config(5, mc_gelu, VECS_1536); act_start.Push(true); wait();
            for(int v=0; v<VECS_1536; v++) {
                act_port.Push(get_vec(fc1_b, v)); act_port.Push(raw1[v]);
                ch_hid_buf[t*VECS_1536 + v] = act_out.Pop(); // Buffer hidden states
            }
            act_done.Pop();
            if ((t+1) % 52 == 0) std::cout << "  Layer Halfway: " << t+1 << "/" << TOKENS << " tokens done." << std::endl;
        }

        std::cout << "\n=== HARDWARE INIT (PART 2: SWAPPING WEIGHTS) ===" << std::endl;
        load_w(fc2_w, VECS_1536, VECS_384, 0); // OVERWRITE FC1 at Address 0!

        int errors = 0;
        std::cout << "\n=== PHASE 5-6: Final Processing & Verification ===" << std::endl;
        for (int t = 0; t < TOKENS; t++) {
            // Phase 5: MatMul 2
            pe_config(VECS_1536, VECS_384, 0); 
            for(int v=0; v<VECS_1536; v++) pe_in.Push(ch_hid_buf[t*VECS_1536 + v]); 
            pe_start.Push(true); wait();                          
            for(int v=0; v<VECS_384; v++) raw2[v] = pe_out.Pop();

            // Phase 6: FC2 Bias + LS2 + Residual
            act_config(8, mc_res, VECS_384); act_start.Push(true); wait();
            for(int v=0; v<VECS_384; v++) {
                act_port.Push(raw2[v]); act_port.Push(get_vec(fc2_b, v)); 
                act_port.Push(get_vec(ls2, v)); act_port.Push(x_tok_promoted_buf[t*VECS_384 + v]);
                spec::StreamType hw_final = act_out.Pop();
                
                // Live Verification
                for (int i = 0; i < 16; i++) {
                    int h_val = (int8_t)hw_final.data[i].to_int(); 
                    int g_val = gold[t*VECS_384*16 + v*16 + i];
                    if (std::abs(h_val - g_val) > 10) errors++; 
                }
            }
            act_done.Pop();
            if ((t+1) % 52 == 0) std::cout << "  Layer Complete: " << t+1 << "/" << TOKENS << " tokens verified." << std::endl;
        }

        if (errors == 0) std::cout << "\nSUCCESS: Full 208-Token Layer Verified Matches PyTorch!" << std::endl;
        else std::cout << "\nFAILED with " << errors << " mismatches." << std::endl;
        sc_stop();
    }
};

// Safe AXI Response Garbage Collector
SC_MODULE(Sink) {
    sc_in<bool> clk, rst;
    Connections::In<spec::Axi::SubordinateToRVA::Read> pe_rva_out, act_rva_out;
    SC_CTOR(Sink) { SC_THREAD(run); sensitive << clk.pos(); async_reset_signal_is(rst, false); }
    void run() {
        pe_rva_out.Reset(); act_rva_out.Reset();
        while(1) {
            spec::Axi::SubordinateToRVA::Read dummy;
            pe_rva_out.PopNB(dummy); act_rva_out.PopNB(dummy);
            wait();
        }
    }
};

SC_MODULE(Testbench) {
    sc_clock clk;
    sc_signal<bool> rst;

    Connections::Combinational<bool> a_st;
    Connections::Combinational<spec::ActVectorType> a_pt;
    Connections::Combinational<spec::Axi::SubordinateToRVA::Write> a_rva;
    Connections::Combinational<spec::StreamType> a_out;
    Connections::Combinational<bool> a_done;
    
    Connections::Combinational<bool> p_st;
    Connections::Combinational<spec::StreamType> p_in;
    Connections::Combinational<spec::Axi::SubordinateToRVA::Write> p_rva;
    Connections::Combinational<spec::ActVectorType> p_out;
    
    Connections::Combinational<spec::Axi::SubordinateToRVA::Read> a_rva_out, p_rva_out;
    sc_signal<NVUINT32> sram_config;

    ActUnit act; PECore pe; Orchestrator src; Sink snk;

    SC_CTOR(Testbench) : clk("clk", 1, SC_NS), act("act"), pe("pe"), src("src"), snk("snk") {
        act.clk(clk); act.rst(rst); act.start(a_st); act.act_port(a_pt); act.rva_in(a_rva); 
        act.output_port(a_out); act.rva_out(a_rva_out); act.done(a_done);
        
        pe.clk(clk); pe.rst(rst); pe.start(p_st); pe.input_port(p_in); pe.rva_in(p_rva); 
        pe.act_port(p_out); pe.rva_out(p_rva_out); pe.SC_SRAM_CONFIG(sram_config);

        src.clk(clk); src.rst(rst); 
        src.act_start(a_st); src.act_port(a_pt); src.act_rva_in(a_rva); src.act_out(a_out); src.act_done(a_done);
        src.pe_start(p_st); src.pe_in(p_in); src.pe_rva_in(p_rva); src.pe_out(p_out);

        snk.clk(clk); snk.rst(rst); snk.pe_rva_out(p_rva_out); snk.act_rva_out(a_rva_out);

        SC_THREAD(reset_driver);
    }
    void reset_driver() { rst.write(false); wait(5, SC_NS); rst.write(true); wait(5, SC_NS); }
};

int sc_main(int argc, char *argv[]) {
    Testbench tb("tb"); sc_start(); return 0;
}