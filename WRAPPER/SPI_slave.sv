module SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001;
localparam CHK_CMD   = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

input            MOSI, clk, rst_n, SS_n, tx_valid;
input      [7:0] tx_data;
output reg [9:0] rx_data;
output reg       rx_valid, MISO;

reg [3:0] counter;
reg       received_address;

reg [2:0] cs, ns;

always @(posedge clk) begin
    if (~rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (SS_n)
                ns = IDLE;
            else begin
                if (~MOSI)
                    ns = WRITE;
                else begin
                    if (!received_address) //buggg!!received_address
                        ns = READ_ADD; 
                    else
                        ns = READ_DATA;
                end
            end
        end
        WRITE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end

    endcase
  
end

always @(posedge clk) begin
    if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        received_address <= 0;
        MISO <= 0;
        counter<=0;//counter must be reseted
    end

    else begin
        case (cs)
            IDLE : begin
                rx_valid <= 0;
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                    received_address <= 1;
                end
            end

            READ_DATA : begin
                //cycle 13   13 14 15 16 17 18 19 20  21 22
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (counter > 0) begin
                        MISO <= tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        received_address <= 0; 
                    end
                end
                
                else begin
                    rx_valid<=0;
                    if (counter > 0) begin
                        rx_data[counter-1] <= MOSI;
                        counter <= counter - 1;
                    end

                    else begin
                        rx_valid <= 1;
                        counter <= 9; //counter<=9 not 8
                    end

                end
            end
      
        endcase
    end
end
`ifdef SIM
//1- An assertion ensures that whenever reset is asserted, the outputs (MISO, rx_valid, and rx_data) are all low.

 



property chkcmd_idle;
    @(posedge clk) (cs == IDLE&&rst_n&&!SS_n) |=> (cs == CHK_CMD);
endproperty

property chkcmd_write;
    @(posedge clk)  (cs == CHK_CMD &&rst_n && !SS_n && !MOSI) |=> (cs == WRITE);
endproperty

property chkcmd_ra;
    @(posedge clk)  (cs == CHK_CMD &&rst_n && !SS_n && MOSI && !received_address) |=> (cs == READ_ADD);
endproperty
property chkcmd_rd;
    @(posedge clk) (cs == CHK_CMD &&rst_n && !SS_n && MOSI && received_address) |=> (cs == READ_DATA);
endproperty
property write_idle;
    @(posedge clk) (cs == WRITE&&rst_n&&SS_n) |=> (cs == IDLE);
endproperty

property ra_idle;
    @(posedge clk) (cs == READ_ADD&&rst_n&&SS_n) |=> (cs == IDLE);
endproperty

    property rd_idle;
    @(posedge clk) (cs == READ_DATA&&rst_n&&SS_n) |=> (cs == IDLE);
endproperty



assert property (chkcmd_idle);
cover  property (chkcmd_idle);

assert property (chkcmd_write);
cover  property (chkcmd_write);

assert property (chkcmd_ra);
cover  property (chkcmd_ra);

assert property (chkcmd_rd);
cover  property (chkcmd_rd);

assert property (write_idle);
cover  property (write_idle);

assert property (ra_idle);
cover  property (ra_idle);

assert property (rd_idle);
cover  property (rd_idle);


`endif

endmodule