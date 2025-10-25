vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.ram_top -classdebug -uvmcontrol=all -cover 
add wave -position insertpoint  \
sim:/ram_top/DUT/MEM \
sim:/ram_top/DUT/Rd_Addr \
sim:/ram_top/DUT/Wr_Addr
add wave -position insertpoint  \
sim:/ram_top/DUT_golden/addr_rd \
sim:/ram_top/DUT_golden/addr_wr \
sim:/ram_top/DUT_golden/mem
coverage save ram_top.ucdb -onexit
run -all
#quit -sim


