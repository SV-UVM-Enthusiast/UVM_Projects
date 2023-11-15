class write_mon extends uvm_monitor;
`uvm_component_utils(write_mon)
`NEW_COMP
virtual async_fifo_intf vif;
uvm_analysis_port#(write_tx) ap_port;
write_tx tx;

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_resource_db#(virtual async_fifo_intf)::read_by_name("GLOBAL","PIF",vif,this))
	begin
	`uvm_error("INTF", "not able to get intf from resource db")
	end
	ap_port=new("ap_port",this);
endfunction

task run_phase(uvm_phase phase);
	forever begin
		@(posedge vif.wr_clk_i);
		if(vif.write_mon_cb.wr_en_i==1) begin
			tx=write_tx::type_id::create("tx");
			tx.data = vif.write_mon_cb.wdata_i;
			ap_port.write(tx);
		end
	end
endtask
endclass
