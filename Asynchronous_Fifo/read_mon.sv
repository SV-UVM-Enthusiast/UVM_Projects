class read_mon extends uvm_monitor;
`uvm_component_utils(read_mon)
`NEW_COMP
virtual async_fifo_intf vif;
uvm_analysis_port#(read_tx) ap_port;
read_tx tx;

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_resource_db#(virtual async_fifo_intf)::read_by_name("GLOBAL","PIF",vif,this))
	begin
		`uvm_error("INTF","Not able to get intf from resource db");
	end
	ap_port=new("ap_port",this);
endfunction

task run_phase(uvm_phase phase);
read_tx tx;
forever begin
	@(vif.read_mon_cb);
	if(vif.read_mon_cb.rd_en_i==1)begin
		tx=read_tx::type_id::create("tx");
		fork
			begin
				@(vif.read_mon_cb);
				tx.data = vif.read_mon_cb.rdata_o;
				ap_port.write(tx);
			end
		join
	end
end
endtask
endclass
