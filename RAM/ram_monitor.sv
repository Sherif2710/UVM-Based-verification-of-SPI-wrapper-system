package ram_monitor_pkg;
import ram_sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class ram_monitor extends uvm_monitor;
`uvm_component_utils(ram_monitor )
virtual RAM_interface ram_vif;
ram_sequence_item seq_item;
uvm_analysis_port #(ram_sequence_item )mon_ap;

function new (string name ="ram_monitor", uvm_component parent =null);
super.new(name,parent);
endfunction
function void build_phase (uvm_phase phase );
  super.build_phase (phase);
  mon_ap = new ("mon_ap",this);
  endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin 
      seq_item=ram_sequence_item::type_id::create("seq_item");
@(negedge ram_vif.clk );

seq_item.rst_n    = ram_vif.rst_n      ;
seq_item.din= ram_vif.din;
seq_item.rx_valid= ram_vif.rx_valid;
seq_item.dout= ram_vif.dout;
seq_item.tx_valid= ram_vif.tx_valid;
seq_item.dout_gn= ram_vif.dout_gn;
seq_item.tx_valid_gn= ram_vif.tx_valid_gn;
  mon_ap.write(seq_item);
`uvm_info("runphase",seq_item.convert2string_stimulus(),UVM_HIGH)
end
endtask

endclass
endpackage