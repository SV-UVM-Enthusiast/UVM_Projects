class read_drv extends uvm_driver#(read_tx);
virtual async_fifo_intf vif;
`uvm_component_utils(read_drv)
`NEW_COMP
uvm_analysis_port#(read_tx) ap_port;

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

task drive_tx(read_tx tx);
	 @(posedge vif.rd_clk_i);
	 vif.rd_en_i=1;
	 @(posedge vif.rd_clk_i);
	 tx.data=vif.rdata_o;
	 vif.rd_en_i=0;
	 repeat(tx.delay) @(posedge vif.rd_clk_i);	
endtask
endclass

