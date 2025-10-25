module spi_slave (
    input   clk,
    input   rst_n,
    input   MOSI,
    output reg MISO,
    input   SS_n,

    output reg [9:0] rx_data,
  
    output reg rx_valid,

    input  tx_valid,
    input [7:0] tx_data
);
localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001;
localparam CHK_CMD   = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;
    reg  [2:0] current_state, next_state;
   reg signed [5:0] bit_cnt_rx;
    reg addr_received;


    always @(posedge clk ) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE:
                if (!SS_n)
                    next_state = CHK_CMD;
                else 
                    next_state = IDLE;

            CHK_CMD:
                if (!SS_n)
                    next_state = (MOSI == 1'b0) ? WRITE :(addr_received == 1'b0)? READ_ADD:READ_DATA;
                else 
                    next_state = IDLE;

            WRITE:
                if (SS_n)
                    next_state = IDLE;
                else
                    next_state=WRITE;

            READ_ADD:
                if (SS_n)
                    next_state = IDLE;
                else 
                    next_state = READ_ADD;

            READ_DATA:
                if (SS_n)
                    next_state = IDLE;
                else 
                    next_state = READ_DATA;  

            default:
                    next_state = IDLE;
        endcase
    end
//output_logic
    always @(posedge clk) begin
        if (!rst_n) begin
            rx_data       <= 0;
            rx_valid      <= 0;
            MISO          <= 0;
            bit_cnt_rx       <= 0;
           // bit_cnt_tx       <= 0;
            addr_received <= 0;
        end 
        else begin
    
            case (current_state)



                WRITE: begin
                  if (bit_cnt_rx <= 9) begin
                     rx_data <= {rx_data[8:0], MOSI};
                          bit_cnt_rx <= bit_cnt_rx + 1;
                        end 
                    else if (bit_cnt_rx == 10) begin
                               rx_valid <= 1;
                    end
                  
                
                    

                end

                

                READ_ADD: begin
                 
                       if (bit_cnt_rx <= 9) begin
                     rx_data <= {rx_data[8:0], MOSI};
                          bit_cnt_rx <= bit_cnt_rx + 1;
                        end 
                     else if  (bit_cnt_rx == 10) begin
                        addr_received<=1;
                         rx_valid <= 1;
                    end
                    
                      
             
                
                end

                READ_DATA:begin
                    if (!tx_valid)begin
                 rx_valid<=0;
                          if (bit_cnt_rx <= 9) begin
                     rx_data <= {rx_data[8:0], MOSI};
                          bit_cnt_rx <= bit_cnt_rx + 1;
                        end 
                     else if  (bit_cnt_rx == 10) begin
                       rx_valid <= 1;
                      bit_cnt_rx<=-1;
                       
                    end
                 
                    end 
                    else  begin
                            rx_valid<=0;
                        if(bit_cnt_rx <= 7)begin 
                        MISO <= tx_data[7 - bit_cnt_rx];
                         bit_cnt_rx <= bit_cnt_rx + 1;
                        end

                      else if (bit_cnt_rx == 8) begin
                           // bit_cnt_tx <= 0;
                            addr_received <= 0;
                        end 
                    end
                end

                default: begin
               bit_cnt_rx <= 0;
                //bit_cnt_tx <= 0;
                rx_valid <= 0;
                end
            endcase
        end
 end
endmodule
//vcover report top.ucdb -details -annotate -all -output code_cvr.txt