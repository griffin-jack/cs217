#ifndef DESIGN_TOP_H
#define DESIGN_TOP_H

#include <stdint.h>
#include <stdbool.h>
#include <math.h>

// From design_top_defines.vh
#define kIntWordWidth 16
#define kNumVectorLanes 16
#define kActWordWidth 32
#define kAccumWordWidth (2 * kIntWordWidth + kNumVectorLanes - 1) // 47
#define kActNumFrac 24

#define WIDTH_AXI 32
#define ADDR_WIDTH_OCL 16

// Tranfer Counter
#define ADDR_TX_COUNTER_EN 0x0400         // Write
#define ADDR_TX_COUNTER_READ 0x0400       // Read
#define ADDR_COMPUTE_COUNTER_READ 0x0404  // Read

// Start enable
#define ADDR_START_CFG 0x0404             //Write

// RVA IN Port (Input)
#define DATA_WIDTH_RVA_IN (kActWordWidth * kNumVectorLanes)                               // 512
#define ADDR_WIDTH_RVA_IN 24
#define WIDTH_RVA_IN (DATA_WIDTH_RVA_IN + ADDR_WIDTH_RVA_IN + 1 + (DATA_WIDTH_RVA_IN >> 3)) // 601
#define LOOP_RVA_IN ((WIDTH_RVA_IN + 31) / 32)                                     // 19
#define ADDR_RVA_IN_START 0x0408

// Act Port (Input)
#define WIDTH_ACT_PORT DATA_WIDTH_RVA_IN                            // 512
#define LOOP_ACT_PORT (WIDTH_ACT_PORT / WIDTH_AXI)                    // 16
#define ADDR_ACT_PORT_START 0x0454 // ADDR_RVA_IN_START + LOOP_RVA_IN * 4

// Output Port (Output)
#define WIDTH_OUTPUT_PORT (DATA_WIDTH_RVA_IN + 2 + 8)                 // 522
#define LOOP_OUTPUT_PORT ((WIDTH_OUTPUT_PORT + 31) / 32)         // 17
#define ADDR_OUTPUT_PORT_START (ADDR_COMPUTE_COUNTER_READ + 4)       // 0x408

// RVA Out Port (Output)
#define WIDTH_RVA DATA_WIDTH_RVA_IN                                         // 512
#define LOOP_RVA_OUT ((WIDTH_RVA + 31) / 32)                     // 16
#define ADDR_RVA_OUT_START (ADDR_OUTPUT_PORT_START + LOOP_OUTPUT_PORT * 4)    // 0x44C

// Helper macros for fixed-point conversion
#define FIXED_SCALE (1.0 * (1LL << kActNumFrac))
#define FLOAT_TO_FIXED(f) ((int32_t)round((f) * FIXED_SCALE))
#define FIXED_TO_FLOAT(i) (((double)(i)) / FIXED_SCALE)


// Function Prototypes
int ocl_wr32(int bar_handle, uint16_t addr, uint32_t data);
int ocl_rd32(int bar_handle, uint16_t addr, uint32_t *data);

void rva_format(bool rw, uint32_t addr, const uint32_t data[LOOP_RVA_OUT], uint32_t rva_msg[LOOP_RVA_IN]);
int ocl_rva_wr32(int bar_handle, const uint32_t rva_msg[LOOP_RVA_IN]);
int ocl_act_wr(int bar_handle, const uint32_t data[LOOP_ACT_PORT]);
int ocl_rva_r32(int bar_handle, const uint32_t data_cmp[LOOP_RVA_OUT], const uint32_t rva_in[LOOP_RVA_IN], int* error_cnt);

void tanh_ref(const int32_t vec_in[kNumVectorLanes], int32_t vec_out[kNumVectorLanes]);
void silu_ref(const int32_t vec_in[kNumVectorLanes], int32_t vec_out[kNumVectorLanes]);
void gelu_ref(const int32_t vec_in[kNumVectorLanes], int32_t vec_out[kNumVectorLanes]);
void relu_ref(const int32_t vec_in[kNumVectorLanes], int32_t vec_out[kNumVectorLanes]);
void randomize_vector(uint32_t vec_out[ kNumVectorLanes ]);
double sigmoid_ref(double val);

void compare_act_vectors(const uint32_t dut_vec_flat[LOOP_OUTPUT_PORT], const int32_t golden_vec[kNumVectorLanes]);

int get_data_transfer_cycles(int bar_handle, uint32_t *cycles);
int get_compute_cycles(int bar_handle, uint32_t *cycles);
int start_data_transfer_counter(int bar_handle);
int stop_data_transfer_counter(int bar_handle);

#endif // DESIGN_TOP_H