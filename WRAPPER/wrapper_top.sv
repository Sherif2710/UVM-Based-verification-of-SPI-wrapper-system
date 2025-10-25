import uvm_pkg::*;
`include "uvm_macros.svh"
import wrapper_test_pkg::*;
module wrapper_top();
bit clk;

initial begin
           $readmemb("mem.dat", DUT_WRAPPER.RAM_instance.MEM);
      $readmemb("mem1.dat", golden_wrapper.m2.mem);
    forever begin
      #1 clk =~clk;
    end

  end


RAM_interface ramif(clk);
SPI_if spiif(clk);
wrapper_if wrapperif(clk);
WRAPPER DUT_WRAPPER (wrapperif.MOSI,wrapperif.MISO,wrapperif.SS_n,wrapperif.clk,wrapperif.rst_n);
spi_wrapper golden_wrapper (wrapperif.clk,wrapperif.rst_n, wrapperif.SS_n,wrapperif.MOSI,wrapperif.MISO_ref); 




  SLAVE SLAVE_DUT (spiif.MOSI,spiif.MISO,spiif.SS_n,spiif.clk,spiif.rst_n,spiif.rx_data,spiif.rx_valid,spiif.tx_data,spiif.tx_valid);


  spi_slave SLAVE_GOLDEN(spiif.clk, spiif.rst_n,spiif.MOSI,spiif.MISO_ref,spiif.SS_n, spiif.rx_data_ref,spiif.rx_valid_ref,spiif.tx_valid,spiif.tx_data);




    assign spiif.rst_n = DUT_WRAPPER.rst_n;
    assign spiif.SS_n = DUT_WRAPPER.SS_n;
    assign spiif.tx_valid = DUT_WRAPPER.tx_valid;
    assign spiif.tx_data = DUT_WRAPPER.tx_data_dout;
    assign spiif.MOSI = DUT_WRAPPER.MOSI;


  RAM RAM_DUT(ramif.din, ramif.clk, ramif.rst_n, ramif.rx_valid, ramif.dout, ramif.tx_valid);


  RAM_golden  RAM_GOLDEN(ramif.din,ramif.clk, ramif.rst_n,  ramif.rx_valid, ramif.dout_gn, ramif.tx_valid_gn);

    assign ramif.rst_n = DUT_WRAPPER.rst_n;
    assign ramif.rx_valid = DUT_WRAPPER.rx_valid;
    assign ramif.din = DUT_WRAPPER.rx_data_din;



  bind SLAVE SPI_sva ass_spi(spiif.svaa);
    bind RAM ram_sva my_ass(ramif.sva);
       bind WRAPPER wrapper_sva wrap_ass(wrapperif.SVA);
initial begin
   uvm_config_db#(virtual wrapper_if)::set(null, "uvm_test_top","wrapper_if", wrapperif);
   uvm_config_db#(virtual SPI_if)::set(null, "uvm_test_top", "spi_if", spiif);
   uvm_config_db#(virtual RAM_interface)::set(null, "uvm_test_top", "ram_if", ramif);
   run_test("wrapper_test");
  end
endmodule