class apb_mon extends uvm_monitor;
	apb_tx tx;
	virtual apb_intf vif; 
	uvm_analysis_port#(apb_tx) ap_port;

	`uvm_component_utils(apb_mon)

	`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	ap_port = new("ap_port",this);
	uvm_resource_db#(virtual apb_intf)::read_by_name("GLOBAL","VIF",vif,this);
endfunction

task run_phase(uvm_phase phase);

	forever begin
		@(vif.mon_cb);
		if(vif.mon_cb.valid_i==1 && vif.mon_cb.ready_o==1)begin
			tx=new();
			tx.addr = vif.mon_cb.addr_i;
			tx.data = vif.mon_cb.wr_rd_i ? vif.mon_cb.wdata_i : vif.mon_cb.rdata_o;
			tx.wr_rd = vif.mon_cb.wr_rd_i;
			ap_port.write(tx);
		end
	end
endtask
endclass
