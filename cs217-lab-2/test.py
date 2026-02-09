import re
import argparse
import subprocess
import os
import shutil

# Paths
UNIT_NAME = "ActUnit"
SRC_PATH = os.getenv("SRC_HOME")
SRC_UNIT_PATH = os.path.join(SRC_PATH, UNIT_NAME)
INCLUDE_PATH = os.path.join(SRC_PATH, "include")
HLS_PATH = f"hls/{UNIT_NAME}/"

AWS_PATH = os.getenv("AWS_HOME")

RTL_SIM_LOG = "logs/rtl_sim.log.txt"
SYSTEMC_SIM_LOG = "logs/systemc_sim.log.txt"
AREA_LOG = "logs/area.log.txt"

# Create logs directory if it doesn't exist
if not os.path.exists("logs"):
    os.makedirs("logs")

PPU_UNITS = ["PPU", "PPUPwl", "PPUTaylor"]
testnames = ["Tanh", "SiLu", "GeLu", "ReLu"]

def get_area():
    area_table = [] 
    for ppu in PPU_UNITS:
        path = os.path.join(AWS_PATH, f"design/concat_{UNIT_NAME}/{ppu}/{UNIT_NAME}.rpt")
        if not os.path.exists(path):
            print(f"Warning: Report file not found for {ppu}. Please generate RTL first.")
            return
        area_score = None
        try:
            with open(path, 'r') as f:
                content = f.read()
                match = re.search(r"Total Area Score:\s+[\d.]+\s+[\d.]+\s+([\d.]+)", content)
                if match:
                    area_score = float(match.group(1))
        except (IOError, ValueError) as e:
            print(f"Warning: Could not parse area score for {ppu}. Reason: {e}")
        area_table.append((ppu, area_score))
    
    # --- Create and print Area Score table ---
    area_summary = "\n\n" + "="*40 + "\n"
    area_summary += " " * 10 + "HLS AREA SCORES" + " " * 11 + "\n"
    area_summary += "="*40 + "\n"
    area_summary += f"{'PPU Unit':<15} | {'Post-Assignment Area':<20}\n"
    area_summary += "-"*40 + "\n"

    for ppu_unit, score in area_table:
        score_str = f"{score:.1f}" if score is not None else "N/A"
        area_summary += f"{ppu_unit:<15} | {score_str:<20}\n"
    
    area_summary += "="*40 + "\n"
    print(area_summary)
    with open(AREA_LOG, "w") as f:
        f.write(area_summary)

def copy_concat_rtl(ppu_unit):
    """
    Copies generated RTL, report, and log files to a destination directory.
    Parses the HLS report file to extract the post-assignment area score.

    Args:
        ppu_unit (str): The name of the PPU unit being processed (e.g., "PPU", "PPUPwl").

    Returns:
        float: The extracted "Total Area Score" for "Post-Assignment".
               Returns None if the file cannot be read or the score cannot be found.
    """
    src_rtl_path = os.path.join(HLS_PATH, f"Catapult/{UNIT_NAME}.v1/concat_{UNIT_NAME}.v")
    src_rpt_path = os.path.join(HLS_PATH, f"Catapult/{UNIT_NAME}.v1/{UNIT_NAME}.rpt")
    src_log_path = os.path.join(HLS_PATH, f"catapult.log")

    full_dest_path = os.path.join(AWS_PATH, f"design/concat_{UNIT_NAME}/{ppu_unit}")

    if not os.path.exists(full_dest_path):
        os.makedirs(full_dest_path)
    
    shutil.copy(src_rtl_path, full_dest_path)
    shutil.copy(src_rpt_path, full_dest_path)
    shutil.copy(src_log_path, full_dest_path)

    return

def run_simulations(rtl_sim=False):

    error = 0
    info = []

    if rtl_sim:
        log = f"Starting {UNIT_NAME} RTL Simulation Test Suite\n"
    else:
        log = f"Starting {UNIT_NAME} SystemC Simulation Test Suite\n"

    for ppu_val in PPU_UNITS:

        cmd = f"cp {SRC_UNIT_PATH}/{ppu_val}/PPU.h {INCLUDE_PATH}/PPU.h"
        subprocess.run(cmd, shell=True, check=True)

        if rtl_sim:
            cmd = f"make hls"
            path = HLS_PATH
            LOG = RTL_SIM_LOG
        else:
            cmd = f"make clean; make sim_test"
            path = SRC_UNIT_PATH
            LOG = SYSTEMC_SIM_LOG

        txt_log = f"\nRunning test with PPU_UNIT = {ppu_val}"
        log = log + "\n" + txt_log
        print(txt_log)
        
        result = subprocess.run(
                        cmd,
                        shell=True,
                        capture_output=True,
                        text=True,
                        check=False,
                        cwd=path 
                    )

        # Print and log the initial build result
        print(result.stdout)
        log += f"\n--- Build stdout for PPU_UNIT={ppu_val} ---\n" + result.stdout
        
        # Check for compilation errors first
        if result.returncode != 0:
            print("ERROR: Compilation failed.")
            info.append([ppu_val, "Compilation", "FAILED", "N/A"])
            error += 1
            log += result.stderr
            continue # Move to the next PPU value

        # Run the simulation test
        if rtl_sim:
            cmd = "make vcs_sim"
        else:
            cmd = "make run"

        run_result = subprocess.run(
            cmd, shell=True, capture_output=True, text=True, check=False, cwd=path
        )
        
        print(run_result.stdout)
        log += f"\n--- Simulation stdout for PPU_UNIT={ppu_val} ---\n" + run_result.stdout

        # Regex to find all test blocks, their average difference, and MSE
        test_results = re.findall(r"Average % Difference: ([\d.e-]+)%(?:.|\n)*?MSE %: ([\d.e-]+)", run_result.stdout)

        if not test_results:
            # Handle cases where parsing fails or the output format is unexpected
            overall_status = "UNKNOWN"
            if "TESTBENCH PASS" in run_result.stdout:
                overall_status = "PASSED"
            elif "TESTBENCH FAIL" in run_result.stdout:
                overall_status = "FAILED"
                error += 1
            info.append([ppu_val, "N/A", overall_status, "N/A", "N/A"])
            print(f"INFO: Could not parse test details. Overall status for PPU_UNIT={ppu_val}: {overall_status}")
        else:
            # Check for an overall failure message for the entire PPU_UNIT run
            is_ppu_unit_fail = "TESTBENCH FAIL" in run_result.stdout

            cnt = 0

            for avg_diff, mse in test_results:
                status = "PASSED"
                is_fail = False

                if is_ppu_unit_fail:
                    is_fail = True
                
                # Check if the average difference is greater than 5%
                if float(avg_diff) > 5.0:
                    is_fail = True

                if is_fail:
                    status = "FAILED"
                    error += 1
                
                test_name = testnames[cnt]
                cnt += 1

                info.append([ppu_val, test_name, status, avg_diff, mse])
                #print(f"Test: {test_name}, Avg Diff: {avg_diff}%, MSE: {mse}, Status: {status}")
        if rtl_sim:
            copy_concat_rtl(ppu_val)

    # --- Create and print summary table ---
    # Restructure data for pivoted table
    pivoted_results = {}
    test_names = sorted(list(set(item[1] for item in info))) # Get unique, sorted test names

    for ppu_val, test_name, status, avg_diff, mse in info:
        if ppu_val not in pivoted_results:
            pivoted_results[ppu_val] = {}
        
        # Store status, avg_diff, and mse as a tuple for each test
        try:
            pivoted_results[ppu_val][test_name] = (status, float(avg_diff), float(mse))
        except (ValueError, TypeError):
            pivoted_results[ppu_val][test_name] = (status, avg_diff, mse)


    summary_header = "\n\n" + "="*70 + "\n"
    summary_header += " " * 25 + "TEST SUITE SUMMARY" + " " * 25 + "\n"
    summary_header += "="*70 + "\n"

    # Create dynamic multi-line header
    header_line1 = f"{'Test Name':<10}"
    header_line2 = f"{'':<10}"
    for ppu_unit in PPU_UNITS:
        header_line1 += f" | {ppu_unit:^36}"
        header_line2 += f" | {'Status':<8} | {'Avg Diff (%)':<12} | {'MSE (%)':<12}"
    
    summary_header += header_line1 + "\n"
    summary_header += header_line2 + "\n"
    summary_header += "-" * len(header_line2) + "\n"

    log += summary_header
    print(summary_header.strip())

    summary_body = ""
    for name in test_names:
        if name == "N/A": continue # Skip rows for parsing errors
        row = f"{name:<10}"
        for ppu_unit in PPU_UNITS:
            status, avg_diff, mse = pivoted_results.get(ppu_unit, {}).get(name, ("N/A", "N/A", "N/A"))
            
            if isinstance(avg_diff, float):
                diff_str = f"{avg_diff:.6f}"
            else:
                diff_str = str(avg_diff)
    
            if isinstance(mse, float):
                mse_str = f"{mse:.6f}"
            else:
                mse_str = str(mse)
    
            row += f" | {status:<8} | {diff_str:<12} | {mse_str:<12}"
        summary_body += row + "\n"

    log += summary_body
    print(summary_body.strip())

    if error > 0:
        final_summary = f"\nTEST SUITE FAILED: {error} error(s) found.\n"
    else:
        final_summary = "\nTEST SUITE PASSED\n"
    
    log += final_summary
    print(final_summary.strip())


    with open(LOG, "w") as f:
        f.write(log)
    
    cmd = f"cp {SRC_UNIT_PATH}/PPU/PPU.h {INCLUDE_PATH}/PPU.h"
    subprocess.run(cmd, shell=True, check=True)

def cleanup():
    """
    Cleans up generated files from simulations and synthesis.
    """
    print("\n--- Cleaning up generated files ---")
    
    # The top-level Makefile's 'clean' target handles cleaning subdirectories.
    # We run it from the script's directory to ensure correct relative paths.
    repo_top = os.path.dirname(os.path.abspath(__file__))
    print(f"Running 'make clean' in {repo_top}")
    subprocess.run(["make", "clean"], check=False, cwd=repo_top)

def main():
    """
    Main function to parse arguments and run the specified action.
    """
    parser = argparse.ArgumentParser(description="Run SystemC simulation for the ActUnit.")
    parser.add_argument(
        '--action',
        type=str,
        choices=['systemc_sim', 'clean', 'rtl_sim', 'get_rtl_area'],
        default='systemc_sim',
        help='Specify the action to perform: "systemc_sim", "rtl_sim", or "clean". Default is "systemc_sim".',
    )
    args = parser.parse_args()

    LOG_FOLDER = "logs"
    if not os.path.exists(LOG_FOLDER):
        os.makedirs(LOG_FOLDER)


    if args.action == 'clean':
        cleanup()
    elif args.action == 'systemc_sim':
        run_simulations()
    elif args.action == 'get_rtl_area':
        get_area()
    elif args.action == 'rtl_sim':
        run_simulations(rtl_sim=True)
        get_area()
    
    cmd = f"cp {SRC_UNIT_PATH}/PPU/PPU.h {INCLUDE_PATH}/PPU.h"
    subprocess.run(cmd, shell=True, check=True)

if __name__ == "__main__":
    main()
    