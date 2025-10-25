package ram_coverage_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import ram_sequence_item_pkg::*;

class ram_coverage extends uvm_component;
`uvm_component_utils(ram_coverage)
uvm_analysis_export #(ram_sequence_item) cov_export;
uvm_tlm_analysis_fifo  #(ram_sequence_item) cov_fifo;
ram_sequence_item seq_item;

 covergroup cvr_group; 
    Din:coverpoint seq_item.din[9:8]{
bins write_data={2'b01};
bins write_add={2'b00};
bins read_data={2'b11};
bins read_add={2'b10};
bins wa_wd=(2'b00=>2'b01); 
bins ra_rd=(2'b10=>2'b11); 
bins full_transition=(2'b00=>2'b01=>2'b10=>2'b11);  
    ignore_bins ignored_trans_ram1 = (0 => 3);
        ignore_bins ignored_trans_ram2 = (1 => 2);
        ignore_bins ignored_trans_ram3 = (2 => 1); 
}

   Rx:coverpoint seq_item.rx_valid{ 
       bins high_rx={1'b1};
}  

   Tx:coverpoint seq_item.tx_valid{ 
       bins high_tx={1'b1};
}   
 cross1 : cross Din , Rx{
    option.cross_auto_bin_max=0;
    bins wd_rx =binsof (Din.write_data) && binsof (Rx.high_rx) ;
        bins wa_rx =binsof (Din.write_add) && binsof (Rx.high_rx) ;
        bins rd_rx =binsof (Din.read_data) && binsof (Rx.high_rx) ;
            bins ra_rx =binsof (Din.read_add) && binsof (Rx.high_rx) ;
}

cross2: cross Din,Tx {
    option.cross_auto_bin_max=0;
    bins rd_tx =binsof (Din.read_data) && binsof (Tx.high_tx) ;
}

endgroup

function new (string name ="ram_coverage", uvm_component parent =null);
super.new(name,parent);
cvr_group=new();
endfunction
function void build_phase (uvm_phase phase );
  super.build_phase (phase);
cov_export=new("cov_export",this);
cov_fifo=new("cov_fifo",this);
endfunction
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
cov_export.connect(cov_fifo.analysis_export);   
endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
    cov_fifo.get(seq_item);
    cvr_group.sample();
end
endtask
endclass
endpackage
