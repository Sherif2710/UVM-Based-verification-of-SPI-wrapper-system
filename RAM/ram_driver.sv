package ram_driver_pkg;
//import alsu_reg_config::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
import ram_sequence_item_pkg::*;

class ram_driver extends uvm_driver#(ram_sequence_item);
`uvm_component_utils(ram_driver)
virtual RAM_interface ram_vif;
ram_sequence_item seq_item;
//shift_reg_config shift_cfg;
function new (string name ="ram_driver", uvm_component parent =null);
super.new(name,parent);
endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
  seq_item=ram_sequence_item::type_id::create("seq_item");
  seq_item_port.get_next_item(seq_item);
ram_vif.rst_n    = seq_item.rst_n      ;
ram_vif.din= seq_item.din;
ram_vif.rx_valid= seq_item.rx_valid;
@( negedge ram_vif.clk );
seq_item_port.item_done();
`uvm_info("runphase",seq_item.convert2string_stimulus(),UVM_HIGH)
end

endtask

endclass
endpackage