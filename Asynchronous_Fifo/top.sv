`include "uvm_pkg.sv"
import uvm_pkg::*;
`include "common.sv"
`include "write_tx.sv"
`include "read_tx.sv"
`include "write_seq_lib.sv"
`include "read_seq_lib.sv"
`include "async_fifo_intf.sv"
`include "fifo_sbd.sv"
`include "async_fifo.v"
`include "write_sqr.sv"
`include "write_mon.sv"
`include "write_drv.sv"
`include "write_cov.sv"
`include "read_mon.sv"
`include "read_cov.sv"
`include "read_drv.sv"
`include "read_sqr.sv"
`include "write_agent.sv"
`include "read_agent.sv"
`include "top_sqr.sv"
`include "top_seq_lib.sv"
`include "async_fifo_env.sv"
`include "test_lib.sv"
module top;
parameter NUM_TXS=100;
parameter MAX_WR_DELAY=13;
parameter MAX_RD_DELAY=13;
reg rd_clk_i,wr_clk_i,rst_i;

async_fifo_intf pif(rst_i, wr_clk_i, rd_clk_i);

async_fifo dut(.wr_clk_i(pif.wr_clk_i),
			   .rd_clk_i(pif.rd_clk_i),
			   .rst_i(pif.rst_i),
			   .wr_en_i(pif.wr_en_i),
			   .wdata_i(pif.wdata_i),
			   .wr_error_o(pif.wr_error_o),
			   .full_o(pif.full_o),
			   .rd_en_i(pif.rd_en_i),
			   .rdata_o(pif.rdata_o),
			   .empty_o(pif.empty_o),
			   .rd_error_o(pif.rd_error_o));


initial begin
	wr_clk_i=0;
	forever #5 wr_clk_i=~wr_clk_i;
end
initial begin
	rd_clk_i=0;
	forever #5 rd_clk_i=~rd_clk_i;
end

initial begin
	run_test("fifo_full_error_test");
end
initial begin
	uvm_resource_db#(virtual async_fifo_intf)::set("GLOBAL", "PIF", pif, null);
	rst_i=1;
	pif.wdata_i=0;
	pif.wr_en_i=0;
	pif.rd_en_i=0;
 	#20;
	rst_i=0;
end
endmodule
