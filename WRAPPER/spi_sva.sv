
module SPI_sva (SPI_if.svaa spiif);
sequence write_add;
    spiif.SS_n == 1 ##2 spiif.MOSI == 0 ##1 spiif.MOSI == 0 ##1 spiif.MOSI == 0;
endsequence

sequence read_add;
    spiif.SS_n == 1 ##2 spiif.MOSI == 1 ##1 spiif.MOSI == 1 ##1 spiif.MOSI == 0;
endsequence

sequence write_data;
    spiif.SS_n == 1 ##2 spiif.MOSI == 0 ##1 spiif.MOSI == 0 ##1 spiif.MOSI == 1;
endsequence
sequence read_data;
    spiif.SS_n == 1 ##2 spiif.MOSI == 1 ##1 spiif.MOSI == 1 ##1 spiif.MOSI == 1;
endsequence

sequence ss_n_seq;
    ##10 spiif.rx_valid ##1 spiif.SS_n[->1];
endsequence

property rst_is_ok;
    @(posedge spiif.clk) (!spiif.rst_n) |=> (spiif.MISO==0 && spiif.rx_valid==0  && (spiif.rx_data ==0));
endproperty
property rx_valid_p;
    @(posedge spiif.clk) disable iff (!spiif.rst_n) 
    (write_add or read_add or write_data or read_data) |-> ss_n_seq;
endproperty

assert property (rst_is_ok);
cover  property (rst_is_ok);

assert property (rx_valid_p);
cover  property (rx_valid_p);


endmodule
