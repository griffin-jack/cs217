# Lab 2: Designing and Analyzing a Hardware Post-Processing Unit (PPU)

> The most important part of any lab assignment is to **start early**! Runtimes for the many simulation and synthesis steps can be up to 3 hours combined, so please plan accordingly.
> Please refer to the provided resources, and ask questions on EdStem or during office hours when you get stuck.

> Please read through this entire README before starting the lab.

## Table of Contents

- [Lab 2: Designing and Analyzing a Hardware Post-Processing Unit (PPU)](#lab-2-designing-and-analyzing-a-hardware-post-processing-unit-ppu)
  - [Table of Contents](#table-of-contents)
  - [1. Introduction and Objectives](#1-introduction-and-objectives)
    - [Activation Functions](#activation-functions)
    - [File Structure](#file-structure)
  - [2. HLS to RTL design of the PPU](#2-hls-to-rtl-design-of-the-ppu)
    - [Task 1: Design and Verify Activation Functions using `ac_math` library](#task-1-design-and-verify-activation-functions-using-ac_math-library)
    - [Task 2: Design and Verify Activation Functions using Piece-Wise Linear (PWL) approximation](#task-2-design-and-verify-activation-functions-using-piece-wise-linear-pwl-approximation)
    - [Task 3: Design and Verify Activation Functions using Taylor Series approximation](#task-3-design-and-verify-activation-functions-using-taylor-series-approximation)
    - [Task 4: Make sure that SystemC simulation for all parameterizations](#task-4-make-sure-that-systemc-simulation-for-all-parameterizations)
    - [Task 5: Generate RTL (HLS-\>RTL) and simulate RTL for all design points](#task-5-generate-rtl-hls-rtl-and-simulate-rtl-for-all-design-points)
  - [3. RTL to F2 implementation of the PPU](#3-rtl-to-f2-implementation-of-the-ppu)
    - [Task 7: Runtime Profiling on AWS F2 Hardware Simulation](#task-7-runtime-profiling-on-aws-f2-hardware-simulation)
    - [Task 8: Running the PPU design on FPGA](#task-8-running-the-ppu-design-on-fpga)
  - [5. Submissions](#5-submissions)
    - [Writeup Submission](#writeup-submission)
    - [Code Submission](#code-submission)
  - [6. References](#6-references)
  - [Appendix](#appendix)

## 1. Introduction and Objectives

Modern computing demands are increasingly addressed by specialized **hardware accelerators** designed to significantly boost performance and energy efficiency for critical workloads like Deep Learning, signal processing, and scientific computation. A key component of these accelerators is the **Post-Processing Unit (PPU)**, which applies non-linear activation functions to the output of the core arithmetic units.

This lab assignment provides a hands-on experience in the complete hardware development flow, from high-level modeling to deployment on a cloud Field-Programmable Gate Array (FPGA) platform. You will design, model, and analyze the post-processing unit (PPU) functionality, ultimately implementing it on an **AWS F2** instance.

The core objectives of this assignment are:

* **Design and Modeling:** To design the PPU using **SystemC** for activation functions like Tanh, ReLU, SiLU, and GELU. You will use three different methods to design all four functions: Catapult `ac_math` functions, custom piecewise linear functions, and Taylor series approximations.
* **Trade-off Analysis:** To understand and quantify the crucial **area-accuracy trade-offs** inherent in hardware design. You will explore how different implementations, such as using Catapult `ac_math` libraries, custom piecewise linear functions, and Taylor series approximations, impact the required silicon area (measured in resources like LUTs and FFs) versus accuracy.
* **FPGA Implementation:** To utilize a High-Level Synthesis (HLS) flow to convert the SystemC design into synthesizable Verilog/VHDL RTL and implement it on the specialized FPGA resources of an **AWS F2** cloud instance.
* **System-Level Performance:** To critically analyze the **overall execution time** of the accelerated task. This involves breaking down the total time into two components: the time spent **transferring data** between the host CPU and the FPGA over the high-speed PCIe bus ($\Delta T_{transfer}$) and the time spent on the **actual computation** within the PPU ($\Delta T_{comp}$). This analysis will reveal the importance of the communication overhead and when an accelerator truly yields a performance benefit.

By the end of this lab, you have working components of both the matrix multiplication processing element from Lab 1 and the PPU from this lab, which can be integrated to compute an entire neural network layer.

### Activation Functions

This lab requires you to implement four common activation functions used in neural networks. You are free to use some approximation for them as long as the percentage difference threshold is below 5% and the MSE threshold is less than 1%. 
To understand the golden reference, refer to `src/ActUnit/testbench.cpp`.
You can also refer to [4] for more details on the mathematical definitions and properties of these functions.

- **Tanh (Hyperbolic Tangent):** A non-linear activation function that squashes input values to a range between -1 and 1. The testbench uses the standard `tanh()` function from `math.h` as a reference.
- **ReLU (Rectified Linear Unit):** A simple and widely used activation function that outputs the input directly if it is positive, and zero otherwise. The testbench uses a simple thresholding: `(input > 0) ? input : 0` as a reference.
- **SiLU (Sigmoid-weighted Linear Unit):** A smooth, non-monotonic activation function that is a self-gated combination of the sigmoid and linear functions (`input * sigmoid(input)`). The testbench uses `input * sigmoid(input)` where `sigmoid(x)` is approximated as `1 / (1 + exp(-x))` as a reference.
- **GELU (Gaussian Error Linear Unit):** A smooth approximation to ReLU that is based on the Gaussian cumulative distribution function. The testbench uses an approximation given by `0.5 * input * (1 + tanh(sqrt(2/M_PI) * (input + 0.044715 * pow(input, 3))))` as a reference.


### File Structure

- `src/`: SystemC source code for the ActUnit and supporting modules.
  - `src/include/`: Header files defining data types and utility functions.
  - `src/ActUnit/`: Source files for the ActUnit implementation and its datapath.
    - `src/ActUnit/PPU/`: Source files for the ac_math PPU implementation.
    - `src/ActUnit/PPUPwl/`: Source files for the piecewise linear PPU implementation.
    - `src/ActUnit/PPUTaylor/`: Source files for the Taylor Series approximation PPU implementation.
- `hls/`: Build directory for high-level synthesis (HLS) and RTL generation.
- `design_top/`: RTL files, integration test benches, and other artifacts for bitstream generation and FPGA programming on AWS F2 instances.
  - `design_top/Makefile`: Makefile for building the FPGA bitstream and running tests.
  - `design_top/test.py`: Python script to automate RTL simulation across the design space.
  - `design_top/setup.sh`: Environment setup script for AWS F2 toolchains.
- `scripts/`: Utility scripts for configuring HLS, logic synthesis, and FPGA programming tasks. You should not need to modify these files.
- `docs/`: Documentation files including slides and reference materials.
- `Makefile`: Top-level Makefile for quickly launching various build and simulation tasks.
- `test.py`: Python script to automate design space exploration at the SystemC and HLS levels.
- `setup.csh`: Environment setup script for HLS toolchains on FarmShare.
- `README.md`: This README file.

---

## 2. HLS to RTL design of the PPU

Fork the lab repository from https://code.stanford.edu/cs217/cs217-lab-2.git to your own namespace as a **private** repository.
The setup steps as usual remain as follows:

```
/farmshare/home/classes/ee/admin/software/bin/rhel8.sh

git clone git@code.stanford.edu:[namespace]/[repo name].git
cd cs217-lab-2
source setup.csh
```

### Task 1: Design and Verify Activation Functions using `ac_math` library

Your first task is to implement the activation functions using the `ac_math` library within the PPU by completing the TODOs in `src/ActUnit/PPU/PPU.h`. You will be implementing the following activation functions: `Tanh`, `Relu`, `Silu`, and `Gelu`.

1.  **Understand the data types:** Pay close attention to `spec::ActVectorType` and `spec::kActNumFrac` defined in `src/include/Spec.h`. The `spec::kActNumFrac` value is crucial for correctly converting `spec::ActVectorType` inputs to `ac_fixed` types, which are required by the `ac_math` libraries.
2.  **Implement the activation functions:** Complete the `TODO` sections in `src/ActUnit/PPU/PPU.h` for `Tanh`, `Relu`, `Silu`, and `Gelu`. Ensure that you correctly convert inputs to `ac_fixed` using the appropriate fractional bits (`spec::kActNumFrac`) before calling `ac_math` functions where applicable.
3.  **Trigger the SystemC simulation and verify that your test passes:**
```bash
cd src/ActUnit
cp PPU/PPU.h ../include/

make clean
make sim_test
make run
```

### Task 2: Design and Verify Activation Functions using Piece-Wise Linear (PWL) approximation
In this task, you will implement the activation functions using custom Piece-Wise Linear (PWL) approximations. This approach often trades off some accuracy for reduced hardware complexity and area. You will be modifying `src/ActUnit/PPUPwl/PPU.h`.

1.  **Understand the PWL approximation:** Familiarize yourself with the concept of PWL approximation for activation functions. You will need to divide the input range into segments and define linear equations for each segment.
2.  **Implement the activation functions:** Complete the `TODO` sections in `src/ActUnit/PPUPwl/PPU.h` for `Tanh`, `Relu`, `Silu`, and `Gelu` using PWL approximations.
3.  **Trigger the SystemC simulation and verify that your test passes:**

```bash
cd src/ActUnit/
cp PPUPwl/PPU.h ../include/

make clean
make sim_test
make run
```

> **Important Note:** A successful SystemC simulation verifies the functional correctness of your high-level model. However, it does not guarantee that the High-Level Synthesis (HLS) tool will generate synthesizable RTL that also passes simulation. Differences in HLS scheduling and optimizations can lead to discrepancies. Therefore, it is highly recommended that you generate RTL and run RTL simulation to fully validate the post-HLS design.

### Task 3: Design and Verify Activation Functions using Taylor Series approximation

In this task, you will implement the activation functions using custom Taylor Series approximations of 3rd degree. This approach can offer higher accuracy than PWL but might require more complex hardware. You will be modifying `src/ActUnit/PPUTaylor/PPU.h`.

1.  **Understand the Taylor Series approximation:** Familiarize yourself with the concept of Taylor Series expansion for approximating functions. You will need to choose an appropriate number of terms for each activation function.
2.  **Implement the activation functions:** Complete the `TODO` sections in `src/ActUnit/PPUTaylor/PPU.h` for `Tanh`, `Relu`, `Silu`, and `Gelu` using Taylor Series approximations.
3.  **Trigger the SystemC simulation and verify that your test passes:**

```bash
cd src/ActUnit/
cp PPUTaylor/PPU.h ../include/

make clean
make sim_test
make run
```

### Task 4: Make sure that SystemC simulation for all parameterizations

After implementing all three versions of the activation functions (ac_math, piecewise linear, and Taylor), we want to make sure that the functionality is good for varying kActWordWidth and kNumVectorLanes across all implementations.

1. Command to test - `python3 test.py --action systemc_sim`
2. The summary table must show passing for all combinations for all three implementations (PPU, PPUPwl, PPUTaylor). Please include this table in the writeup.
3. If any combinations fails, please manually copy the `<failing PPU>/PPU.h` to `src/include` and debug from there.

### Task 5: Generate RTL (HLS->RTL) and simulate RTL for all design points
1. To generate the RTL and check functionality for all three implementations, use the following commands: `python3 test.py --action rtl_sim`.
2. In case any particular case doesn't meet the percentage difference or percentage MSE requirement, please follow these steps to run only that case:

```bash
cp src/ActUnit/<Failing PPU>/PPU.h src/include/

cd hls/ActUnit
make clean
make hls # Generates RTL
make vcs_sim # Simulate RTL

```

1. All three of the above Makefile targets combined might take up to an hour to run. If there are any errors during the HLS or RTL simulation steps, first refer to the standard output log at `hls/ActUnit/catapult.log`. If you are prompted with scheduling errors, you can also check `hls/ActUnit/Catapult/ActUnit.v1/failed_loop0.dot`
2. Include the reported functional and area summary in your writeup. The script will automatically copy the generated RTL and reports to the `design_top/design/concat_ActUnit/PPU`, `design_top/design/concat_ActUnit/PPUPwl` and `design_top/design/concat_ActUnit/PPUTaylor` folders.

Make sure to push these changes to your forked repository for later use by the AWS F2 implementation steps.

Alternatively, The area numbers can be found in `Catapult/ActUnit.v1/ActUnit.rpt`. Search for the keyword "Area Scores" and report the `Post-Assignment` "Total Area Score". The "Total Area Score" is a proxy for the area in um^2. We have synthesized the RTL for generic 45nm technology because the RTL will be used for FPGA bitstream generation. After populating the table, try to reason about the numbers based on what you have learned in the lectures.

---

## 3. RTL to F2 implementation of the PPU

### Task 7: Runtime Profiling on AWS F2 Hardware Simulation

Before running the hardware simulation, complete the TODOs in `design_top/design/design_top.sv`. Use the defines in `design_top/design/design_top_defines.vh` as a reference for your modifications. The aim of this task is to expose you to the integration process and run the hardware simulation for the three different PPU implementations to profile the performance. The performance is profiled using hardware counters that are enabled during the data transfer phase and a separate counter that is enabled during the compute phase.


```bash
# First source the AWS F2 environment
cd ~/aws-fpga
source hdk_setup.sh
source sdk_setup.sh

# Then move to your design_top folder
# After lab0, the library files have already been generated, so this step should work without issues
cd [path-to-lab2-repo]/design_top
source setup.sh

# Run the RTL test over the design space
# and inspect data vs compute cycles
python3 test.py
```

Consolidate both the area and performance tables and draw inferences on the performance/area trade-off.

Refer to `design_top/logs/f2_hw_sim.log.txt` to check detailed output if there are any issues.

### Task 8: Running the PPU design on FPGA

The aim of this task is to run the FPGA image (for default configuration of PPUPwl) and check the accuracy. Clone your forked repository to the AWS F2 instance and make sure that the `design_top/design/concat_ActUnit/` folder has the RTL generated from the previous section. Generate the FPGA build and the AFI ID using the following commands -- this should be nearly identical to the steps followed in Lab 1.

```bash
make fpga_build # this will take about 1.5 hours
make generate_afi

# Only proceed to the next steps if it says available
make check_afi_available

# Once available
make program_fpga
make run_fpga_test
```

Note the data transfer cycles and compute cycles. The data transfer cycles are expected to differ from simulation, but why do the compute cycles also show a discrepancy? Think about how your units got mapped to the FPGA.

## 5. Submissions

Please submit both a writeup and code submission for this lab on Gradescope as they become available.

### Writeup Submission

In the writeup submit a screenshot or a copy of the following summary tables generated from your simulations and analysis:

1. SystemC Simulation Summary Table
2. RTL Simulation and Area Summary Table
3. AWS F2 Hardware Simulation Summary Table
4. FPGA Test

Also summarize your observations and inferences from the design space exploration:

1. Summarize your implementation for PPU, PPUPwl and PPUTaylor.
2. Area implications of different PPU implementations.
3. Data transfer vs compute time breakdown on AWS F2 of different PPU implementations.
4. Simulated vs actual FPGA runtime analysis

In the writeup, please also document how you may have utilized generative AI tools (e.g. ChatGPT/Codex, Gemini, Claude, Cursor, etc.) when completing this lab assignment.

Specifically include the following details:

1. What tools and/or workflows did you use?
2. How have you prompted the generative AI tools? What kind of context did you provide them with?
3. What worked well and what didn't?
4. What are your perceived productivitiy gains from utilizing generative AI tools?

### Code Submission

For the code submission, submit the `lab2-submission.zip` generated by `make submission`. Make sure the following files have the correct implementation / they exist:

1. `src/ActUnit/PPU/PPU.h`
2. `src/ActUnit/PPUPwl/PPU.h`
3. `src/ActUnit/PPUTaylor/PPU.h`
4. `design_top/design/concat_ActUnit/*`
5. `design_top/design/design_top.sv`
6. Required logs (make sure they exist before zipping):
    1. `logs/area.log.txt`
    2. `logs/rtl_sim.log.txt`
    3. `logs/systemc_sim.log.txt`
    4. `design_top/logs/f2_hw_sim.log.txt`
    5. `design_top/logs/fpga_test.log.txt`

## 6. References

[1] T. Tambe et al., “9.8 A 25mm2 SoC for IoT Devices with 18ms Noise-Robust Speech-to-Text Latency via Bayesian Speech Denoising and Attention-Based Sequence-to-Sequence DNN Speech Recognition in 16nm FinFET,” in 2021 IEEE International Solid-State Circuits Conference (ISSCC), Feb. 2021, pp. 158–160. doi: 10.1109/ISSCC42613.2021.9366062.

[2] Y. S. Shao et al., “Simba: Scaling Deep-Learning Inference with Multi-Chip-Module-Based Architecture,” in Proceedings of the 52nd Annual IEEE/ACM International Symposium on Microarchitecture, in MICRO-52. New York, NY, USA: Association for Computing Machinery, Oct. 2019, pp. 14–27. doi: 10.1145/3352460.3358302.

[3] R. Venkatesan et al., “MAGNet: A Modular Accelerator Generator for Neural Networks,” in 2019 IEEE/ACM International Conference on Computer-Aided Design (ICCAD), Nov. 2019, pp. 1–8. doi: 10.1109/ICCAD45719.2019.8942127.

[4] S. R. Dubey, S. K. Singh, and B. B. Chaudhuri, “Activation Functions in Deep Learning: A Comprehensive Survey and Benchmark,” Jun. 28, 2022, arXiv: arXiv:2109.14545. doi: 10.48550/arXiv.2109.14545.

## Appendix

For this lab, you will find the following documentation useful. They are available on Canvas and in the Catapult installation path at `/cad/mentor/2024.2_1/Mgc_home/shared/pdfdocs`.

- `ac_datatypes_ref.pdf`: **Algorithmic C Datatypes Reference Manual.** This is your primary reference for understanding the `ac_fixed` datatype, which is crucial for this lab. It covers how to declare, initialize, and manipulate fixed-point numbers.
- `ac_math_ref.pdf`: **Algorithmic C Math Library Reference Manual.** This document provides detailed information on the `ac_math` library, which contains functions like `ac_math::ac_tanh_pwl`that you will use in Task 1.
- `connections-guide.pdf`: **Connections Library Guide.** This guide explains how to use the Connections library for communication between SystemC modules. While not the primary focus of this lab, it's a good reference for understanding how data is passed between different parts of a SystemC design.
- `catapult_useref.pdf`: **Catapult HLS User and Reference Manual.** This manual is a comprehensive guide to the Catapult HLS tool. It covers everything from basic usage to advanced synthesis directives and pragmas. You will find it useful for understanding the HLS process and for debugging any HLS-related issues.

