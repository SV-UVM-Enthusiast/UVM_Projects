class write_drv extends uvm_driver#(write_tx);
virtual async_fifo_intf vif;
`uvm_component_utils(write_drv)
`NEW_COMP
uvm_analysis_port#(write_tx) ap_port;

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_resource_db#(virtual async_fifo_intf)::read_by_name("GLOBAL", "PIF", vif, this))
 begin
   `uvm_error("INTF", "Not able to get async_fifo_intf from resource db")
   end
   ap_port = new("ap_port",this);
endfunction

task run_phase(uvm_phase phase);
wait (vif.rst_i==0);
forever begin
	seq_item_port.get_next_item(req);
	ap_port.write(req);
	drive_tx(req);
	seq_item_port.item_done();
end
endtask

task drive_tx(write_tx tx);
	 @(posedge vif.wr_clk_i);
	 vif.wr_en_i=1;
	 vif.wdata_i=tx.data;
	 @(posedge vif.wr_clk_i);
	 vif.wr_en_i=0;
	// vif.wdata_i=0;
	 repeat(tx.delay) @(posedge vif.wr_clk_i);
	
endtask
endclass

