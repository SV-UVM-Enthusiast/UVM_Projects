class apb_drv extends uvm_driver#(apb_tx);
`uvm_component_utils(apb_drv);
virtual apb_intf vif;

function new(string name, uvm_component parent);
	super.new(name,parent);
endfunction
  
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	$display("apb_drv::build_phase");
	uvm_resource_db#(virtual apb_intf)::read_by_name("GLOBAL","VIF",vif,this);
endfunction
  
task run_phase(uvm_phase phase);
forever begin
     seq_item_port.get_next_item(req);
	 req.print();
	 drive_tx(req);
	 seq_item_port.item_done();
end
endtask
task drive_tx(apb_tx tx);
	@(vif.bfm_cb);
	vif.bfm_cb.addr_i<=tx.addr;
	if(tx.wr_rd==1)vif.bfm_cb.wdata_i<=tx.data;
	vif.bfm_cb.wr_rd_i<=tx.wr_rd;
	vif.bfm_cb.valid_i<=1;
	wait(vif.bfm_cb.ready_o==1);
    vif.bfm_cb.addr_i<=0;
	vif.bfm_cb.wdata_i<=0;
	vif.bfm_cb.wr_rd_i<=0;
	vif.bfm_cb.valid_i<=0;
    @(vif.bfm_cb);
endtask
endclass
