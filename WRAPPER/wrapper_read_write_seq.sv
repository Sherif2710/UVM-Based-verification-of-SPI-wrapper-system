package wrapper_sequence_write_read_pkg;
import uvm_pkg::*;
import wrapper_shared_pkg::*;
`include "uvm_macros.svh"
import wrapper_seq_item_pkg::*;
class WRAPPER_write_read_seq extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(WRAPPER_write_read_seq)

        wrapper_seq_item seq_item;

        function new (string name = "WRAPPER_write_read_seq");
            super.new(name);
        endfunction

      task body();
                seq_item = wrapper_seq_item::type_id::create("seq_item");
                seq_item.write_only_const.constraint_mode(0);
                seq_item.read_only_const.constraint_mode(0);
    
            for(int i = 0; i<10000; i++) begin
                start_item(seq_item);
                if(i == 1) 
                start_read = 1;
                else 
                start_read = 0;
                assert(seq_item.randomize);
                finish_item(seq_item);
            end
        endtask
    endclass
endpackage
