package ram_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import wrapper_config_pkg::* ;
import ram_sequence_item_pkg::*;
import  ram_monitor_pkg::*;
import ram_driver_pkg::*;
import ram_sequencer_pkg::*;

class ram_agent extends uvm_agent;
`uvm_component_utils(ram_agent)
ram_sequencer sqr; //driver b al sequence
ram_monitor mon;
ram_driver drv;
wrapper_config cfg;
uvm_analysis_port #(ram_sequence_item)agt_ap;
function new (string name ="ram_agent", uvm_component parent =null);
super.new(name,parent);
endfunction
function void build_phase (uvm_phase phase );
  super.build_phase (phase);
   if (!uvm_config_db #(wrapper_config)::get(this,"","CFGr",cfg ))
  `uvm_fatal("build_phase","failed");
  if (cfg.is_active==UVM_ACTIVE)begin
sqr=ram_sequencer::type_id::create("sqr",this);
drv=ram_driver::type_id::create("drv",this);
end 

mon=ram_monitor::type_id::create("mon",this);
agt_ap=new("agt_ap",this);
endfunction
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
 if (cfg.is_active==UVM_ACTIVE)begin
drv.ram_vif = cfg.ram_vif;
drv.seq_item_port.connect(sqr.seq_item_export);
end 
mon.ram_vif=cfg.ram_vif; 
mon.mon_ap.connect(agt_ap);                       //monitor/analysis port agent
endfunction

endclass
endpackage