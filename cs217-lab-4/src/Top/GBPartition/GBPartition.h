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

#ifndef __GBPARTITION__
#define __GBPARTITION__

#include <systemc.h>
#include <nvhls_int.h>
#include <nvhls_types.h>
#include <nvhls_vector.h>
#include <nvhls_module.h>

#include "Spec.h"
#include "AxiSpec.h"

#include "GBModule/GBModule.h"


SC_MODULE(GBPartition) {
  static const int kDebugLevel = 3;
 public:
  sc_in<bool>  clk;
  sc_in<bool>  rst;

  // TODO #1: 
  // Note - Take PEPartition.h and testbench.cpp as reference
  // 1. Define the ports for the GBPartition module. This includes the AXI subordinate interface,
  //    the `gb_done` signal, and dataflow channels for PE communication (`data_in`, `data_out`, `pe_start`, `pe_done`).
  // 2. Instantiate the `GBModule` and the AXI-to-RVA converter (`spec::Axi::SubordinateToRVA`).
  // 3. Create internal RVA channels to connect the two instances.
  // 4. In the constructor, connect the ports of the instantiated modules.
  //    - `rva_inst` connects the external AXI interface to the internal RVA channels.
  //    - `gbmodule_inst` connects to the internal RVA channels and the other module ports.

  /////////////// YOUR CODE STARTS HERE ///////////////

  /////////////// YOUR CODE ENDS HERE ///////////////

  
};



#endif 
