vlog top.sv
set fp [open "test_list.txt" r]
while {[get $fp testname] >=0 } {
    vsim top +UVM_TESTNAME=$testname
    run -all
 }
  #we dont see the waveforms during the regration
