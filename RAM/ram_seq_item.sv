package ram_sequence_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class  ram_sequence_item extends uvm_sequence_item;
`uvm_object_utils(ram_sequence_item)


 rand bit  [9:0] din;
 rand bit rst_n, rx_valid;
/////
logic[1:0] old_din; //out
logic[7:0] dout; //out
logic  tx_valid; //out

logic[7:0] dout_gn; //out
logic  tx_valid_gn; //out
function new (string name ="ram_sequence_item");
super.new(name);
 old_din = 2'b00;
endfunction

constraint RESET{rst_n dist{0:=10 ,1:=90};} //low 90/100 
constraint RX{rx_valid dist{1:=90 ,0:=10};} //high 90/100 
//3- For a write-only sequence, every Write Address operation shall always be followed by eitherWrite Address or Write Data operation.
 constraint write_only { if (old_din == 2'b00) din[9:8]==2'b01;
 else if (old_din == 2'b01) din[9:8]==2'b00;
 else din[9:8]==2'b00; }


//4- For a read-only sequence, every Read Address operation shall always be followed by Read
//Data. After a Read Data operation shall always be followed by Read Address. 
 constraint read_only { if (old_din== 2'b10) din[9:8] ==2'b11 ;
  else if (old_din == 2'b11) din[9:8] ==2'b10 ;
  else din[9:8] ==2'b10;} 


constraint write_read {
  if (old_din == 2'b00) din[9:8] dist {2'b00 := 50, 2'b01 := 50};
  else if (old_din == 2'b01) din[9:8] dist {2'b00 := 40, 2'b10 := 60};
  else if (old_din == 2'b10) din[9:8] dist {2'b11 := 100}; //• Every Read Address operation shall always be followed by Read Data operation.
  else if (old_din == 2'b11) din[9:8] dist {2'b10 := 40, 2'b00 := 60};
}
function void post_randomize;
old_din=din[9:8];
endfunction

function string convert2string();
return $sformatf("%s din=0b%0b,rst_n=0b%0b,rx_valid=0b%0b,dout=0b%0b,tx_valid=0b%0b",super.convert2string(),din,rst_n,rx_valid,dout,tx_valid);
endfunction

function string convert2string_stimulus();
return $sformatf(" din=0b%0b,rst_n=0b%0b,rx_valid=0b%0b",din,rst_n,rx_valid);
endfunction
endclass
endpackage