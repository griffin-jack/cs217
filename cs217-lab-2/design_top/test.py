
import subprocess
import os
import datetime
import shutil
import re

SPEC_PATH = "design/design_top_defines.vh"
FILELIST_PATH = "verif/scripts/top.xsim.f"
PPU_UNITS = ["PPU", "PPUPwl", "PPUTaylor"]
testnames = ["Tanh", "SiLu", "GeLu", "ReLu"]

default_ppu = "PPUPwl"

log_path = "logs"
if not os.path.exists(log_path):
    os.makedirs(log_path)

def update_spec(ppu):

    src_path = f"design/concat_ActUnit/{ppu}/concat_ActUnit.v"
    dest_path = f"design/concat_ActUnit.v"
    shutil.copy(src_path, dest_path)

log = "Start of the hardware simulation log"
cmd = " cd $CL_DIR/verif/scripts; make ${CL_DESIGN_NAME}_base_test; cd $CL_DIR"
summary_table = []

for i in PPU_UNITS:
            update_spec(i)
            log_info = f"Running test for PPU Unit: {i}"
            log = log + "\n" + log_info
            print(log_info)
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True, check=False)
            
            passed = False
            data_cycles = "N/A"
            compute_cycles = "N/A"
            diff_percentages = []
            mse_values = []
            
            # Filter and print only the relevant lines from the output
            for line in result.stdout.splitlines():
                if (line.startswith("Dest: Average difference observed") or
                    line.startswith("Dest: MSE observed") or
                    line.startswith("Data transfer cycles:") or
                    line.startswith("Compute cycles:") or
                    "TEST FINISHED" in line):
                    print(line)
                
                if "TEST FINISHED" in line:
                    passed = True
                if line.startswith("Data transfer cycles:"):
                    data_cycles = line.split(":")[1].strip()
                if line.startswith("Compute cycles:"):
                    compute_cycles = line.split(":")[1].strip()
                if line.startswith("Dest: Average difference observed"):
                    diff_percentages.append(line.split()[-1])
                if line.startswith("Dest: MSE observed"):
                    mse_values.append(line.split()[-1])
            
            log = log + result.stdout
            
            for idx, test in enumerate(testnames):
                diff = diff_percentages[idx] if idx < len(diff_percentages) else "N/A"
                mse = mse_values[idx] if idx < len(mse_values) else "N/A"
                
                test_status = "FAILED"
                if passed and diff != "N/A" and mse != "N/A":
                    try:
                        if float(diff.strip('%')) <5.0 and float(mse.strip('%')) < 1:
                            test_status = "PASSED"
                    except ValueError:
                        pass
                summary_table.append((i, test, test_status, data_cycles, compute_cycles, diff, mse))

# Restructure data for pivoted table
pivoted_results = {}
for ppu_val, test_name, status, data_cycles, compute_cycles, diff, mse in summary_table:
    if ppu_val not in pivoted_results:
        pivoted_results[ppu_val] = {}
    pivoted_results[ppu_val][test_name] = (status, data_cycles, compute_cycles, diff, mse)

summary_str = "\n\n" + "="*170 + "\n"
summary_str += " " * 70 + "TEST SUITE SUMMARY" + " " * 70 + "\n"
summary_str += "="*170 + "\n"

header_line1 = f"{'Test Name':<10}"
header_line2 = f"{'':<10}"
for ppu_unit in PPU_UNITS:
    header_line1 += f" | {ppu_unit:^52}"
    header_line2 += f" | {'Status':<8} | {'Data':<6} | {'Comp':<6} | {'Diff %':<10} | {'MSE %':<10}"
summary_str += header_line1 + "\n" + header_line2 + "\n" + "-" * len(header_line2) + "\n"

for name in testnames:
    row = f"{name:<10}"
    for ppu_unit in PPU_UNITS:
        status, d_cyc, c_cyc, diff, mse = pivoted_results.get(ppu_unit, {}).get(name, ("N/A", "N/A", "N/A", "N/A", "N/A"))
        row += f" | {status:<8} | {d_cyc:<6} | {c_cyc:<6} | {diff:<10} | {mse:<10}"
    summary_str += row + "\n"

print(summary_str)
log += summary_str

log_filename = "logs/f2_hw_sim.log.txt"
print(log)
with open(log_filename, "w") as log_file:
    log_file.write(log)

update_spec(default_ppu)
