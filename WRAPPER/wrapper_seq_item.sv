package wrapper_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import wrapper_shared_pkg::*;

    class wrapper_seq_item extends uvm_sequence_item;
        `uvm_object_utils(wrapper_seq_item)

      
        typedef enum bit [1:0] { WR_ADDR_INS = 2'b00, WR_DATA_INS = 2'b01, RD_ADDR_INS = 2'b10, RD_DATA_INS = 2'b11 } state_e;

        rand bit MOSI, SS_n, rst_n;
        bit MISO;
        bit MISO_ref;

        rand state_e state = WR_ADDR_INS;
        state_e state_old = WR_ADDR_INS;

        rand bit [10:0] mosi_arr;

        bit rand_signal, reset_flag;
        int count = 0;
        bit SS_n_signal = 1;

   
        function new(string name = "wrapper_seq_item");
            super.new(name);
        endfunction

        function void pre_randomize();
            if (count == 0 || !rst_n) begin
                mosi_arr.rand_mode(1);
                state.rand_mode(1);
                rand_signal = 1;
            end
            else begin
                mosi_arr.rand_mode(0);
                state.rand_mode(0);
                rand_signal = 0;
            end
        endfunction

  
        constraint reset_constrains { rst_n dist {1 := 99, 0 := 1};
}

        constraint mosi_arr_c { mosi_arr[10:8] == {state[1],state}; }

        constraint MOSI_c {
            if (count > 0 && count < 12)
                MOSI == mosi_arr[11 - count];
        }

        constraint SS_n_c {
            SS_n == SS_n_signal;
        }

        constraint write_only_const {
            state inside {WR_ADDR_INS, WR_DATA_INS};
        }

        constraint read_only_const {
            if (start_read || reset_flag || (state_old == RD_DATA_INS && rand_signal)) {
                state == RD_ADDR_INS; 
            }
            else if (state_old == RD_ADDR_INS && rand_signal) {
                state == RD_DATA_INS; 
            }
        }

        constraint write_read_const {
            if (start_read || reset_flag || (state_old == WR_ADDR_INS && rand_signal)) {
                state inside {WR_ADDR_INS, WR_DATA_INS};
            }
            else if (state_old == WR_DATA_INS && rand_signal) {
                state dist {RD_ADDR_INS := 60, WR_ADDR_INS := 40};
            }
            else if (state_old == RD_DATA_INS && rand_signal) {
                state dist {WR_ADDR_INS := 60, RD_ADDR_INS := 40};
            }
            else if (state_old == RD_ADDR_INS && rand_signal) {
                state inside {RD_DATA_INS};
            }
        }

        function void post_randomize();
            if (!rst_n || SS_n) begin
                count = 0;
                SS_n_signal = 0;
            end
            else count++;

            if (count > 12 && count < 23) begin
                if (state != RD_DATA_INS)
                    SS_n_signal = 1;
                else
                    SS_n_signal = 0;
            end
            else if (count == 23) begin
                if (state == RD_DATA_INS)
                    SS_n_signal = 1;
                else
                    SS_n_signal = 0;
            end
            else SS_n_signal = 0;

            state_old = state;
            if (!rst_n) reset_flag = 1;
            else reset_flag = 0;
        endfunction

 
                 function string convert2string();
        return $sformatf("%s rst_n = 0b%0b , MOSI = 0b%0b , SS_n = 0b%0b , MISO = 0b%0b ", super.convert2string(), rst_n, MOSI, SS_n,  MISO);
    endfunction

    function string convert2string_stimulus();
        return $sformatf("%s rst_n = 0b%0b , MOSI = 0b%0b , SS_n = 0b%0b ",  super.convert2string(), rst_n, MOSI, SS_n);
    endfunction

    endclass
endpackage
