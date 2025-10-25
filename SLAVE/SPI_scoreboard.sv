package SPI_scoreboard_pkg;
import uvm_pkg::* ;
`include "uvm_macros.svh"
import SPI_seq_item_pkg::* ;
import SPI_shared_pkg::* ;
class SPI_scoreboard extends uvm_scoreboard;
 `uvm_component_utils(SPI_scoreboard)
 uvm_analysis_export #(SPI_seq_item) sb_export;
uvm_tlm_analysis_fifo #(SPI_seq_item) sb_fifo;
SPI_seq_item seq_item_sb;



function new(string name = "SPI_scoreboard", uvm_component parent = null);
 super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
 super.build_phase(phase);
 sb_export = new("sb_export", this);
 sb_fifo = new("sb_fifo", this);
endfunction

function void connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 sb_export.connect(sb_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
 super.run_phase(phase);
forever begin
 sb_fifo.get(seq_item_sb);
  if (seq_item_sb.rx_valid ||seq_item_sb.rx_valid_ref ) begin
 if(seq_item_sb.rx_data != seq_item_sb.rx_data_ref) begin
  `uvm_error("run_phase", $sformatf ("Comparsion 1failed, transaction done by DUT = %s , MISO_ref = 0b%0b , rx_data_ref = 0b%b, rx_valid_ref = 0b%b" , seq_item_sb.convert2string(), seq_item_sb.MISO_ref, seq_item_sb.rx_data_ref, seq_item_sb.rx_valid_ref ));
  error_count++;
 end
 else begin
 `uvm_info("run_phase" , $sformatf("Correct_out1 : %s", seq_item_sb.convert2string()), UVM_HIGH);
  correct_count++;
 end
 end

 if(seq_item_sb.MISO != seq_item_sb.MISO_ref  || seq_item_sb.rx_valid != seq_item_sb.rx_valid_ref ) begin
  `uvm_error("run_phase", $sformatf (" Comparsion 2failed, transaction done by DUT = %s , MISO_ref = 0b%0b , rx_valid_ref = 0b%b" , seq_item_sb.convert2string(), seq_item_sb.MISO_ref,seq_item_sb.rx_valid_ref ));
  error_count_2++;
 end
 else begin
 `uvm_info("run_phase" , $sformatf("Correct_out2 : %s", seq_item_sb.convert2string()), UVM_HIGH);
  correct_count_2++;
 end

end
endtask


function void report_phase(uvm_phase phase);
 super.report_phase(phase);
`uvm_info("report_phase", $sformatf("Total successful transactions: %d", correct_count), UVM_MEDIUM);
`uvm_info("report_phase", $sformatf("Total failed transactions: %d", error_count), UVM_MEDIUM);
endfunction


endclass
endpackage