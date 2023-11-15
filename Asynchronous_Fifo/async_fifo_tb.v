`timescale 1ns/1ns
`include "fifo.v"
module tb;

reg rd_clk_i,wr_clk_i,rst_i,wr_en_i,rd_en_i;
parameter DEPTH=16, WIDTH=8, PTR_WIDTH=4;
parameter WR_CLK_TP=25,RD_CLK_TP=30;
wire wr_error_o,rd_error_o,full_o,empty_o;
reg [WIDTH-1:0]wdata_i;
wire [WIDTH-1:0]rdata_o;
integer j,k;
reg [30*8:1]testname;

async_fifo dut(.wr_clk_i(wr_clk_i),.rd_clk_i(rd_clk_i),.rst_i(rst_i),.wr_en_i(wr_en_i),.wdata_i(wdata_i),.wr_error_o(wr_error_o),.full_o(full_o),.rd_en_i(rd_en_i),.rdata_o(rdata_o),.empty_o(empty_o),.rd_error_o(rd_error_o));
always begin
wr_clk_i=0; #(WR_CLK_TP/2.0);
wr_clk_i=1; #(WR_CLK_TP/2.0);
end
always begin
rd_clk_i=0; #(RD_CLK_TP/2.0);
rd_clk_i=1; #(RD_CLK_TP/2.0);
end 
    initial begin
   	$value$plusargs("testname=%s",testname);
	rst_i=1;
	wdata_i=0;
	wr_en_i=0;
	rd_en_i=0;
	@(posedge wr_clk_i);
	rst_i=0;
	case(testname)
	"test_full":begin
	write_fifo(DEPTH);
	end
	"test_empty":begin
	write_fifo(DEPTH);
	read_fifo(DEPTH);
	end
	"test_full_error":begin
	write_fifo(DEPTH+1);
	read_fifo(DEPTH);
	end
	"test_empty_error":begin
	write_fifo(DEPTH);
	read_fifo(DEPTH+1);
	end
	"test_concurnt_rd_wr":begin
	fork
	begin
		 write_fifo(2*DEPTH);
	end
	begin
		 read_fifo(2*DEPTH+1);
	end
	join

	end
	endcase
	 #100;
	 $finish;
     end	
 
     
	 task write_fifo(input integer num_wr);
	 begin
     for(j=0;j<num_wr;j=j+1)begin
	 @(posedge wr_clk_i);
	 wr_en_i=1;
	 wdata_i=$random;
	 end
	 @(posedge wr_clk_i);
	 wr_en_i=0;
	 wdata_i=0;
	 end
	 endtask

     task read_fifo(input integer num_rd);
	 begin
	 for(k=0;k<num_rd;k=k+1)begin
	 @(posedge rd_clk_i);
	 rd_en_i=1;
	 end
	 @(posedge rd_clk_i);
	 rd_en_i=0;
	 end
	 endtask

endmodule
