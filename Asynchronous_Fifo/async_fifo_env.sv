class async_fifo_env extends uvm_env;
write_agent write_agent_i;
read_agent read_agent_i;
fifo_sbd sbd;
top_sqr top_sqr_i;
`uvm_component_utils(async_fifo_env)
`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	write_agent_i=write_agent::type_id::create("write_agent_i",this);
	read_agent_i=read_agent::type_id::create("read_agent_i",this);
	sbd = fifo_sbd::type_id::create("sbd",this);
	top_sqr_i = top_sqr::type_id::create("top_sqr_i",this);
endfunction

function void connect_phase(uvm_phase phase);
	write_agent_i.mon.ap_port.connect(sbd.imp_write);
	read_agent_i.mon.ap_port.connect(sbd.imp_read);
	top_sqr_i.write_sqr_i = write_agent_i.sqr;
	top_sqr_i.read_sqr_i = read_agent_i.sqr;
endfunction

endclass
