
import ram_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module ram_top();
bit clk;
 
  initial begin
    forever begin
      #1 clk =~clk;
    end
  end

  // Instantiate the interface and DUT and golden
RAM_interface ram_if(clk);
RAM DUT (  ram_if.din,ram_if.clk,ram_if.rst_n,ram_if.rx_valid,ram_if.dout,ram_if.tx_valid);
RAM_golden DUT_golden ( ram_if.din,ram_if.clk,ram_if.rst_n,ram_if.rx_valid,ram_if.dout_gn,ram_if.tx_valid_gn);
//bind_assertions
  bind RAM ram_sva my_ass(ram_if.sva);
initial
begin
  // run test
uvm_config_db #(virtual RAM_interface) :: set (null , "uvm_test_top" ,"key_ram" ,ram_if ); 
  
  run_test("ram_test");

end 
endmodule