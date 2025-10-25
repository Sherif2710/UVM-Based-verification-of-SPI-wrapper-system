import wrapper_shared_pkg::* ;
interface wrapper_if(clk);
input bit clk;
logic  MOSI, rst_n, SS_n;
logic MISO;
logic  MISO_ref;
modport SVA ( input clk,rst_n,SS_n,MOSI,output MISO);
endinterface