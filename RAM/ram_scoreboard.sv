package ram_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import ram_sequence_item_pkg::*;
class ram_scoreboard extends uvm_scoreboard;
`uvm_component_utils(ram_scoreboard)
uvm_analysis_export #(ram_sequence_item) sb_export;
uvm_tlm_analysis_fifo  #(ram_sequence_item) sb_fifo;
ram_sequence_item seq_item;
int correct_count=0;
int error_count=0;
function new (string name ="ram_scoreboard", uvm_component parent =null);
super.new(name,parent);
endfunction
function void build_phase (uvm_phase phase );
  super.build_phase (phase);
sb_export=new("sb_export",this);
sb_fifo=new("sb_fifo",this);
endfunction
//connectphase
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
sb_export.connect(sb_fifo.analysis_export);   // 
endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
sb_fifo.get(seq_item); 
if(seq_item.dout!=seq_item.dout_gn||seq_item.tx_valid!=seq_item.tx_valid_gn)begin
    `uvm_error("run_phase",$sformatf("failed,recieved by dut:%s while golden out :0b%0b andtx_valid_gn :0b%0b",seq_item.convert2string(),seq_item.dout_gn,seq_item.tx_valid_gn));
error_count++;
end
else begin
    `uvm_info("run_phase",$sformatf(" by dut:%s" ,seq_item.convert2string()),UVM_HIGH)
correct_count++;
end
end
endtask
endclass
endpackage