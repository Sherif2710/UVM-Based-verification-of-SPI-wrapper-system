
package SPI_seq_item_pkg;
import SPI_shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

 class SPI_seq_item extends uvm_sequence_item;
    `uvm_object_utils(SPI_seq_item)

   
    function new(string name = "SPI_seq_item");
      super.new(name);
    endfunction

    typedef enum {IDLE, CHK_CMD, WRITE, READ_ADD, READ_DATA} states;
 typedef enum bit [2:0]{WR_ADDR=3'b000, WR_DATA=3'b001, RD_ADDR=3'b110, RD_DATA=3'b111} statess;

   
    rand bit MOSI, rst_n, SS_n;
    rand bit [7:0] tx_data;
    bit [7:0] old_tx_data;
    rand bit tx_valid;
    rand bit [10:0] mosi_arr;

    
    bit  rx_valid, MISO;
    bit [9:0] rx_data;
  bit [9:0] rx_data_ref;
bit rx_valid_ref, MISO_ref;

 
    bit [10:0] old_mosi_arr;
    states cs;
    rand states ns;
    

   
    constraint reset_constrains { rst_n dist {1 := 99, 0 := 1}; }



    constraint ns_c {
      if (!rst_n || SS_n) { ns == IDLE; }
      else if (cs == IDLE && !SS_n) { ns == CHK_CMD; }
      else if (cs == CHK_CMD && !SS_n && !MOSI) { ns == WRITE; }
      else if (cs == CHK_CMD && !SS_n && MOSI && address_recieved == 0) { ns == READ_ADD; }
      else if (cs == CHK_CMD && !SS_n && MOSI && address_recieved == 1) { ns == READ_DATA; }
      else if ((cs == WRITE) && Count_seq != 13) { ns == cs; }
      else if ((cs == READ_ADD) && Count_seq != 13) { ns == cs; }
      else if ((cs == READ_DATA) && Count_seq != 23) { ns == cs; }
    }

        constraint SS_n_c {
          
      if (cs != READ_DATA) {
        (Count_seq == 13) -> SS_n == 1;
        (Count_seq != 13) -> SS_n == 0;
      }
      else if (cs == READ_DATA) {
        (Count_seq == 23) -> SS_n == 1;
        (Count_seq != 23) -> SS_n == 0;
      }
    }

constraint mosi_arr_c {
  if (!rst_n || Count_seq == 0) {
        if(old_mosi_arr[10:8] == WR_ADDR) //Write_address
                mosi_arr[10:8]inside {WR_ADDR, WR_DATA};         // write_address or write_data 
            else if (old_mosi_arr[10:8]  == WR_DATA) //write_data
                mosi_arr[10:8]dist {RD_ADDR:= 60, WR_ADDR:=40}; // read_address = 60%, write_address = 40%
            else if  (old_mosi_arr[10:8]  == RD_ADDR) // Read_address
                mosi_arr[10:8]== RD_DATA;  
           else if  (old_mosi_arr[10:8]  == RD_DATA)
                mosi_arr[10:8]dist {WR_ADDR:=60, RD_ADDR:= 40}; // Write Address = 60%, Read Address = 40%
  }
         else {
             mosi_arr == old_mosi_arr;}

}
    constraint MOSI_c { if (!SS_n && rst_n) MOSI == mosi_arr[10 - i]; }

    constraint tx_valid_c {
      if (Count_seq > 13 && Count_seq <= 23) { tx_valid == 1; }
      else { tx_valid == 0; }
    }


    constraint tx_data_c {
      if (Count_seq > 12 && Count_seq <= 23) {tx_data==old_tx_data};
    }



    function void post_randomize();
      old_mosi_arr = mosi_arr;
      old_tx_data=tx_data;
      if (!rst_n) begin
        cs = IDLE;
        Count_seq = 0;
        i = 0;
        address_recieved = 0;
      end
      else begin
        cs = ns;
        if (cs == READ_ADD) address_recieved = 1;
        else if (cs == READ_DATA) address_recieved = 0;
        if (cs != READ_DATA) begin
          if (Count_seq >= 13) begin
            Count_seq = 0;
          end
          else begin
            Count_seq++;
          end
        end
        else begin
          if (Count_seq >= 23) begin
            Count_seq = 0;
          end
          else begin
            Count_seq++;
          end
        end

        i++;
        if (i == 11 || Count_seq == 1)
          i = 0; 
      end
    endfunction

    function string convert2string();
        return $sformatf("%s rst_n = 0b%0b , MOSI = 0b%0b , SS_n = 0b%0b , tx_valid = 0b%0b , tx_data = 0x%02h , MISO = 0b%0b , rx_valid = 0b%0b , rx_data =  0b%0b",
            super.convert2string(), rst_n, MOSI, SS_n, tx_valid, tx_data, MISO, rx_valid, rx_data);
    endfunction

    function string convert2string_stimulus();
        return $sformatf("%s rst_n = 0b%0b , MOSI = 0b%0b , SS_n = 0b%0b , tx_valid = 0b%0b , tx_data = 0x%02h",
            super.convert2string(), rst_n, MOSI, SS_n, tx_valid, tx_data);
    endfunction



  endclass

endpackage