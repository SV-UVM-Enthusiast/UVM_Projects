//if we have run this code in EDAplayground we hae to remove `include uvm_pkg.sv and add `include "uvm_macros.svh"
//`include "uvm_macros.svh"
`include "uvm_pkg.sv"
`define WIDTH 32 
`define DEPTH 64 
`define ADDR_WIDTH $clog2(`DEPTH) 
import uvm_pkg::*;
`include "apb_tx.sv"
`include "apb_intf.sv"
`include "apb_slave_dut.v"
`include "apb_common.sv"
`include "apb_cov.sv"
`include "apb_mon.sv"
`include "apb_seq_lib.sv"
`include "apb_drv.sv"
`include "apb_sqr.sv"
`include "apb_agent.sv"
`include "apb_env.sv"
`include "apb_test_lib.sv"

module top;

reg clk_i,rst_i;
apb_intf pif(clk_i,rst_i);

initial begin
	clk_i=0;
 	forever #5 clk_i=~clk_i;
end

initial begin
	uvm_resource_db#(virtual apb_intf)::set("GLOBAL","VIF",pif,null);
 	rst_i=1;
  	pif.addr_i=0;
  	pif.wdata_i=0;
  	pif.wr_rd_i=0;
  	pif.valid_i=0;
  	#20;
  	rst_i=0;
end

apb_slave dut(
  	.clk_i(pif.clk_i),
  	.rst_i(pif.rst_i),
  	.addr_i(pif.addr_i),
  	.wdata_i(pif.wdata_i),
  	.rdata_o(pif.rdata_o),
  	.wr_rd_i(pif.wr_rd_i),
  	.valid_i(pif.valid_i),
  	.ready_o(pif.ready_o)
);

initial begin
	run_test("apb_n_wr_rd_build_test");//similar to env.run();
end

endmodule
