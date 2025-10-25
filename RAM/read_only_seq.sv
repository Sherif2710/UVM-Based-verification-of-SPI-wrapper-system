package ram_sequence_read_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import ram_sequence_item_pkg::*;

class  ram_sequence_read extends  uvm_sequence#(ram_sequence_item);
`uvm_object_utils(ram_sequence_read)
ram_sequence_item seq_item;
function new (string name ="ram_sequence_read");
super.new(name);
endfunction
task body;
   seq_item=ram_sequence_item::type_id::create("seq_item");
 seq_item.constraint_mode(0);  //turning all constrain off
  seq_item.RESET.constraint_mode(1);
  seq_item.RX.constraint_mode(1);
  seq_item.read_only.constraint_mode(1);
repeat(10000) begin
    start_item(seq_item);
    assert(seq_item.randomize());
    finish_item(seq_item);
end
endtask
endclass
endpackage