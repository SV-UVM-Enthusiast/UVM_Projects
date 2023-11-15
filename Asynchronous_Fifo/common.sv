`define NEW_COMP\
function new(string name,uvm_component parent);\
	super.new(name,parent);\
endfunction

`define NEW_OBJ\
function new(string name="");\
	super.new(name);\
endfunction

`define ADDR_WIDTH 8
`define WIDTH 16
`define DEPTH 16
`define MAX_WR_DELAY 4 
`define MAX_RD_DELAY 6

class async_fifo_common;
	static int num_matches;
	static int num_mismatches;
endclass
