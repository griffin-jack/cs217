#ifndef __ADD_H__
#define __ADD_H__

#pragma once

#include <systemc.h>
#include <nvhls_connections.h>
#include <nvhls_int.h>

using namespace nvhls;

SC_MODULE(add)
{
    sc_in<bool> clk;
    sc_in<bool> rst;

    Connections::In<NVUINT32> counter_in;
    Connections::Out<NVUINT32> add_out;

    const NVUINT32 constant_add = 5;
    NVUINT32 add_out_sig;
    NVUINT32 counter_in_sig;

    SC_HAS_PROCESS(add);
    add(sc_module_name name)
        : sc_module(name),
          clk("clk"),
          rst("rst")
    {
        SC_THREAD(run);
        sensitive << clk.pos();
        async_reset_signal_is(rst, false);
    }

    void run()
    {
        counter_in.Reset();
        add_out.Reset();

        add_out_sig = 0;
        counter_in_sig = 0;
       
        wait();

        while (true)
        {
            /////////////// YOUR IMPLEMENTATION STARTS ///////////////
            // 1. This module will add a constant value (constant_add) to the counter value popped
            // 2. The added value is then pushed to the output channel

            counter_in_sig = counter_in.Pop();
            add_out_sig = counter_in_sig + constant_add;
            add_out.Push(add_out_sig);

            ////////////// YOUR IMPLEMENTATION ENDS ////////////////
            wait();
        }
    }
};
#endif // __ADD_H__