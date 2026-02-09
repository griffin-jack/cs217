// ../src/cl_peek_simple.c
#include <fpga_mgmt.h>
#include <fpga_pci.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

int main(int argc, char **argv) {
  if (argc != 2) {
    printf("Usage: %s <slot_id>\n", argv[0]);
    return 1;
  }

  clock_t start_time = clock();

  int slot_id = atoi(argv[1]);
  uint32_t add_value = 0;
  uint16_t address = 0x400; // Address for counter value
  uint16_t add_address = 0x410; // Address for added counter value
  uint32_t counter_value = 0;
  uint32_t tmp = 0;

  if (fpga_mgmt_init() != 0) {
    fprintf(stderr, "Failed to initialize fpga_mgmt\n");
    return 1;
  }

  int bar_handle = -1;
  if (fpga_pci_attach(slot_id, FPGA_APP_PF, APP_PF_BAR0, 0, &bar_handle)) {
    fprintf(stderr, "fpga_pci_attach failed\n");
    return 1;
  }

  for (int i = 0; i < 10; i++) {
    if (fpga_pci_peek(bar_handle, address, &counter_value)) {
      fprintf(stderr, "MMIO read failed\n");
      fpga_pci_detach(bar_handle);
      return 1;
    }

    if (fpga_pci_peek(bar_handle, add_address, &add_value)) {
      fprintf(stderr, "MMIO read failed\n");
      fpga_pci_detach(bar_handle);
      return 1;
    }

    double timestamp = 1000000*( (double)(clock() - start_time)) / CLOCKS_PER_SEC;
    printf("timestamp: %.3fus | Counter Value: 0x%x and added counter Value = 0x%x\n",
       timestamp, counter_value, add_value);    
    if (tmp == counter_value) {
      fprintf(stderr,
              "Warning: Counter Value has not changed since last read.\n");
      fpga_pci_detach(bar_handle);
      return 1;
    }
    if (add_value - counter_value <= 5) {
      fprintf(stderr,
              "Warning: Added Counter Value is incorrect\n");
      fpga_pci_detach(bar_handle);
      return 1;
    }
    tmp = counter_value;
  }
  fprintf(stderr, "Read 10 tested successfully.\nTEST PASSED\n");
  fpga_pci_detach(bar_handle);

  return 0;
}
