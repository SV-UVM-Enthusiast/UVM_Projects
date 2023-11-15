vlog +incdir+F:/uvm_source_code/uvm-1.2/src top.sv
vsim -novopt -suppress 12110 top +UVM_TESTNAME=apb_n_wr_rd_run_test +UVM_VERBOSITY=UVM_NONE -sv_lib C:/questasim64_10.7c/uvm-1.2/win64/uvm_dpi -l comp.log
add wave -position insertpoint sim:/top/pif/*
run -all

