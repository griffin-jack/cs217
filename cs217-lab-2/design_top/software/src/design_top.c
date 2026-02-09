#include <fpga_mgmt.h>
#include <fpga_pci.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include <time.h>
#include "design_top.h"

// #define DEBUG

// --- Testbench Helper Functions (Adapted from SystemVerilog tasks) ---

int ocl_wr32(int bar_handle, uint16_t addr, uint32_t data) {
    if (fpga_pci_poke(bar_handle, addr, data)) {
        fprintf(stderr, "ERROR: MMIO write failed at addr=0x%04x\n", addr);
        return 1;
    }
    return 0;
}

int ocl_rd32(int bar_handle, uint16_t addr, uint32_t *data) {
    if (fpga_pci_peek(bar_handle, addr, data)) {
        fprintf(stderr, "ERROR: MMIO read failed at addr=0x%04x\n", addr);
        return 1;
    }
    return 0;
}

/**
 * @brief Formats the RVA message based on the SV testbench.
 * rva_msg[600] = rw;
 * rva_msg[599:536] = wstrb (all 1s);
 * rva_msg[535:512] = addr;
 * rva_msg[511:0] = data;
 */
void rva_format(bool rw, uint32_t addr, const uint32_t data[LOOP_RVA_OUT], uint32_t rva_msg[LOOP_RVA_IN]) {
    // Zero out the message buffer
    for (int i = 0; i < LOOP_RVA_IN; i++) {
        rva_msg[i] = 0;
    }

    // Copy data (511:0)
    // data is 512 bits, which is 16 words.
    for (int i = 0; i < LOOP_RVA_OUT; i++) {
        rva_msg[i] = data[i];
    }

    // Pack addr (535:512)
    // 512 = 16 * 32. So addr starts at rva_msg[16].
    // addr is 24 bits.
    rva_msg[16] = addr & 0xFFFFFF;

    // Pack wstrb (599:536)
    // 536 = 16 * 32 + 24. So wstrb starts at bit 24 of rva_msg[16].
    // wstrb is 64 bits wide.
    rva_msg[16] |= 0xFF000000; // bits 536-543
    rva_msg[17] = 0xFFFFFFFF; // bits 544-575
    rva_msg[18] = 0x00FFFFFF; // bits 576-599

    // Pack rw bit (at bit 600)
    // 600 = 18 * 32 + 24. So it's in rva_msg[18] at bit index 24.
    if (rw) {
        rva_msg[18] |= (1 << 24);
    }
}

int ocl_rva_wr32(int bar_handle, const uint32_t rva_msg[LOOP_RVA_IN]) {
    uint16_t addr;
    for (int i = 0; i < LOOP_RVA_IN; i++) {
        addr = ADDR_RVA_IN_START + i * 4;
        #ifdef DEBUG
        printf("Writing RVA word %d to addr 0x%04x: 0x%08x\n", i, addr, rva_msg[i]);
        #endif
        if (ocl_wr32(bar_handle, addr, rva_msg[i])) {
            return 1;
        }
    }
    return 0;
}

int ocl_act_wr(int bar_handle, const uint32_t data[LOOP_ACT_PORT]) {
    uint16_t addr;
    for (int i = 0; i < LOOP_ACT_PORT; i++) {
        addr = ADDR_ACT_PORT_START + i * 4;
        if (ocl_wr32(bar_handle, addr, data[i])) {
            return 1;
        }
    }
    return 0;
}

// --- Golden Reference Models (from SV test) ---

double sigmoid_ref(double val) {
    return 1.0 / (1.0 + exp(-val));
}

void tanh_ref(const int32_t vec_in[kNumVectorLanes], int32_t vec_out[kNumVectorLanes]) {
    for (int i = 0; i < kNumVectorLanes; i++) {
        double in_float = FIXED_TO_FLOAT(vec_in[i]);
        double out_float = tanh(in_float);
        vec_out[i] = FLOAT_TO_FIXED(out_float);
    }
}

void silu_ref(const int32_t vec_in[kNumVectorLanes], int32_t vec_out[kNumVectorLanes]) {
    for (int i = 0; i < kNumVectorLanes; i++) {
        double in_float = FIXED_TO_FLOAT(vec_in[i]);
        double out_float = in_float * sigmoid_ref(in_float);
        vec_out[i] = FLOAT_TO_FIXED(out_float);
    }
}

void gelu_ref(const int32_t vec_in[kNumVectorLanes], int32_t vec_out[kNumVectorLanes]) {
    for (int i = 0; i < kNumVectorLanes; i++) {
        double in_float = FIXED_TO_FLOAT(vec_in[i]);
        double temp = 14.0 / 22.00;
        double sqrt_pi = sqrt(temp);
        double out_float = 0.5 * in_float * (1 + tanh(sqrt_pi * (in_float + 0.044715 * pow(in_float, 3))));
        vec_out[i] = FLOAT_TO_FIXED(out_float);
    }
}

void relu_ref(const int32_t vec_in[kNumVectorLanes], int32_t vec_out[kNumVectorLanes]) {
    for (int i = 0; i < kNumVectorLanes; i++) {
        double in_float = FIXED_TO_FLOAT(vec_in[i]);
        double out_float = (in_float > 0) ? in_float : 0;
        vec_out[i] = FLOAT_TO_FIXED(out_float);
    }
}

void randomize_vector(uint32_t vec[kNumVectorLanes]) {
    for (int i = 0; i < kNumVectorLanes; i++) {
        vec[i] = rand();
    }
}

void compare_act_vectors(const uint32_t dut_vec_flat[LOOP_OUTPUT_PORT], const int32_t golden_vec[kNumVectorLanes]) {
    double diff_sum = 0.0;
    double mse_sum = 0.0;

    // Extract the 512-bit data payload from the 522-bit output port
    const int32_t *dut_vec = (const int32_t *)dut_vec_flat;

    printf("\n---- Final Output Vector Comparison ----\n");
    for (int j = 0; j < kNumVectorLanes; j++) {
        double a = FIXED_TO_FLOAT(dut_vec[j]);
        double e = FIXED_TO_FLOAT(golden_vec[j]);
        
        double diff = fabs(a - e);
        double term;
        if (fabs(e) < 1) { // Avoid division by zero
            term = diff;
        } else {
            term = diff / fabs(e);
        }
        
        diff_sum += term;
        mse_sum += diff * diff;

        printf("OutputPort Computed value = %f and expected value = %f (lane %02d)  err=%0.3f%%\n",
               a, e, j, 100.0 * term);
    }

    double avg_pct = (diff_sum * 100.0) / kNumVectorLanes;
    double avg_mse = (mse_sum * 100.0) / kNumVectorLanes;
    printf("Dest: Average difference observed in compute Act and expected value %0.3f%%\n", avg_pct);
    printf("Dest: MSE observed in compute Act: %0.6f%%\n", avg_mse);

    if (avg_pct > 5.0 || avg_mse > 1.0) {
        fprintf(stderr, "TEST FAILED: Average error / MSE too high.\n");
    } else {
        printf("TEST PASSED\n");
    }
}

// --- Counter Functions ---

int start_data_transfer_counter(int bar_handle) {
    return ocl_wr32(bar_handle, ADDR_TX_COUNTER_EN, 1);
}

int stop_data_transfer_counter(int bar_handle) {
    return ocl_wr32(bar_handle, ADDR_TX_COUNTER_EN, 0);
}

int get_data_transfer_cycles(int bar_handle, uint32_t *cycles) {
    return ocl_rd32(bar_handle, ADDR_TX_COUNTER_READ, cycles);
}

int get_compute_cycles(int bar_handle, uint32_t *cycles) {
    return ocl_rd32(bar_handle, ADDR_COMPUTE_COUNTER_READ, cycles);
}

// ----------------------------------------------------------------------------
// MAIN EXECUTION LOGIC (from design_top_base_test.sv)
// ----------------------------------------------------------------------------
int main(int argc, char **argv) {
    if (argc != 2) {
        printf("Usage: %s <slot_id>\n", argv[0]);
        return 1;
    }

    srand(time(NULL));

    int slot_id = atoi(argv[1]);
    int bar_handle = -1;

    uint32_t rva_in_msg[LOOP_RVA_IN];
    uint32_t rva_in_data[LOOP_RVA_OUT] = {0};
    uint32_t rva_in_addr;

    uint32_t test_in[4][kNumVectorLanes];
    int32_t expected_out[4][kNumVectorLanes];
    uint32_t output_obtained_flat[4][LOOP_OUTPUT_PORT];

    // --- 1. Initialization and Attachment ---
    if (fpga_mgmt_init() != 0) {
        fprintf(stderr, "Failed to initialize fpga_mgmt\n");
        return 1;
    }

    if (fpga_pci_attach(slot_id, FPGA_APP_PF, APP_PF_BAR0, 0, &bar_handle)) {
        fprintf(stderr, "fpga_pci_attach failed\n");
        return 1;
    }
    printf("---- System Initialization (bar_handle: %d) ----\n", bar_handle);

    // --- 2. Test Setup ---
    for (int i = 0; i < 4; i++) {
        randomize_vector(test_in[i]);
    }

    // Calculate all expected outputs first
    tanh_ref((int32_t*)test_in[0], expected_out[0]);
    silu_ref((int32_t*)test_in[1], expected_out[1]);
    gelu_ref(expected_out[1], expected_out[2]); // Note: gelu input is output of silu
    relu_ref(expected_out[2], expected_out[3]); // Note: relu input is output of gelu

    // --- 3. Configure ActUnit via RVA ---
    printf("\n---- CONFIGURE ActUnit ----\n");
    start_data_transfer_counter(bar_handle);

    // Config 1
    memset(rva_in_data, 0, sizeof(rva_in_data));
    rva_in_data[0] = 0x0A040001;
    rva_in_data[1] = 0x00000101;
    rva_in_addr = 0x800010;
    rva_format(true, rva_in_addr, rva_in_data, rva_in_msg);
    if (ocl_rva_wr32(bar_handle, rva_in_msg)) goto error_detach;

    // Config 2
    memset(rva_in_data, 0, sizeof(rva_in_data));
    rva_in_data[0] = 0x3440B030;
    rva_in_data[1] = 0x44F444E4;
    rva_in_data[2] = 0x000044C4;
    rva_in_addr = 0x800020;
    rva_format(true, rva_in_addr, rva_in_data, rva_in_msg);
    if (ocl_rva_wr32(bar_handle, rva_in_msg)) goto error_detach;

    // Config 3
    memset(rva_in_data, 0, sizeof(rva_in_data));
    rva_in_data[0] = 0x1C2444D4;
    rva_in_data[1] = 0x0000004C;
    rva_in_addr = 0x800030;
    rva_format(true, rva_in_addr, rva_in_data, rva_in_msg);
    if (ocl_rva_wr32(bar_handle, rva_in_msg)) goto error_detach;

    // --- 4. Start Computation ---
    printf("\n---- START ----\n");
    if (ocl_wr32(bar_handle, ADDR_START_CFG, 0x1)) goto error_detach;
    usleep(100); // Wait for config to be processed
    stop_data_transfer_counter(bar_handle);

    // --- 5. Provide Inputs and Read Outputs ---
    printf("\n---- PROVIDE INPUTS AND READ OUTPUTS ----\n");

    // Tanh
    if (ocl_act_wr(bar_handle, test_in[0])) goto error_detach;
    usleep(50);

    // Silu
    if (ocl_act_wr(bar_handle, test_in[1])) goto error_detach;
    usleep(50);

    // Gelu (no new input)
    usleep(50);

    // Relu (no new input)
    usleep(50);

    // Read all 4 outputs from the pipeline
    for (int j = 0; j < 4; j++) {
        printf("\n--- Reading output vector %d ---\n", j);
        start_data_transfer_counter(bar_handle);
        for (int i = 0; i < LOOP_OUTPUT_PORT; i++) {
            uint16_t addr = ADDR_OUTPUT_PORT_START + i * 4;
            if (ocl_rd32(bar_handle, addr, &output_obtained_flat[j][i])) goto error_detach;
        }
        stop_data_transfer_counter(bar_handle);
        compare_act_vectors(output_obtained_flat[j], expected_out[j]);
    }

    // --- 6. Final Report ---
    uint32_t data_transfer_cycles = 0;
    uint32_t compute_cycles = 0;
    if (get_data_transfer_cycles(bar_handle, &data_transfer_cycles)) goto error_detach;
    if (get_compute_cycles(bar_handle, &compute_cycles)) goto error_detach;
    printf("\nData transfer cycles: %u\n", data_transfer_cycles);
    printf("Compute cycles: %u\n", compute_cycles);

    printf("\n---- TEST FINISHED ----\n");
    fpga_pci_detach(bar_handle);
    return 0;

error_detach:
    fprintf(stderr, "\nTEST FAILED due to MMIO communication error.\n");
    if (bar_handle != -1) {
        fpga_pci_detach(bar_handle);
    }
    return 1;
}
