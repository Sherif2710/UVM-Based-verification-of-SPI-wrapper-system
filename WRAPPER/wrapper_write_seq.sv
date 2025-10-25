package  wrapper_sequence_write_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import wrapper_shared_pkg::*;
    import wrapper_seq_item_pkg::*;

   
    class WRAPPER_write_only_seq extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(WRAPPER_write_only_seq)

        wrapper_seq_item seq_item;

        function new (string name = "WRAPPER_write_only_seq");
            super.new(name);
        endfunction

  task body();
                seq_item = wrapper_seq_item::type_id::create("seq_item");
                seq_item.read_only_const.constraint_mode(0);
                seq_item.write_read_const.constraint_mode(0);
            repeat (10000) begin
                start_item(seq_item);
                assert(seq_item.randomize);
                finish_item(seq_item);
            end
        endtask
    endclass
    
    
endpackage
