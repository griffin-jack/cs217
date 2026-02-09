#include <systemc.h>
#include <mc_scverify.h>
#include <testbench/nvhls_rand.h>
#include <nvhls_connections.h>
#include <nvhls_int.h>

#include <vector>

#include "counter_top.h"
#include <vector>

#define NVHLS_VERIFY_BLOCKS (counter_top)
#include <nvhls_verify.h>
using namespace::std;

SC_MODULE(Source)
{
  sc_in<bool> clk;
  sc_in<bool> rst;
  sc_in<sc_lv<32>> counter_out;
  sc_in<sc_lv<32>> add_out;

  SC_CTOR(Source)
  {
    SC_THREAD(run);
    sensitive << clk.pos();
    async_reset_signal_is(rst, false);
  }

  void run()
  {
    wait(2.0, SC_NS);
    wait();

    
    int error_count = 0;

    sc_lv<32> prev_counter_val = counter_out.read();
    sc_lv<32> prev_add_val = add_out.read();

    NVUINT32 counter_out_tmp = 0;
    NVUINT32 add_out_tmp = 0;

    wait(5);

    for (int i = 0; i < 10; ++i)
    {
      cout << "Test Iteration " << i << endl;
      sc_lv<32> counter_val = counter_out.read();
      sc_lv<32> add_val = add_out.read();

      #pragma hls_unroll yes
      for (int j = 0; j < 32; j++)
      {
        counter_out_tmp[j] = counter_val[j].to_bool();
        add_out_tmp[j] = add_val[j].to_bool();
      }

      cout << "@" << sc_time_stamp() << ": CounterOut = " << counter_out_tmp << ", AddOut = CounterOut + 5 = " << add_out_tmp << endl;

      if (add_out_tmp != (counter_out_tmp + 5))
      {
        cout << "\tERROR: Add value " << add_out_tmp << " does not match expected value " << (counter_out_tmp + 5) << endl;
        error_count++;
      }
      

      if (counter_val == prev_counter_val)
      {
        cout << "\tERROR: Value did not change. Still " << counter_val << endl;
        error_count++;
      }

      prev_counter_val = counter_val;
      wait(4);
    }
    if (error_count == 0)
      cout << "\nTest PASSED\n";
    else
      cout << "\nTest FAILED with " << error_count << " errors\n";

    sc_stop();
  }
};

SC_MODULE(testbench)
{
  sc_clock clk{"clk", 1, SC_NS};
  sc_signal<bool> rst;

  sc_signal<sc_lv<32>> counter_out;
  sc_signal<sc_lv<32>> add_out;

  NVHLS_DESIGN(counter_top) dut;
  Source src;

  SC_HAS_PROCESS(testbench);
  testbench(sc_module_name name)
  : sc_module(name),
    clk("clk"),
    rst("rst"),
    dut("dut"), 
    src("src")
  {
    dut.clk(clk);
    dut.rst(rst);
    dut.counter_out(counter_out);
    dut.add_out(add_out);

    src.clk(clk);
    src.rst(rst);
    src.counter_out(counter_out);
    src.add_out(add_out);


    SC_THREAD(run);
  }

  void run() {
    //rst = 1;
    wait(2, SC_NS);
    //rst = 0;
    cout << "@" << sc_time_stamp() << " Asserting Reset " << endl ;
    rst = 0;
    wait(2, SC_NS);
    rst = 1;
    cout << "@" << sc_time_stamp() << " Deasserting Reset " << endl ;
    //rst = 1;
    wait(10000,SC_NS);
    cout << "@" << sc_time_stamp() << " Stop " << endl ;
    sc_stop();
  }
};

int sc_main(int argc, char *argv[])
{
  testbench tb("tb");
  sc_start();
  cout << "CMODEL EXIT" << endl;
  return 0;
}
