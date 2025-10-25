package SPI_cvr_collector_pkg;
import uvm_pkg::* ;
`include "uvm_macros.svh"
import SPI_seq_item_pkg::* ;
import wrapper_shared_pkg::* ;
class SPI_cvr_collector extends uvm_component;
 `uvm_component_utils(SPI_cvr_collector)
uvm_analysis_export #(SPI_seq_item) cvr_export;
uvm_tlm_analysis_fifo #(SPI_seq_item) cvr_fifo;
SPI_seq_item seq_item_cvr;

covergroup SPIcg ;
cp1: coverpoint seq_item_cvr.rx_data[9:8] {
    bins all_possible_values [] = {2'b00, 2'b01, 2'b10, 2'b11};
    bins trans1 [] = (0=>1,2,3);
    ignore_bins ignored_trans1 = (0 => 3);
    bins trans2 [] = (1=>0,2,3);
        ignore_bins ignored_trans2 = (1 => 2);
    bins trans3 [] = (2=>0,1,3);
        ignore_bins ignored_trans3 = (2 => 1);
    bins trans4 [] = (3=>0,1,2);
}


cp2: coverpoint seq_item_cvr.SS_n {
    option.auto_bin_max = 0;
    bins trans_full = (1=>0[*13]=>1);
    bins trans_extended = (1=>0[*23]=>1);
}

cp3: coverpoint seq_item_cvr.MOSI {
    option.auto_bin_max = 0;
    bins trans_write_address = (0=>0=>0);
    bins trans_write_data = (0=>0=>1);
    bins trans_read_address = (1=>1=>0);
    bins trans_read_data = (1=>1=>1);
}

cross_MOSI_SS_n: cross cp2, cp3 {
    option.cross_auto_bin_max = 0;
   bins write_address_SS_n = binsof(cp3.trans_write_address) && binsof(cp2.trans_full);
   bins write_data_SS_n = binsof(cp3.trans_write_data) && binsof(cp2.trans_full);
   bins read_address_SS_n = binsof(cp3.trans_read_address) && binsof(cp2.trans_full);
   bins read_data_SS_n = binsof(cp3.trans_read_data) && binsof(cp2.trans_extended);
}

endgroup

function new(string name = "SPI_cvr_collector", uvm_component parent = null);
 super.new(name,parent);
 SPIcg = new();
endfunction

function void build_phase (uvm_phase phase);
 super.build_phase(phase);
 cvr_export = new("cvr_export", this);
 cvr_fifo = new("cvr_fifo", this);
endfunction

function void connect_phase(uvm_phase phase);
 super.connect_phase(phase);
 cvr_export.connect(cvr_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
 super.run_phase(phase);
forever begin
 cvr_fifo.get(seq_item_cvr);
 SPIcg.sample();
end
endtask
endclass
endpackage