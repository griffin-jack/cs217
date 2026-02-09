#ifndef __COUNTER_TOP_H__
#define __COUNTER_TOP_H__

#pragma once

#include <systemc.h>
#include <nvhls_connections.h>
#include <nvhls_int.h>
#include "counter_module.h"
#include "add.h"

using namespace nvhls;

SC_MODULE(counter_top)
{
    sc_in<bool> clk;
    sc_in<bool> rst;

    sc_out<sc_lv<32>> counter_out;
    sc_out<sc_lv<32>> add_out;

    counter_module counter_inst;
    add add_inst;

    Connections::Combinational<NVUINT32> counter_module_out;
    Connections::Combinational<NVUINT32> counter_in;
    Connections::Combinational<NVUINT32> add_to_top;

    NVUINT32 counter_out_sig;
    NVUINT32 add_out_sig;

    sc_lv<32> counter_out_tmp;
    sc_lv<32> add_out_tmp;

    SC_HAS_PROCESS(counter_top);
    counter_top(sc_module_name name)
        : sc_module(name),
          clk("clk"),
          rst("rst"),
          counter_inst("counter_inst"),
          add_inst("add_inst")
    {
        counter_inst.clk(clk);
        counter_inst.rst(rst);
        add_inst.clk(clk);
        add_inst.rst(rst);

        // Connect channels between modules
        counter_inst.counter_out(counter_module_out);
        add_inst.counter_in(counter_in);
        add_inst.add_out(add_to_top);

        SC_THREAD(run);
        sensitive << clk.pos();
        async_reset_signal_is(rst, false);
    }

    void run()
    {
        counter_module_out.ResetRead();
        counter_in.ResetWrite();
        add_to_top.ResetRead();
        
        counter_out.write(0);
        add_out.write(0);

        counter_out_sig = 0;
        add_out_sig = 0;


        wait();

        while (true)
        {
            // Read from add module
            counter_out_sig = counter_module_out.Pop();
            counter_in.Push(counter_out_sig);
            add_out_sig = add_to_top.Pop();

            // Convert to sc_lv<32>
            #pragma hls_unroll yes
            for (int i = 0; i < 32; ++i)
            {
                counter_out_tmp[i] = counter_out_sig[i];
                add_out_tmp[i] = add_out_sig[i];
            }

            counter_out.write(counter_out_tmp);
            add_out.write(add_out_tmp);
            wait();
        }
    }
};
#endif // __COUNTER_TOP_H__