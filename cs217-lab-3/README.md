# Lab 3: Designing a Global Buffer and Near Memory Processor (NMP)

> Please pay close attention to the reading materials in the Reference and Appendix sections. A major part of this lab is to understand the implementation of various library components and subroutines and correctly apply them in your design. The machine runtimes are under an hour for the overall lab

## Table of Contents

- [Table of Contents](#table-of-contents)
- [1. Introduction and Objectives](#1-introduction-and-objectives)
  - [File Structure](#file-structure)
- [2. Architecture Overview and SystemC Design](#2-architecture-overview-and-systemc-design)
  - [GBCore: Global Buffer Core](#gbcore-global-buffer-core)
  - [NMP: Near Memory Processor](#nmp-near-memory-processor)
- [3. HLS to RTL Design](#3-hls-to-rtl-design)
  - [Task 1: Configure the Global Buffer SRAM](#task-1-configure-the-global-buffer-sram)
  - [Task 2: Implement RMSNorm and Softmax in the NMP](#task-2-implement-rmsnorm-and-softmax-in-the-nmp)
  - [Task 3: Integration of GBCore and NMP](#task-3-integration-of-gbcore-and-nmp)
  - [Task 4: Generate RTL and RTL Simulation](#task-4-generate-rtl-and-rtl-simulation)
    - [Building Submodules](#building-submodules)
- [4. RTL to FPGA Implementation](#4-rtl-to-fpga-implementation)
  - [Task 6: AWS F2 SystemVerilog Simulation](#task-6-aws-f2-systemverilog-simulation)
  - [Task 7: Program Bitstream and Run on F2 FPGA](#task-7-program-bitstream-and-run-on-f2-fpga)
- [5. Submissions](#5-submissions)
  - [Writeup Submission](#writeup-submission)
  - [Code Submission](#code-submission)
- [6. References](#6-references)
  - [Bibliography](#bibliography)
  - [Documentation](#documentation)
- [Appendix A: Mathematical Background](#appendix-a-mathematical-background)
  - [A.1 RMSNorm (Root Mean Square Normalization)](#a1-rmsnorm-root-mean-square-normalization)
  - [A.2 Softmax](#a2-softmax)
- [Appendix B: SRAM Buffers and Arbitrated Scratchpad](#appendix-b-sram-buffers-and-arbitrated-scratchpad)
  - [B.1 Instantiation and Template Parameters](#b1-instantiation-and-template-parameters)
  - [B.2 Interface Signals](#b2-interface-signals)
  - [B.3 Request/Acknowledgement Flow](#b3-requestacknowledgement-flow)
  - [B.4 Usage Example](#b4-usage-example)
  - [B.5 Other Notes](#b5-other-notes)

## 1. Introduction and Objectives

In this lab, you will design and implement a **Global Buffer (GB) module** with an integrated **Near Memory Processor (NMP)** for the neural network accelerator whose processing elements you designed in Labs 1 and 2.
The global buffer provides multi-banked, SRAM-based storage for weights and activations, while the NMP performs various nonlinear normalization operations on the data stored in the buffer.
This organization, specifically the co-location of the NMP near the memory, is helpful for reducing energy and latency for data movement in modern deep learning workloads.

These modules are partially based on the FlexASR architecture presented in [1] and [2].
The objectives of this lab are to design, implement, and verify the following components:

- **Global buffer design:** Instantiate and configure an SRAM-based global buffer using MatchLib's `ArbitratedScratchpadDP` component. You will determine the appropriate number of banks, read/write ports, and entries per bank to meet capacity requirements.
- **Near Memory Processing:** Implement **RMSNorm** and **Softmax** operations within the NMP module. These operations require multiple reads and writes to the global buffer and orchestration via a finite state machine (FSM).
- **System Integration:** Connect the GBCore and NMP modules via Connections ports and AXI interfaces. You will also verify the design through SystemC simulation, RTL generation, and FPGA implementation on AWS F2 hardware.

### File Structure

- `src/`: SystemC source code for GBModule and supporting modules.
  - `src/include/`: Header files defining data types, buffer specifications, and utility functions.
  - `src/GBModule/`: Top-level GBModule with GBCore and NMP submodules.
    - `src/GBModule/GBCore/`: SRAM-based global buffer core implementation.
    - `src/GBModule/NMP/`: Near Memory Processor for RMSNorm and Softmax.
- `hls/`: Build directory for high-level synthesis (HLS) and RTL generation.
  - `hls/GBModule/`: HLS project for the complete GBModule.
- `design_top/`: RTL files, integration testbenches, and artifacts for AWS F2 FPGA.
  - `design_top/design/`: Generated RTL files after HLS.
  - `design_top/verif/`: SystemVerilog testbenches for RTL co-simulation.
  - `design_top/software/`: C software for FPGA control.
  - `design_top/Makefile`: Makefile for FPGA build and testing.
  - `design_top/setup.sh`: Environment setup script for AWS F2 toolchains.
- `scripts/`: Utility scripts for HLS and synthesis tasks.
- `Makefile`: Top-level Makefile for common build tasks.
- `setup.csh`: Environment setup script for HLS toolchains on FarmShare.
- `README.md`: This README file.


## 2. Architecture Overview and SystemC Design

The GBModule consists of two main modules: the **GBCore** (Global Buffer Core) and the **NMP** (Near Memory Processor).

### GBCore: Global Buffer Core

The GBCore implements a large SRAM-based buffer using MatchLib's `ArbitratedScratchpadDP`.
Key characteristics:

- **Word Type:** Each entry in the scratchpad is a 128-bit vector (`spec::VectorType`) containing 16 elements of 8-bit floating-point data (`spec::NMP::AdpType`).
- **Capacity:** 1 MB total (4096 entries/bank * 16 banks * 128 bits/entry)
- **Ports:** 16 read ports, 1 write port. Even though in this lab we only use a single write port, the full FlexASR design supports other modules that may access the buffer concurrently.
- **Interface:** 
  - AXI configuration for base addresses and stride information
  - Connections port-based request/response interface for NMP data access

> Note that the original FlexASR design had both a large and small SRAM buffer with more complex access patterns. For this lab, we simplify to a single unified activation buffer more similar to the Google TPU, among others. Though you still may see references to a `GB::Large` namespace or variable names in the code.

### NMP: Near Memory Processor

The NMP performs vector normalization operations in-place on data stored in the GBCore. It supports two modes corresponding to different operations:

| Mode | Operation | Description |
|------|-----------|-------------|
| 0 | RMSNorm | Root Mean Square Normalization |
| 1 | Softmax | Softmax activation function |

The NMP uses a finite state machine (FSM) to orchestrate memory accesses.
The high-level operation flow is as follows:

1. `IDLE`: Wait for a start signal from the AXI configuration interface and read NMP configuration.
2. `PRE/READ`: Issue read request to GBCore and receive vector data
3. `RMS_*/SOFTMAX_*`: Perform computation steps for RMSNorm or Softmax
4. `WRITE`: Write normalized result back to GBCore
5. `NEXT`: Update counters and loop until all vectors are processed
6. `FIN`: Signal completion and return to IDLE

Please refer to the appendix for mathematical background on RMSNorm and *stable* Softmax and complete the TODO items in `NMP.h` to implement the core computation functions.
In the meantime, note that the input/output data types are FP8 (`spec::NMP::AdpType`), while intermediate computations use higher-precision fixed-point types (`spec::NMP::FixedType` and `spec::NMP::AccumType`) to maintain numerical accuracy.
The number format conversions are already handled in the provided code.

## 3. HLS to RTL Design

Fork the lab repository and set up your environment similar to previous labs:

```bash
/farmshare/home/classes/ee/admin/software/bin/rhel8.sh

git clone git@code.stanford.edu:[namespace]/[repo-name].git
cd cs217-lab-3
source setup.csh
```

### Task 1: Configure the Global Buffer SRAM

Examine the SRAM configuration in `src/include/GBSpec.h` and complete any TODO items related to SRAM access in `src/GBModule/GBCore/GBCore.h`.
Refer to the appendix for details on the `ArbitratedScratchpadDP` component.

Ensure that the read/write tests in the SystemC testbench (`src/GBModule/testbench.cpp`) pass successfully.

```bash
# From project root
cd src/GBModule/GBCore
# Complete your implementation, then run:
make clean
make
```

### Task 2: Implement RMSNorm and Softmax in the NMP

Complete the core computation functions for RMSNorm and Softmax in `src/GBModule/NMP/NMP.h`.
Note the pipelined structure of the FSM where different states correspond to different computation steps for either operation.
Refer to the appendix for mathematical details.

Ensure that the NMP tests in the SystemC testbench (`src/GBModule/testbench.cpp`) pass successfully.

```bash
# From project root
cd src/GBModule/NMP
# Complete your implementation, then run:
make clean
make
# For debugging, you can run:
make sim_test_debug
./sim_test
```

Note that the NMP tests compare your output against a golden reference calculated in C++ floating-point.
The comparison uses tolerance-based matching:

- **Absolute tolerance:** 0.5
- **Percent tolerance:** 10%

The testbench would fail only if both tolerances are exceeded.
For your refernence, the solution implementation would yield a maximum percent error of ~5%.

### Task 3: Integration of GBCore and NMP

After completing the GBCore and NMP modules, ensure they are properly integrated in `src/GBModule/GBModule.h` by running the integration test (`src/GBModule/testbench.cpp`):

1. AXI configuration read/write for GBCore and NMP
1. Direct AXI read/write of GBCore large SRAM
1. Softmax operation via NMP with result verification
1. RMSNorm operation via NMP with result verification


```bash
# From project root
cd src/GBModule
# Complete your integration, then run:
make clean
make
# For debugging, you can run:
make sim_test_debug
./sim_test
```

**TODO**: Record the simulation log output showing all SystemC tests passing and include it in your submission.

### Task 4: Generate RTL and RTL Simulation

Generate RTL from the SystemC design using Catapult HLS and run RTL simulation:

```bash
cd hls/GBModule
make clean
make
# For debugging, you can run:
make sim_test_debug
./sim_test
```

Similar to previous labs, if you encounter synthesis errors, check `hls/GBModule/catapult.log` for details and specifically look for scheduling issues in `hls/GBModule/Catapult/GBModule.v1/failed_loop0.dot`.

After a successful HLS build, copy the generated RTL to the `design_top` folder for RTL simulation:

```bash
# from project root
make copy_rtl
```

The generated RTL is automatically copied to `design_top/design/concat_GBModule.v`.
This target also generates the `reports` folder containing synthesis reports and the RTL simulation log.
Commit these files to your repository for later FPGA synthesis.

**TODO**: Record the simulation log output showing all post-HLS RTL tests passing and include it in your submission.

#### Building Submodules

If you want to individually build the GBCore and NMP submodules in HLS, you can do so by navigating to their respective directories:

```bash
# Build GBCore
cd hls/GBModule/GBCore
make clean
make
# Build NMP
cd hls/GBModule/NMP
make clean
make
```

However, the build of the top-level GBModule will automatically build these submodules as dependencies, so this "bottom-up" approach is optional.

## 4. RTL to FPGA Implementation

Clone your lab respository to AWS F2 and set up the environment.
Again, this should be similar to previous labs:

```bash
# SSH into AWS F2 instance

# Source AWS F2 environment
cd ~/aws-fpga
source hdk_setup.sh
source sdk_setup.sh

# Move to design_top folder
cd [path-to-lab3-repo]/design_top
source setup.sh
```

### Task 6: AWS F2 SystemVerilog Simulation

Run hardware simulation on AWS F2 for the synthesized RTL:

```bash
# Run RTL simulation
make hw_sim
```

**TODO**: Record the simulation log output showing all hardware simulation tests passing and include it in your submission.

### Task 7: Program Bitstream and Run on F2 FPGA

Build the FPGA bitstream, generate the AFI, and program the FPGA:

```bash
cd design_top

make fpga_build          # ~25-30 minutes
make generate_afi

# Wait for AFI to become available
make check_afi_available

# Once available
make program_fpga
make run_fpga_test
```

Commit the generated logs in `design_top/logs/` to your repository.

**TODO**: Record the FPGA test log output showing the test passing and include it in your submission.

## 5. Submissions

### Writeup Submission

Submit a writeup including:

- Output from the SystemC simulation of the GBModule
- Output from the RTL simulation of the GBModule after running HLS
- Output from the AWS F2 hardware simulation
- Output from the AWS F2 FPGA test

Also document your use of generative AI tools (ChatGPT, Claude, Copilot, etc.):

- What tools and workflows did you use?
- How did you prompt the tools? What context did you provide?
- What worked well and what didn't?
- What productivity gains did you observe?

### Code Submission

Submit `lab3-submission.zip` generated by `make submission`. Ensure these files exist:

1. `src/GBModule/GBCore/GBCore.h`: GBCore implementation
2. `src/GBModule/NMP/NMP.h`: NMP implementation
3. `design_top/design/concat_GBModule.v`: Generated RTL after HLS
4. `reports`: HLS synthesis reports and simulation logs
    1. `report/hls/GBModule.rpt`
    2. `report/hls/GBModule_hls_sim.log`
    3. `report/aws/f2_hw_sim.log.txt`
    4. `report/aws/fpga_test.log.txt`

## 6. References

### Bibliography

[1] T. Tambe et al., “9.8 A 25mm2 SoC for IoT Devices with 18ms Noise-Robust Speech-to-Text Latency via Bayesian Speech Denoising and Attention-Based Sequence-to-Sequence DNN Speech Recognition in 16nm FinFET,” in 2021 IEEE International Solid-State Circuits Conference (ISSCC), Feb. 2021, pp. 158–160. doi: 10.1109/ISSCC42613.2021.9366062.

[2] Y. S. Shao et al., “Simba: Scaling Deep-Learning Inference with Multi-Chip-Module-Based Architecture,” in Proceedings of the 52nd Annual IEEE/ACM International Symposium on Microarchitecture, in MICRO-52. New York, NY, USA: Association for Computing Machinery, Oct. 2019, pp. 14–27. doi: 10.1145/3352460.3358302.

[3] T. Tambe et al., “AdaptivFloat: A Floating-point based Data Type for Resilient Deep Learning Inference,” Feb. 11, 2020, arXiv: arXiv:1909.13271. doi: 10.48550/arXiv.1909.13271.

### Documentation

Refer to the following documentation items for SystemC and MatchLib found both on Canvas and `/cad/mentor/2024.2_1/Mgc_home/shared/pdfdocs` or `/cad/mentor/2024.2_1/Mgc_home/shared/examples/matchlib/toolkit/doc`.

- `ac_datatypes_ref.pdf`: Algorithmic C datatypes reference manual. Specifically, see `ac_fixed` and `ac_float` classes.
- `ac_math_ref.pdf`: Algorithmic C math library reference manual. Specifically, see functions for power, reciprocal, and square root.
- `connections-guide.pdf`, `connections_reference_doc.pdf`: Documentations for the Connections library including detailed information on `Push`/`Pop` semantics and coding best practices.
- `catapult_useref.pdf`: User reference manual for Catapult HLS including pragmas and synthesis directives. 
- `matchlib_reference_manual.pdf`: MatchLib reference manual including component descriptions and usage examples.
- `https://nvlabs.github.io/matchlib`: MatchLib online documentation including component reference and tutorials.

## Appendix A: Mathematical Background

A recurring theme you will see in implementing the normalization operations is the avoidance of unnecessary division operations and a focus on numerical stability, where values are kept within a reasonable range to avoid overflow/underflow of fixed-point representations.

### A.1 RMSNorm (Root Mean Square Normalization)

RMSNorm is a simplification of Layer Normalization that removes the mean-centering step.
It involves dividing the input vector by its root mean square (RMS) value.

$$\text{RMSNorm}(x_i) = \frac{x_i}{\text{RMS}(\mathbf{x})}$$

where:
$$\text{RMS}(\mathbf{x}) = \sqrt{\frac{1}{n}\sum_{i=1}^{n} x_i^2 + \epsilon}$$

Note the following implementation details:

1. Given that we need to divide each value by the RMS, it is more efficient to compute the reciprocal of the RMS once and multiply each element by this reciprocal. See the `GBModule::NMP::rms_reciprocal` variable for this purpose.
2. The RMS computation involves squaring each element, summing them up, dividing by the number of elements, and taking the square root. This may take multiple cycles in a pipelined design; specifically, we may need to stream the input vector over multiple cycles and accumulate the sum of squares over each portion of the vector.
3. A small constant $\epsilon$ is added inside the square root to ensure numerical stability and avoid division by zero.

### A.2 Softmax

In the context of a neural network, the Softmax function is often used to convert raw logits into probabilities.
In other words, given a vector of real numbers, Softmax produces a vector of the same size where each element is in the range (0, 1) and the elements sum to 1.
The mathematical definition is:

$$\text{Softmax}(x_i) = \frac{e^{x_i}}{\sum_{j=1}^{n} e^{x_j}}$$

However, directly implementing this in hardware can lead to numerical instability. Specifically, if an element $x_i$ is somewhat large, then $e^{x_i}$ can overflow the fixed-point representation.
To mitigate this, we use a numerically stable version of Softmax that shifts the input values by subtracting the maximum value in the vector before exponentiation.

$$\text{Stable-Softmax}(x_i) = \frac{e^{x_i - \max(\textbf{x})}}{\sum_{j=1}^{n} e^{x_j - \max(\textbf{x})}}$$

This means implementing Softmax involves the following steps:

1. Find the maximum value in the input vector. This can be done using an unrolled comparison loop over the vector elements or by a comparison tree for $O(\log n)$ latency.
2. Subtract this maximum value from each element in the vector before exponentiation.
3. Compute the exponentials of the shifted values. This requires a piecewise linear approximation using the `ac_math` library.
4. Accumulate the sum of these exponentials and compute the reciprocal of this sum.
5. Finally, multiply each exponential value by the reciprocal of the sum to obtain the final Softmax output.

## Appendix B: SRAM Buffers and Arbitrated Scratchpad

The `ArbitratedScratchpadDP` is a multi-ported SRAM module from MatchLib that allows simultaneous read and write accesses. 
It is used in the GBCore to implement the global buffer storage (the "Large" scratchpad in the source code).
The "arbitrated" aspect means that when multiple read or write requests target the same memory bank through different ports, the scratchpad internally arbitrates these requests to ensure correct operation.

Refer to the official [MatchLib docstring](https://nvlabs.github.io/matchlib/class_arbitrated_scratchpad_d_p.html) or the source file at `/cad/mentor/2024.2_1/Mgc_home/shared/pkgs/matchlib/cmod/include/ArbitratedScratchpadDP.h` for more details.

### B.1 Instantiation and Template Parameters

```cpp
ArbitratedScratchpadDP<kNumBanks, kNumReadPorts, kNumWritePorts, kEntriesPerBank, WordType, isSF, IsSPRAM>
```

| Parameter | Description |
|-----------|-------------|
| `kNumBanks` | Number of internal memory banks for parallel access |
| `kNumReadPorts` | Number of simultaneous read ports |
| `kNumWritePorts` | Number of simultaneous write ports |
| `kEntriesPerBank` | Depth of each bank (number of entries) |
| `WordType` | Data type stored in memory |
| `isSF` | Store-forward enable - enables data forwarding from write to read on same address (default: `true`) |
| `IsSPRAM` | Single-port RAM mode - when `true`, only read OR write is allowed per cycle, not both (default: `false`) |

### B.2 Interface Signals

The scratchpad requires the following interface signals, organized as arrays indexed by port number:

| Signal | Direction | Description |
|--------|-----------|-------------|
| `read_address[i]` | Input | Address to read from on port `i` |
| `read_req_valid[i]` | Input | Indicates a valid read request for port `i` |
| `read_ready[i]` | Input | Indicates port `i` is ready to accept read data |
| `read_ack[i]` | Output | Acknowledges that read request was granted on port `i` |
| `port_read_out[i]` | Output | Data read from memory on port `i` |
| `port_read_out_valid[i]` | Output | Indicates read output data is valid on port `i` |
| `write_address[i]` | Input | Address to write to on port `i` |
| `write_req_valid[i]` | Input | Indicates a valid write request for port `i` |
| `write_data[i]` | Input | Data to write on port `i` |
| `write_ack[i]` | Output | Acknowledges that write was completed on port `i` |

### B.3 Request/Acknowledgement Flow

The arbitrated scratchpad requires the following protocol for read and write requests:

1. **Setup**: Set read/write address and data (for writes)
2. **Request**: Assert `req_valid` to indicate request is valid
3. **Arbitration**: Scratchpad performs internal arbitration and bank access
4. **Acknowledgement**: If granted, `ack` signal asserts for one cycle
5. **Data Output**: For reads, data appears on `read_out` with `read_out_valid` asserted


### B.4 Usage Example

```cpp
// 1. Declare the scratchpad
ArbitratedScratchpadDP<
    kNumBanks,        // e.g., 8 banks
    kNumReadPorts,    // e.g., 8 read ports
    kNumWritePorts,   // e.g., 1 write port
    kEntriesPerBank,  // e.g., 64 entries per bank
    WordType,         // e.g., NVUINT64
    false,            // No store-forward
    true              // Single-port RAM mode
> my_mem;

// 2. Declare interface signal arrays
Address read_addrs[kNumReadPorts];
bool read_req_valid[kNumReadPorts];
bool read_ready[kNumReadPorts];
bool read_ack[kNumReadPorts];
WordType port_read_out[kNumReadPorts];
bool port_read_out_valid[kNumReadPorts];

Address write_addrs[kNumWritePorts];
bool write_req_valid[kNumWritePorts];
WordType write_data[kNumWritePorts];
bool write_ack[kNumWritePorts];

// 3. Set up read/write requests
read_addrs[0] = target_address;
read_req_valid[0] = 1;
read_ready[0] = 1;

// 4. Call run() method each clock cycle
my_mem.run(
    read_addrs, read_req_valid,
    write_addrs, write_req_valid, write_data,
    read_ack, write_ack, read_ready,
    port_read_out, port_read_out_valid
);

// 5. Check acknowledgement and read data
if (port_read_out_valid[0]) {
    // Data is available in port_read_out[0]
}
```

### B.5 Other Notes

- When `IsSPRAM=true`, simultaneous read and write to the same bank will prioritize the write, and the read will not be acknowledged.
- The address space is banked: lower bits select the bank, upper bits select the entry within the bank. You do not have to worry about this.
- Reset all interface signals before each cycle to avoid stale requests.
