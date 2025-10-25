
package wrapper_test_pkg;

import wrapper_sequence_write_pkg::*;
import wrapper_sequence_write_read_pkg::*;
import wrapper_sequence_read_pkg::*;
import wrapper_sequence_rst_pkg::*;
import wrapper_env_pkg::*;
import SPI_env_pkg::*;
import ram_env_pkg::*;
import wrapper_config_pkg::*;
import uvm_pkg::*;
import wrapper_shared_pkg::*;
`include "uvm_macros.svh"
class wrapper_test extends uvm_test;
`uvm_component_utils(wrapper_test)
wrapper_env env_w;
SPI_env env_s;
ram_env env_r;
wrapper_config cfg_w;
wrapper_config cfg_s;
wrapper_config cfg_r;
WRAPPER_reset_seq seq1;
WRAPPER_write_only_seq seq2;
WRAPPER_read_only_seq seq3;
WRAPPER_write_read_seq seq4;
function new (string name ="wrapper_test", uvm_component parent =null);
super.new(name,parent);
endfunction
  // Build the enviornment in the build phase
  function void build_phase (uvm_phase phase );
  super.build_phase (phase);
  env_w =wrapper_env :: type_id:: create ("env_w",this);
  env_s =SPI_env :: type_id:: create ("env_r",this);
  env_r =ram_env :: type_id:: create ("env_s",this);
cfg_w = wrapper_config :: type_id:: create ("wrapper_cfg");
cfg_s = wrapper_config :: type_id:: create ("spi_cfg");
cfg_r = wrapper_config :: type_id:: create ("ram_cfg");
 
  seq1= WRAPPER_reset_seq :: type_id:: create ("seq1");
  seq2= WRAPPER_write_only_seq :: type_id:: create ("seq2");
  seq3= WRAPPER_read_only_seq :: type_id:: create ("seq3");
  seq4= WRAPPER_write_read_seq :: type_id:: create ("seq4");
cfg_w.is_active  = UVM_ACTIVE;
cfg_s.is_active = UVM_PASSIVE;
cfg_r.is_active = UVM_PASSIVE;
  if (!uvm_config_db #(virtual wrapper_if)::get(this,"","wrapper_if",cfg_w.wrapper_vif )) 
  `uvm_fatal("build_phase","failed");

  uvm_config_db#(wrapper_config)::set(this,"*","CFG",cfg_w); 

   if (!uvm_config_db #(virtual SPI_if)::get(this,"","spi_if",cfg_s.spi_vif )) 
  `uvm_fatal("build_phase","failed");

  uvm_config_db#(wrapper_config)::set(this,"*","CFGs",cfg_s); 

   if (!uvm_config_db #(virtual RAM_interface)::get(this,"","ram_if",cfg_r.ram_vif )) 
  `uvm_fatal("build_phase","failed");

  uvm_config_db#(wrapper_config)::set(this,"*","CFGr",cfg_r); 
  endfunction
  

task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);
`uvm_info("run_phase","reset asserted",UVM_LOW)
seq1.start(env_w.agt.sqr); 
`uvm_info("run_phase","reset deasserted",UVM_LOW)

//mainsequence
`uvm_info("run_phase","write started",UVM_LOW)
seq2.start(env_w.agt.sqr); //write sequence
`uvm_info("run_phase","write finished",UVM_LOW)

`uvm_info("run_phase","reset asserted",UVM_LOW)
seq1.start(env_w.agt.sqr); 
`uvm_info("run_phase","reset deasserted",UVM_LOW)

`uvm_info("run_phase","read started",UVM_LOW)
seq3.start(env_w.agt.sqr); //read sequence
`uvm_info("run_phase","read finished",UVM_LOW)

`uvm_info("run_phase","reset asserted",UVM_LOW)
seq1.start(env_w.agt.sqr); 
`uvm_info("run_phase","reset deasserted",UVM_LOW)

`uvm_info("run_phase","write_read started",UVM_LOW)
seq4.start(env_w.agt.sqr); //write_read sequence
`uvm_info("run_phase","write_read finished",UVM_LOW)

  `uvm_info("REPORT_SUMMARY", 
            $sformatf("Total  recorded in shared_pkg.error_count = %0d", error_count_w),UVM_LOW)
phase.drop_objection(this);
endtask
endclass
endpackage