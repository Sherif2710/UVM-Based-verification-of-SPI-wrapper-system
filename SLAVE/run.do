vlib work
vlog  +define+SIM -f src_files.list +cover -covercells
vsim -voptargs=+acc work.SPI_top -classdebug -uvmcontrol=all -cover -sv_seed 1336091805 -l sim.log
add wave -position insertpoint sim:/SPI_top/SPIif/*
add wave -position insertpoint  \
sim:/SPI_top/DUT/counter \
sim:/SPI_top/DUT/cs \
sim:/SPI_top/DUT/ns
add wave -position insertpoint  \
sim:/SPI_shared_pkg::error_count \
sim:/SPI_shared_pkg::error_count_2
add wave -position insertpoint  \
sim:/SPI_top/golden/bit_cnt_rx
add wave -position insertpoint  \
sim:/SPI_shared_pkg::Count_seq
add wave -position insertpoint  \
sim:/SPI_top/DUT/received_address
coverage save SPI_top.ucdb -onexit
run -all
#quit -sim