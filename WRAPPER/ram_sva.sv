
module ram_sva (RAM_interface.sva ramif);





 property reset_is_Ok;
        @(posedge ramif.clk)  (!ramif.rst_n) |=> (ramif.dout == 0&& ramif.tx_valid == 0);
    endproperty


    property tx_deassert;
             @(posedge ramif.clk)  ((ramif.din[9:8]==2'b00||ramif.din[9:8]==2'b01||ramif.din[9:8]==2'b10)&&ramif.rst_n&&ramif.rx_valid) |=>  (ramif.tx_valid==0);
    endproperty
//3- An assertion checks that after a read_data_seq occurs, the tx_valid signal must rise to indicate 
//valid output and after it rises by one clock cycle, it should eventually fall. 
   property tx_assert_deassert;
             @(posedge ramif.clk)  (ramif.din[9:8]==2'b11&&ramif.rst_n) |=> ($rose(ramif.tx_valid) |=> $fell(ramif.tx_valid)[->1]);
    endproperty

 
   property write_eventually;
        @(posedge ramif.clk)  (ramif.din[9:8]==2'b00&&ramif.rst_n) |=>  (ramif.din[9:8]==2'b01 [->1]);
    endproperty

    property read_eventually;
             @(posedge ramif.clk)  (ramif.din[9:8]==2'b10&&ramif.rst_n) |=>  (ramif.din[9:8]==2'b11 [->1]);
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


    



