// ============================================================================
// Amazon FPGA Hardware Development Kit
//
// Copyright 2024 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Amazon Software License (the "License"). You may not use
// this file except in compliance with the License. A copy of the License is
// located at
//
//    http://aws.amazon.com/asl/
//
// or in the "license" file accompanying this file. This file is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
// implied. See the License for the specific language governing permissions and
// limitations under the License.
// ============================================================================
`ifndef design_top_DEFINES
`define design_top_DEFINES

        // Put module name of the CL design here. This is used to instantiate in top.sv
`define CL_NAME design_top

`define DDR_A_ABSENT
`define DDR_B_ABSENT


`endif
localparam int kIntWordWidth = 16;
localparam int kNumVectorLanes = 16;
localparam int kActWordWidth = 32;
localparam int kAccumWordWidth = 2*kIntWordWidth + kNumVectorLanes - 1;
localparam int kActNumFrac = 24;

localparam int WIDTH_AXI = 32;
localparam int ADDR_WIDTH_OCL = 16;

// Tranfer Counter
localparam int ADDR_TX_COUNTER_EN = 16'h0400;         // Write 
localparam int ADDR_TX_COUNTER_READ = 16'h0400;       // Read
localparam int ADDR_COMPUTE_COUNTER_READ = 16'h0404;  // Read

// Start enable
localparam int ADDR_START_CFG = 16'h0404;             //Write

// RVA IN Port (Input)
localparam int DATA_WIDTH_RVA_IN = kActWordWidth * kNumVectorLanes;                               // 32 * 16 = 512
localparam int ADDR_WIDTH_RVA_IN = 24;
localparam int WIDTH_RVA_IN = DATA_WIDTH_RVA_IN + ADDR_WIDTH_RVA_IN + 1 + (DATA_WIDTH_RVA_IN >> 3); // 512 + 24 + rw wdith + strobe = 601
localparam int LOOP_RVA_IN =  (int((WIDTH_RVA_IN + 31)/ 32));                                     // 19
localparam int ADDR_RVA_IN_START = 16'h408;

// Act Port (Input)
localparam int WIDTH_ACT_PORT = DATA_WIDTH_RVA_IN;                            // 32 * 16 = 512
localparam int LOOP_ACT_PORT = WIDTH_ACT_PORT / WIDTH_AXI;                    // 16
localparam int ADDR_ACT_PORT_START = ADDR_RVA_IN_START + LOOP_RVA_IN * 4;     // 0x408 + 19*4 = 0x454

// Output Port (Output)
localparam int WIDTH_OUTPUT_PORT = DATA_WIDTH_RVA_IN + 2 + 8;                 // 522 = 512 + 2 (index) + 8 (logical_addr)
localparam int LOOP_OUTPUT_PORT = int((WIDTH_OUTPUT_PORT + 31) / 32);         // 17
localparam int ADDR_OUTPUT_PORT_START = ADDR_COMPUTE_COUNTER_READ + 4;;       // 0x404 + 0x4 = 0x408

// RVA Out Port (Output)
localparam int WIDTH_RVA = DATA_WIDTH_RVA_IN;                                         // 32 * 16 = 512
localparam int LOOP_RVA_OUT = int((WIDTH_RVA + 31) / 32);                     // 16
localparam int ADDR_RVA_OUT_START = ADDR_OUTPUT_PORT_START + LOOP_OUTPUT_PORT * 4;    // 0x408 + 17*4 = 0x44C
