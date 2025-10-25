import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_test_pkg::*;
module SPI_top();
bit clk;
  initial begin
    forever #1 clk=~clk;
  end

SPI_if SPIif (clk);
SLAVE DUT (SPIif.MOSI, SPIif.MISO, SPIif.SS_n, SPIif.clk, SPIif.rst_n, SPIif.rx_data, SPIif.rx_valid,  SPIif.tx_data, SPIif.tx_valid);
spi_slave golden(SPIif.clk,  SPIif.rst_n, SPIif.MOSI, SPIif.MISO_ref,  SPIif.SS_n, SPIif.rx_data_ref, SPIif.rx_valid_ref, SPIif.tx_valid, SPIif.tx_data);

  bind SLAVE SPI_sva ass_spi(SPIif.svaa);
initial begin
   uvm_config_db#(virtual SPI_if)::set(null, "uvm_test_top", "SPI_if", SPIif);
   run_test("SPI_test");
  end
endmodule