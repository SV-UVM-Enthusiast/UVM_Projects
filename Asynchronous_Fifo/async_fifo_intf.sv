interface async_fifo_intf(
			input bit rst_i ,wr_clk_i, rd_clk_i
			);

bit wr_en_i,rd_en_i;
bit wr_error_o,rd_error_o,full_o,empty_o;
bit [`WIDTH-1:0]wdata_i;
bit [`WIDTH-1:0]rdata_o;

clocking write_mon_cb@(posedge wr_clk_i);
	default input #1;
	input wr_en_i;
	input wdata_i;
	input wr_error_o;
	input full_o,empty_o;
endclocking

clocking read_mon_cb@(posedge rd_clk_i);
	default input #1;
	input rd_en_i;
	input rdata_o;
	input rd_error_o;
	input full_o,empty_o;
endclocking
endinterface
