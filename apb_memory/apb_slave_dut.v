
module apb_slave(clk_i,rst_i,rdata_o,wdata_i,valid_i,wr_rd_i,ready_o,addr_i);
parameter WIDTH=`WIDTH;
parameter DEPTH=`DEPTH;
parameter ADDR_WIDTH = `ADDR_WIDTH;
input clk_i,rst_i,valid_i,wr_rd_i;
input [ADDR_WIDTH-1:0]addr_i;
input [WIDTH-1:0]wdata_i;
output reg ready_o;
output reg [WIDTH-1:0]rdata_o;
integer i;
reg [WIDTH-1:0]mem[DEPTH-1:0];

    always@(posedge clk_i)begin
	if(rst_i==1)begin
		rdata_o=0;
		ready_o=0;
		for(i=0;i<DEPTH;i=i+1)begin
		mem[i]=0;
	end
	end
	else begin
	if(valid_i==1)begin
		ready_o=1;
	    if(wr_rd_i == 1)mem[addr_i]=wdata_i;
		else rdata_o=mem[addr_i];
     end
	 else begin
	  ready_o=0;
	  end
	end
	end
endmodule

