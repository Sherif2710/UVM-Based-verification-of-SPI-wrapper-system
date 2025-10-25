package SPI_env_pkg;
import uvm_pkg::*;
import SPI_scoreboard_pkg::* ;
import SPI_agent_pkg::* ;
import SPI_cvr_collector_pkg::* ;
`include "uvm_macros.svh"

class SPI_env extends uvm_env;
  `uvm_component_utils(SPI_env)
SPI_agent agt;
SPI_scoreboard sb;
SPI_cvr_collector cvr;
//SPI_sequencer sqr;

 function new(string name = "SPI_env", uvm_component parent = null);
  super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  agt = SPI_agent::type_id::create("agt", this);
  cvr = SPI_cvr_collector::type_id::create("cvr", this);
  sb = SPI_scoreboard::type_id::create("sb", this);
  endfunction: build_phase
 
 function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  agt.agt_ap.connect(sb.sb_export);
  agt.agt_ap.connect(cvr.cvr_export);
 endfunction
endclass
endpackage