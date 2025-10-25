vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.wrapper_top -classdebug -uvmcontrol=all -cover -sv_seed 829610917 -l sim.log
add wave -position insertpoint sim:/wrapper_top/wrapperif/*
add wave -position insertpoint  \
sim:/wrapper_top/DUT_WRAPPER/RAM_instance/MEM \
sim:/wrapper_top/DUT_WRAPPER/RAM_instance/Rd_Addr \
sim:/wrapper_top/DUT_WRAPPER/RAM_instance/Wr_Addr
add wave -position insertpoint  \
sim:/wrapper_shared_pkg::error_count_w \
sim:/wrapper_shared_pkg::error_count_2_s
add wave -position insertpoint  \
sim:/wrapper_top/golden_wrapper/tx_valid \
sim:/wrapper_top/golden_wrapper/tx_data
add wave -position insertpoint  \
sim:/wrapper_top/DUT_WRAPPER/SLAVE_instance/tx_valid \
sim:/wrapper_top/DUT_WRAPPER/SLAVE_instance/counter \
sim:/wrapper_top/DUT_WRAPPER/SLAVE_instance/cs \
sim:/wrapper_top/DUT_WRAPPER/SLAVE_instance/ns
add wave -position insertpoint  \
sim:/wrapper_top/golden_wrapper/m1/tx_valid \
sim:/wrapper_top/golden_wrapper/m1/tx_data \
sim:/wrapper_top/golden_wrapper/m1/bit_cnt_rx
add wave -position insertpoint  \
sim:/wrapper_top/DUT_WRAPPER/SLAVE_instance/tx_data
add wave -position insertpoint  \
sim:/wrapper_top/DUT_WRAPPER/SLAVE_instance/rx_valid
add wave -position insertpoint  \
sim:/wrapper_top/DUT_WRAPPER/RAM_instance/rx_valid
add wave -position insertpoint  \
sim:/wrapper_top/golden_wrapper/m1/rx_valid
add wave -position insertpoint  \
sim:/wrapper_top/golden_wrapper/m2/rx_valid
add wave -position insertpoint  \
sim:/wrapper_top/DUT_WRAPPER/SLAVE_instance/rx_data
add wave -position insertpoint  \
sim:/wrapper_top/DUT_WRAPPER/RAM_instance/din
add wave -position insertpoint  \
sim:/wrapper_top/RAM_GOLDEN/mem
coverage save top.ucdb -onexit
run -all

