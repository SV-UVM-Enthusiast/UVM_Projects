vlog +incdir+F:/uvm_source_code/uvm-1.2/src top.sv
vsim -novopt -suppress 12110 top +UVM_TESTNAME=apb_multi_seq_test1 -sv_lib C:/questasim64_10.7c/uvm-1.2/win64/uvm_dpi
add wave -position insertpoint sim:/top/pif/*
run -all

