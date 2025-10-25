package SPI_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_env_pkg::* ;
import SPI_config_pkg::* ;
import SPI_reset_sequence_pkg::* ;
import SPI_main_sequence_pkg::* ;
import SPI_sequencer_pkg::* ;
class SPI_test extends uvm_test;
  `uvm_component_utils(SPI_test)

  // Build the enviornment in the build phase
  virtual SPI_if SPI_config_vif;
  SPI_env env;
  SPI_config SPI_cfg;
  SPI_reset_sequence reset_seq;
  SPI_main_sequence main_seq;

  function new(string name = "SPI_test", uvm_component parent = null);
   super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   env = SPI_env::type_id::create("env", this);
   SPI_cfg = SPI_config::type_id::create("SPI_cgf");
   main_seq = SPI_main_sequence::type_id::create("main_seq", this);
   reset_seq = SPI_reset_sequence::type_id::create("reset_seq", this);

    if(!uvm_config_db#(virtual SPI_if)::get(this, "","SPI_if", SPI_cfg.SPI_config_vif))
     `uvm_fatal("build_phase", "Test - unable to get virsual interface");
   uvm_config_db #(SPI_config)::set(this, "*", "CFG", SPI_cfg);


  endfunction

  task run_phase(uvm_phase phase);
   super.run_phase(phase);
   phase.raise_objection(this);
   `uvm_info("run_phase","reset deasserted",UVM_LOW)
   reset_seq.start(env.agt.sqr);
   `uvm_info("run_phase","reset asserted",UVM_LOW)
   //main_seq
   `uvm_info("run_phase","main asserted",UVM_LOW)
   main_seq.start(env.agt.sqr);
      `uvm_info("run_phase","main asserted",UVM_LOW)
   phase.drop_objection(this);
  endtask: run_phase
endclass: SPI_test
endpackage