vlog +incdir+F:/uvm_source_code/uvm-1.2/src top.sv
vsim -novopt -suppress 12110 top -sv_lib C:/questasim64_10.7c/uvm-1.2/win64/uvm_dpi +UVM_TESTNAME=fifo_wr_rd_top_sqr_test -l comp.log 
add wave -position insertpoint sim:/top/pif/*
run -all
