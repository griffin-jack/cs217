#ifndef __COUNTER_MODULE_H__
#define __COUNTER_MODULE_H__

#pragma once

#include <systemc.h>
#include <nvhls_connections.h>
#include <nvhls_int.h>

using namespace nvhls;

SC_MODULE(counter_module)
{
    sc_in<bool> clk;
    sc_in<bool> rst;

    Connections::Out<NVUINT32> counter_out;

    NVUINT32 counter_out_sig;

    SC_HAS_PROCESS(counter_module);
    counter_module(sc_module_name name)
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
        counter_out.Reset();

        counter_out_sig = 0;

        wait();

        while (true)
        {
            /////////////// START YOUR IMPLEMENTATION HERE ///////////////
            // 1. This module increments the count and pushes the output every cycle

            counter_out_sig = counter_out_sig + 1;
            counter_out.Push(counter_out_sig);

            ////////////// YOUR IMPLEMENTATION ENDS HERE ////////////////
            wait();
        }
    }
};
#endif // __COUNTER_MODULE_H__