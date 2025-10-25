
module SPI_sva (SPI_if.svaa SPIif);
sequence write_add;
    SPIif.SS_n == 1 ##2 SPIif.MOSI == 0 ##1 SPIif.MOSI == 0 ##1 SPIif.MOSI == 0;
endsequence

sequence read_add;
    SPIif.SS_n == 1 ##2 SPIif.MOSI == 1 ##1 SPIif.MOSI == 1 ##1 SPIif.MOSI == 0;
endsequence

sequence write_data;
    SPIif.SS_n == 1 ##2 SPIif.MOSI == 0 ##1 SPIif.MOSI == 0 ##1 SPIif.MOSI == 1;
endsequence
sequence read_data;
    SPIif.SS_n == 1 ##2 SPIif.MOSI == 1 ##1 SPIif.MOSI == 1 ##1 SPIif.MOSI == 1;
endsequence

sequence ss_n_seq;
    ##10 SPIif.rx_valid ##1 SPIif.SS_n[->1];
endsequence

property rst_is_ok;
    @(posedge SPIif.clk) (!SPIif.rst_n) |=> (SPIif.MISO==0 && SPIif.rx_valid==0  && (SPIif.rx_data ==0));
endproperty
property rx_valid_p;
    @(posedge SPIif.clk) disable iff (!SPIif.rst_n) 
    (write_add or read_add or write_data or read_data) |-> ss_n_seq;
endproperty

assert property (rst_is_ok);
cover  property (rst_is_ok);

assert property (rx_valid_p);
cover  property (rx_valid_p);


endmodule
