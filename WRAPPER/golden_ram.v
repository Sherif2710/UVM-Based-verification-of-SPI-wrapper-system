module RAM_golden(din,clk,rst_n,rx_valid,dout,tx_valid);
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE  = 8;
input clk,rst_n,rx_valid;
input [9:0] din;
output reg [7:0]dout;
output reg tx_valid;
reg [ADDR_SIZE-1:0] mem[MEM_DEPTH-1:0];
reg [ADDR_SIZE-1:0]addr_wr, addr_rd;
always @(posedge clk)begin
if(!rst_n)begin
    dout<=0;
    tx_valid<=0;
    addr_wr<=0;
    addr_rd<=0;
end
else if(rx_valid)begin
if(din[9:8]==0)begin
    addr_wr<=din[7:0];
    tx_valid<=0;
end
else if(din[9:8]==1)begin
    mem[addr_wr]<=din[7:0];
    tx_valid<=0;
end
else if(din[9:8]==2)begin
    addr_rd<=din[7:0];
    tx_valid<=0;
end

 else if(din[9:8]==3)begin
    dout<=mem[addr_rd];
     tx_valid<=1;
 end
end
end 
endmodule
