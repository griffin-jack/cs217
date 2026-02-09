/*
 * All rights reserved - Stanford University. 
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the "License"); 
 * you may not use this file except in compliance with the License.  
 * You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

/*
  This accerlator support different RNN Cell, unidirectional, bidirectional, general attention with high configurability
  AXI4 with 128bit data with and 32 bit address with is used in the design.
*/

// Current AXI Format (detain is in AxiSpec.h) 
// AXI: data width = 128, addr width = 32 (0x12345678)
// RVA: data width = 128, addr width = 24
// This means that each Partitation has 24 bit address (0x345678), and 
// within 24 bits, 20 bits are used to locate major units, e.g. Weight Buffer, Config


// AxiSplitter hard coded config addrBound[i][0].read() && addr <= addrBound[i][1].read();

// For AxiSplitter 
// GBPartition will use 0x10000000 ~ 0x10FFFFFF 
// PEPartition will use 0x1i000000 ~ 0x1iFFFFFF, for 1<=i<=kNumPE
//
// update: change from 0x10000000 ~ 0x33000000
#ifndef _TOP_H_
#define _TOP_H_

#include <systemc.h>
#include <nvhls_int.h>
#include <nvhls_types.h>
#include <nvhls_vector.h>
#include <nvhls_module.h>
#include <nvhls_array.h>
#include "Spec.h"
#include "AxiSpec.h" // AxiSplitter
#include "GBPartition/GBPartition.h"
#include "PEPartition/PEPartition.h"
#include "DataBus/DataBus.h"

SC_MODULE(Interrupt) {
  static const int IRQ_LENGTH = 10;
 public:  
  sc_in<bool>  clk;
  sc_in<bool>  rst;    
  sc_out<bool> interrupt;
  
  Connections::In<bool> IRQ_trigger;
  
  SC_HAS_PROCESS(Interrupt);
  Interrupt(sc_module_name name) :
     clk("clk"),
     rst("rst"),
     interrupt("interrupt"),
     IRQ_trigger("IRQ_trigger")
  {
    SC_THREAD(run_interrupt);
    sensitive << clk.pos();
    async_reset_signal_is(rst, false);
  }
  
  void run_interrupt() {
    IRQ_trigger.Reset();
    interrupt.write(false);

    while (1) {
      IRQ_trigger.Pop();
      interrupt.write(true);
      #pragma hls_pipeline_init_interval 1
      for (unsigned i = 0; i < IRQ_LENGTH; i++) {
        wait();
      }
      interrupt.write(false);
      wait();      
    }
  }
};

SC_MODULE(Top){
  static const int numSubordinates = spec::kNumPE+1; // Num of partition = PE*N + GB
 public:
// Accelerator I/O follows SMIV definition, clk, rst, IRQ (done), axi::subordinate::write, axi::subordinate::read
  sc_in<bool>  clk;
  sc_in<bool>  rst;   
  sc_out<bool> interrupt;
  typename spec::Axi::axi4_::read::template subordinate<>   if_axi_rd;
  typename spec::Axi::axi4_::write::template subordinate<>  if_axi_wr;
/////////////////////////////////////////////////////////////////////////////////////////////////////
  
// Internal Connections
  // AxiSplitter Manager connects to I/O
  // AxiSplitter Subordinate  channels (FIXME: we cannot use array of wraped up AXI channels)
  typedef typename spec::Axi::axi4_::read::template chan<>::ARChan   axi_rd_chan_ar;
  typedef typename spec::Axi::axi4_::read::template chan<>::RChan    axi_rd_chan_r;
  typedef typename spec::Axi::axi4_::write::template chan<>::AWChan  axi_wr_chan_aw;
  typedef typename spec::Axi::axi4_::write::template chan<>::WChan   axi_wr_chan_w;
  typedef typename spec::Axi::axi4_::write::template chan<>::BChan   axi_wr_chan_b;

  nvhls::nv_array<axi_rd_chan_ar, numSubordinates>  axi_rd_c_ar;
  nvhls::nv_array<axi_rd_chan_r, numSubordinates>   axi_rd_c_r;
  nvhls::nv_array<axi_wr_chan_aw, numSubordinates>  axi_wr_c_aw;
  nvhls::nv_array<axi_wr_chan_w, numSubordinates>   axi_wr_c_w;
  nvhls::nv_array<axi_wr_chan_b, numSubordinates>   axi_wr_c_b;
  
// Streaming and Control 
// XXX Important: The done, start signals btw GB and PEs have much less delay than streaming data communication.
//                this means that race problem will occur if there is no explicit delay logics on done, start signals
//                The delay of done, start signals is implemented in pe_done_inst, pe_start_inst, we can use spec::kGlobalTriggerDelay 
//                to configure the delay cycles 
  // GB sends gb_done which triggers IRQ
  Connections::Combinational<bool>              gb_done;
  // GB sends all_pe_start which is handled by pe_start_inst to activate all PEs
  Connections::Combinational<bool>              all_pe_start;
  Connections::Combinational<bool>              pe_start_array[spec::kNumPE];  
  // Each PE sends done signal handled by pe_done_inst, the all_pe_done is send to GB when all PE are done
  Connections::Combinational<bool>              pe_done_array[spec::kNumPE];
  Connections::Combinational<bool>              all_pe_done;
  // GB broadcast activations to PEs by gb_send_inst
  Connections::Combinational<spec::StreamType>  gb_output;   
  Connections::Combinational<spec::StreamType>  pe_inputs[spec::kNumPE];
  
  // Each PE sends a number of final output of an RNN cell, we need ArbitratedCrossBar, gb_recv_inst, to handle 
  // multiple data streams from PE to GB properly.ks less 
  Connections::Combinational<spec::StreamType>      data_in[spec::kNumPE]; // data_in: pe_outputs:
  Connections::Combinational<spec::StreamType>      data_out;              // data_out: gb_input:  
  
// Module Instantiation 
  // Need to use pointer array with instantiation to declare PEPartition  
  GBPartition gb_inst;
  PEPartition* pe_ptrs[spec::kNumPE];

  // Axi Spliter, and configuration regs (hard coded)
  // NOTE: spec::kNumPE+1 = numSubordinates
  spec::Axi::AxiSplitter axispliter_inst;
  sc_signal<NVUINTW(spec::Axi::axiCfg::addrWidth)> addrBound[numSubordinates][2];

  // Databus modules
  PEStart pe_start_inst;
  PEDone  pe_done_inst;
  GBSend  gb_send_inst;
  GBRecv  gb_recv_inst;
  // Interrupt sender
  Interrupt irq_inst;
  
  // XXX: plan to hardcode AXI configm, I put this function inside constructor
  //      but we might need to use SC_THREAD instead
  void WriteAxiSplitterConfig() {
    #pragma hls_unroll yes    
    for (int i = 0; i < numSubordinates; i++) {
      NVUINTW(spec::Axi::axiCfg::addrWidth) write_base  = 0x33000000 + 0x01000000*i;
      NVUINTW(spec::Axi::axiCfg::addrWidth) write_bound = 0x33FFFFFF + 0x01000000*i; 
      addrBound[i][0].write(write_base);
      addrBound[i][1].write(write_bound);
    }
  }
  
  SC_HAS_PROCESS(Top);
  Top(sc_module_name name) :
     clk("clk"),
     rst("rst"),
     interrupt("interrupt"),
     if_axi_rd("if_axi_rd"),
     if_axi_wr("if_axi_wr"),
     gb_inst("gb_inst"),
     axispliter_inst ("axispliter_inst"),     
     pe_start_inst("pe_start_inst"),
     pe_done_inst ("pe_done_inst"),
     gb_send_inst ("gb_send_inst"),
     gb_recv_inst ("gb_recv_inst"),
     irq_inst ("irq_inst")
  {
    WriteAxiSplitterConfig();

    // TODO #1: Connect GBPartition instance (gb_inst)
    // 1. Connect clk, rst.
    // 2. Connect AXI subordinate channels (read/write) for communication with the AXI splitter.
    // 3. Connect data ports for PE communication (data_in, data_out).
    // 4. Connect control signals for PE synchronization (pe_start, pe_done).
    // 5. Connect the done signal to gb_done for interrupt generation.
    /////////////// YOUR CODE STARTS HERE ///////////////

    /////////////// YOUR CODE ENDS HERE ///////////////

    // TODO #2: Instantiate and connect PEPartition modules
    // 1. Loop through the number of PEs (spec::kNumPE). While in the spec kNumPE is defined as 1, we want you to think about scaling the design and write accordingly
    // 2. Dynamically create each PEPartition instance.
    // 3. Connect clk, rst.
    // 4. Connect AXI subordinate channels (read/write), starting from index 1 of the channel arrays.
    // 5. Connect data ports for GB communication (input_port, output_port).
    // 6. Connect control signals for synchronization (start, done).
    /////////////// YOUR CODE STARTS HERE ///////////////

    /////////////// YOUR CODE ENDS HERE ///////////////
    
    // TODO #3: Connect the AxiSplitter instance (axispliter_inst)
    // 1. Connect clk and rst.
    // 2. Connect the AXI master ports to the Top module's AXI subordinate I/O.
    // 3. Connect the AXI subordinate ports to the internal AXI channels for GB and PEs.
    // 4. Connect the address bound signals for routing configuration.

    /////////////// YOUR CODE STARTS HERE ///////////////

    /////////////// YOUR CODE ENDS HERE /////////////////


    // TODO #4: Connect the databus and interrupt handling modules
    // 1. Connect PEStart (pe_start_inst) to distribute the start signal from GB to all PEs.
    // 2. Connect PEDone (pe_done_inst) to aggregate done signals from all PEs and forward to GB.
    // 3. Connect GBSend (gb_send_inst) to broadcast data from GB to all PEs.
    // 4. Connect GBRecv (gb_recv_inst) to arbitrate and forward data from PEs to GB.
    // 5. Connect Interrupt (irq_inst) to generate an interrupt when GB is done.

    /////////////// YOUR CODE STARTS HERE ///////////////

    /////////////// YOUR CODE ENDS HERE ///////////////
  }
  
};
#endif
