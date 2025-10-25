import SPI_shared_pkg::* ;
interface SPI_if(clk);
input bit clk;
logic  MOSI, rst_n, SS_n, tx_valid;
logic [7:0] tx_data;
logic [9:0] rx_data;
logic  rx_valid, MISO;
logic [9:0] rx_data_ref;
logic rx_valid_ref, MISO_ref;

modport svaa ( input clk,rst_n,SS_n,MOSI,tx_valid,tx_data,output MISO,rx_valid,rx_data );
endinterface