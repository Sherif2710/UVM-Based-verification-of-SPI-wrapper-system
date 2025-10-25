
module ram_sva (RAM_interface.sva ram_if);





 property reset_is_Ok;
        @(posedge ram_if.clk)  (!ram_if.rst_n) |=> (ram_if.dout == 0&& ram_if.tx_valid == 0);
    endproperty


    property tx_deassert;
             @(posedge ram_if.clk)  ((ram_if.din[9:8]==2'b00||ram_if.din[9:8]==2'b01||ram_if.din[9:8]==2'b10)&&ram_if.rst_n&&ram_if.rx_valid) |=>  (ram_if.tx_valid==0);
    endproperty
//3- An assertion checks that after a read_data_seq occurs, the tx_valid signal must rise to indicate 
//valid output and after it rises by one clock cycle, it should eventually fall. 
   property tx_assert_deassert;
             @(posedge ram_if.clk)  (ram_if.din[9:8]==2'b11&&ram_if.rst_n) |=> ($rose(ram_if.tx_valid) |=> $fell(ram_if.tx_valid)[->1]);
    endproperty

 
   property write_eventually;
        @(posedge ram_if.clk)  (ram_if.din[9:8]==2'b00&&ram_if.rst_n) |=>  (ram_if.din[9:8]==2'b01 [->1]);
    endproperty

    property read_eventually;
             @(posedge ram_if.clk)  (ram_if.din[9:8]==2'b10&&ram_if.rst_n) |=>  (ram_if.din[9:8]==2'b11 [->1]);
    endproperty


    



////////////

assert property (reset_is_Ok); 
cover  property (reset_is_Ok);


assert property (tx_deassert); 
cover  property (tx_deassert);

////////////


assert property (tx_assert_deassert); 
cover  property (tx_assert_deassert);




assert property (write_eventually); 
cover  property (write_eventually);

assert property (read_eventually); 
cover  property (read_eventually);

endmodule


    



