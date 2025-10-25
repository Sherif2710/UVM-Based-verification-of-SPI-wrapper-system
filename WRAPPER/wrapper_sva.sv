module wrapper_sva(wrapper_if.SVA wrapperif);

property assert_reset;
 @(posedge wrapperif.clk)  (!wrapperif.rst_n) |=> (wrapperif.MISO== 0);
endproperty

//2- An assertion to make sure that the MISO remains with a stable value eventually as long as it is not a read data operation



property MISO_IS_OK;
  @(posedge wrapperif.clk) disable iff (!wrapperif.rst_n) (!(wrapperif.MOSI&& $past(wrapperif.MOSI) && $past(wrapperif.MOSI,2))&& $past(wrapperif.SS_n,4))|=> ($stable(wrapperif.MISO) throughout (wrapperif.SS_n == 0));
endproperty

assert property (assert_reset); 
cover  property (assert_reset);


assert property (MISO_IS_OK); 
cover  property (MISO_IS_OK);




endmodule