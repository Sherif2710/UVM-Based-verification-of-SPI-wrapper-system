interface RAM_interface(clk);
input clk;

logic    [9:0] din;
logic          clk, rst_n, rx_valid;

logic[7:0] dout; //out
logic  tx_valid; //out

logic[7:0] dout_gn; //out
logic  tx_valid_gn; //out
   modport sva (input din,clk,rst_n,rx_valid, output dout,tx_valid);
endinterface