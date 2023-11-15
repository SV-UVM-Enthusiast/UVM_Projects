module async_fifo(wr_clk_i,rd_clk_i,rst_i,wr_en_i,wdata_i,wr_error_o,full_o,rd_en_i,rdata_o,empty_o,rd_error_o);

parameter PTR_WIDTH=4;
input rd_clk_i,wr_clk_i,rst_i,wr_en_i,rd_en_i;
output reg wr_error_o,rd_error_o,full_o,empty_o;
input [`WIDTH-1:0]wdata_i;
output reg [`WIDTH-1:0]rdata_o;
reg [PTR_WIDTH-1:0]wr_ptr,rd_ptr,wr_ptr_rd_clk,rd_ptr_wr_clk;
reg [`WIDTH-1:0]mem[`DEPTH-1:0];
reg wr_toggle_f,rd_toggle_f,wr_toggle_f_rd_clk,rd_toggle_f_wr_clk;
integer i;

  always@(posedge wr_clk_i)begin
  if(rst_i==1)begin
   rdata_o=0;
   wr_ptr=0;
   rd_ptr=0;
   wr_ptr_rd_clk=0;
   rd_ptr_wr_clk=0;
   full_o=0;
   empty_o=1;
   wr_error_o=0;
   rd_error_o=0;
   wr_toggle_f=0;
   rd_toggle_f=0;
   wr_toggle_f_rd_clk=0;
   rd_toggle_f_wr_clk=0;
     for(i=0;i<`DEPTH;i=i+1)begin
	 mem[i]=1;  
	 end
  end
  else begin

		   wr_error_o=0;
        if(wr_en_i==1)begin
		   if(full_o==1)begin
		   wr_error_o=1;
			end
		   else begin
			mem[wr_ptr]=wdata_i;
			if(wr_ptr==`DEPTH-1)wr_toggle_f=~wr_toggle_f;
			wr_ptr=wr_ptr+1;
		   end
		end
		end
		end

		 always@(posedge rd_clk_i)begin
		if(rst_i!=1)begin
		  rd_error_o=0;
		if(rd_en_i==1)begin
		  if(empty_o==1)begin
		  rd_error_o=1;
		  end
		  else begin
		  rdata_o=mem[rd_ptr];
		  if(rd_ptr==`DEPTH-1)rd_toggle_f=~rd_toggle_f;
		  rd_ptr=rd_ptr+1;
		  end
		end
  end
  end
    always@(*)begin
	empty_o=0;
	full_o=0;

	  if(wr_ptr==rd_ptr_wr_clk)begin
	    if(wr_toggle_f!=rd_toggle_f_wr_clk) full_o=1;
	  end
	  if(wr_ptr_rd_clk==rd_ptr)begin
	    if(wr_toggle_f_rd_clk==rd_toggle_f) empty_o=1;
	  end
	end
	 always@(posedge wr_clk_i)begin
 			rd_ptr_wr_clk <= rd_ptr;
			rd_toggle_f_wr_clk <= rd_toggle_f;
	 end
	 always@(posedge rd_clk_i)begin
 			wr_ptr_rd_clk <= wr_ptr;
			wr_toggle_f_rd_clk <= wr_toggle_f;
	 end
endmodule
