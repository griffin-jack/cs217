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

#ifndef PPU_H
#define PPU_H

#include <systemc.h>
#include <nvhls_int.h>
#include <nvhls_types.h>
#include <nvhls_vector.h>
#include <nvhls_module.h>
#include <ac_fixed.h>
  

#pragma hls_design ccore
#pragma hls_ccore_type combinational
inline void Tanh (const spec::ActVectorType in, spec::ActVectorType& out)
{
  // TODO 1: Implement the Tanh activation function using 3rd order Taylor series approximation
  
  ///////// YOUR IMPLEMENTATION STARTS HERE /////////

  #pragma hls_unroll yes
  for (int i = 0; i < spec::kNumVectorLanes; i++) {

    // Read fixed pt
    ac_fixed<spec::kActWordWidth, spec::kActWordWidth - spec::kActNumFrac, true> x;
    x.set_slc(0, in[i]);

    // Tanh in fixed-point
    ac_fixed<spec::kActWordWidth, spec::kActWordWidth - spec::kActNumFrac, true> y;
    if (x < -1) {
      y = -1;
    } else if (x > 1) {
      y = 1;
    } else {
      y = x + (ac_fixed<spec::kActWordWidth, spec::kActWordWidth - spec::kActNumFrac, true>)(-1.0/3.0) * x * x * x;
    }

    // Write back bits
    ac_int<spec::kActWordWidth, true> raw_out = y.template slc<spec::kActWordWidth>(0);
    out[i] = raw_out;
  }
  
  ///////// YOUR IMPLEMENTATION ENDS HERE /////////
}

#pragma hls_design ccore
#pragma hls_ccore_type combinational
inline void Relu (const spec::ActVectorType in, spec::ActVectorType& out) 
{
  // TODO 2: Implement the ReLU activation function using 3rd order Taylor series approximation

  ///////// YOUR IMPLEMENTATION STARTS HERE /////////

  #pragma hls_unroll yes
  for (int i = 0; i < spec::kNumVectorLanes; i++) {

    // Read fixed pt
    ac_fixed<spec::kActWordWidth, spec::kActWordWidth - spec::kActNumFrac, true> x;
    x.set_slc(0, in[i]);

    // ReLU
    ac_fixed<spec::kActWordWidth, spec::kActWordWidth - spec::kActNumFrac, true> y = (x < 0) ? 0 : x;

    // Write back bits
    ac_int<spec::kActWordWidth, true> raw_out = y.template slc<spec::kActWordWidth>(0);
    out[i] = raw_out;
  }

  //////// YOUR IMPLEMENTATION ENDS HERE /////////
}  

#pragma hls_design ccore
#pragma hls_ccore_type combinational
inline void Silu (const spec::ActVectorType in, spec::ActVectorType& out) 
{
  // TODO 3: Implement the SiLU activation function using 3rd order Taylor series approximation
  
  /////// YOUR IMPLEMENTATION STARTS HERE /////////

  #pragma hls_unroll yes
  for (int i = 0; i < spec::kNumVectorLanes; i++) {

    // Read fixed pt
    ac_fixed<spec::kActWordWidth, spec::kActWordWidth - spec::kActNumFrac, true> x;
    x.set_slc(0, in[i]);

    // SiLU
    ac_fixed<spec::kActWordWidth, spec::kActWordWidth - spec::kActNumFrac, true> y;
    
    if (x < -2) {
      y = 0;
    } else if (x > 2) {
      y = x;
    } else{
      y = (ac_fixed<spec::kActWordWidth, spec::kActWordWidth - spec::kActNumFrac, true>)(0.5) * x
      + (ac_fixed<spec::kActWordWidth, spec::kActWordWidth - spec::kActNumFrac, true>)(0.25) * x * x;
    }

    // Write back bits
    ac_int<spec::kActWordWidth, true> raw_out = y.template slc<spec::kActWordWidth>(0);
    out[i] = raw_out;
  }
  
  /////// YOUR IMPLEMENTATION ENDS HERE /////////
}

#pragma hls_design ccore
#pragma hls_ccore_type combinational
inline void Gelu (const spec::ActVectorType in, spec::ActVectorType& out) 
{
  // TODO 4: Implement the GELU activation function using 3rd order Taylor series approximation

  /////// YOUR IMPLEMENTATION STARTS HERE /////////

  #pragma hls_unroll yes
  for (int i = 0; i < spec::kNumVectorLanes; i++) {

    // Read fixed pt
    ac_fixed<spec::kActWordWidth, spec::kActWordWidth - spec::kActNumFrac, true> x;
    x.set_slc(0, in[i]);

    ac_fixed<spec::kActWordWidth, spec::kActWordWidth - spec::kActNumFrac, true> y;

    if (x < -1) {
      y = 0;
    } else if (x > 1) {
      y = x;
    } else {
      y = (ac_fixed<spec::kActWordWidth, spec::kActWordWidth - spec::kActNumFrac, true>)(0.5) * x
      + (ac_fixed<spec::kActWordWidth, spec::kActWordWidth - spec::kActNumFrac, true>)(0.3989422804) * x * x;
    }

    // Write back bits
    ac_int<spec::kActWordWidth, true> raw_out = y.template slc<spec::kActWordWidth>(0);
    out[i] = raw_out;
  }
  
  /////// YOUR IMPLEMENTATION ENDS HERE /////////
  
}  


#endif
