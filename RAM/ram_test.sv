package ram_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import ram_sequence_rst_pkg::*;
import ram_sequence_write_pkg::*;
import ram_sequence_read_pkg::*;
import ram_sequence_write_read_pkg::*;
import ram_env_pkg::*;
import  ram_config_pkg ::*;



class ram_test extends uvm_test;
`uvm_component_utils(ram_test)

ram_env env;
ram_config ram_cfg;
 ram_sequence_reset seq1;
ram_sequence_write seq2;
 ram_sequence_read seq3;
ram_sequence_write_read seq4;
function new (string name ="ram_test", uvm_component parent =null);
super.new(name,parent);
endfunction
  function void build_phase (uvm_phase phase );
  super.build_phase (phase);
  env =ram_env :: type_id:: create ("env",this);
 ram_cfg = ram_config :: type_id:: create ("ram_config");
  seq1= ram_sequence_reset :: type_id:: create ("seq1");
  seq2= ram_sequence_write :: type_id:: create ("seq2");
  seq3= ram_sequence_read :: type_id:: create ("seq3");
  seq4= ram_sequence_write_read :: type_id:: create ("seq4");

  if (!uvm_config_db #(virtual RAM_interface)::get(this,"","key_ram",ram_cfg.ram_vif )) 
  `uvm_fatal("build_phase","failed");

  uvm_config_db#(ram_config)::set(this,"*","CFG",ram_cfg); 
  endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);
`uvm_info("run_phase","reset asserted",UVM_LOW)
seq1.start(env.agt.sqr); //reset sequence
`uvm_info("run_phase","reset deasserted",UVM_LOW)
//write
`uvm_info("run_phase","write asserted",UVM_LOW)
seq2.start(env.agt.sqr); //write sequence
`uvm_info("run_phase"," write deasserted",UVM_LOW)
//read
`uvm_info("run_phase","read asserted",UVM_LOW)
seq3.start(env.agt.sqr); //read sequence
`uvm_info("run_phase","read deasserted",UVM_LOW)
//write_read
`uvm_info("run_phase","write_read_started",UVM_LOW)
seq4.start(env.agt.sqr); //write_read_ sequence
`uvm_info("run_phase","write_read_finished",UVM_LOW)
phase.drop_objection(this);
endtask
endclass: ram_test
endpackage