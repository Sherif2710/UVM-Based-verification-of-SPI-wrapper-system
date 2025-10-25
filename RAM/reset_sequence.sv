package ram_sequence_rst_pkg;
import ram_sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class  ram_sequence_reset extends uvm_sequence#(ram_sequence_item);
`uvm_object_utils(ram_sequence_reset)
ram_sequence_item seq_item;
function new (string name ="ram_sequence_reset");
super.new(name);
endfunction
task body;
seq_item=ram_sequence_item::type_id::create("seq_item");
    start_item(seq_item);
seq_item.rst_n =0;
seq_item.din     =0;
seq_item.rx_valid=0;
    finish_item(seq_item);
endtask
endclass
endpackage
