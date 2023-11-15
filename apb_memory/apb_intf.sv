interface apb_intf(input bit clk_i,rst_i);
	bit [`ADDR_WIDTH-1:0]addr_i;
	bit [`WIDTH-1:0]wdata_i;
	bit [`WIDTH-1:0]rdata_o;
	bit wr_rd_i,valid_i;
	bit ready_o;

clocking bfm_cb@(posedge clk_i);
	default input #1 output #0;
		output  addr_i;
   		output  wdata_i;
   		input  rdata_o;
   		output  wr_rd_i, valid_i;
   		input  ready_o;
endclocking

 
clocking mon_cb@(posedge clk_i);
	default input #1;
		input  addr_i;
		input  wdata_i;
		input  rdata_o;
		input  wr_rd_i, valid_i;
		input  ready_o;
endclocking
 
modport bfm_mp(clocking bfm_cb);
modport mon_mp(clocking mon_cb);

endinterface

