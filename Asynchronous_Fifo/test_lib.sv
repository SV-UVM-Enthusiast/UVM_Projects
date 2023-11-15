class async_fifo_base_test extends uvm_test;
async_fifo_env env;
`uvm_component_utils(async_fifo_base_test)
`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	env=async_fifo_env::type_id::create("env",this);
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction

function void report_phase(uvm_phase phase);
	if(async_fifo_common::num_mismatches>0 || async_fifo_common::num_matches == 0)begin
		`uvm_error("STATUS", $psprintf("TEST FAIL, num_matches=%0d, num_mismatches=%0d",async_fifo_common::num_matches,async_fifo_common::num_mismatches))
	end
	else begin
		`uvm_info("STATUS", "TEST PASS", UVM_NONE)
		`uvm_info("STATUS", $psprintf("TEST PASS, num_matches=%0d, num_mismatches=%0d",async_fifo_common::num_matches,async_fifo_common::num_mismatches), UVM_NONE)

	end
endfunction

endclass

class fifo_wr_rd_test extends async_fifo_base_test;
`uvm_component_utils(fifo_wr_rd_test)
`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_resource_db#(int)::set("GLOBAL","WRITE_COUNT",`DEPTH,this);
	uvm_resource_db#(int)::set("GLOBAL","READ_COUNT",`DEPTH,this);
endfunction

task run_phase(uvm_phase phase);
	write_seq write_seq_i;
	read_seq read_seq_i;
	write_seq_i=write_seq::type_id::create("write_seq_i");
	read_seq_i=read_seq::type_id::create("read_seq_i");

	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this,50);
	write_seq_i.start(env.write_agent_i.sqr);
	read_seq_i.start(env.read_agent_i.sqr);
	phase.drop_objection(this);
endtask
endclass

class fifo_full_error_test extends async_fifo_base_test;
`uvm_component_utils(fifo_full_error_test)
`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_resource_db#(int)::set("GLOBAL","WRITE_COUNT",`DEPTH+1,this);
	uvm_resource_db#(int)::set("GLOBAL","READ_COUNT",0,this);
endfunction

task run_phase(uvm_phase phase);
	write_seq write_seq_i;
	read_seq read_seq_i;
	write_seq_i=write_seq::type_id::create("write_seq_i");
	read_seq_i=read_seq::type_id::create("read_seq_i");

	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this,50);
	write_seq_i.start(env.write_agent_i.sqr);
	read_seq_i.start(env.read_agent_i.sqr);
	phase.drop_objection(this);
endtask
endclass

class fifo_empty_error_test extends async_fifo_base_test;
`uvm_component_utils(fifo_empty_error_test)
`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_resource_db#(int)::set("GLOBAL","WRITE_COUNT",`DEPTH,this);
	uvm_resource_db#(int)::set("GLOBAL","READ_COUNT",`DEPTH+1,this);
endfunction

task run_phase(uvm_phase phase);
	write_seq write_seq_i;
	read_seq read_seq_i;
	write_seq_i=write_seq::type_id::create("write_seq_i");
	read_seq_i=read_seq::type_id::create("read_seq_i");

	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this,50);
	write_seq_i.start(env.write_agent_i.sqr);
	read_seq_i.start(env.read_agent_i.sqr);
	phase.drop_objection(this);
endtask


endclass

class concurrent_wr_rd_test extends async_fifo_base_test;
`uvm_component_utils(concurrent_wr_rd_test)
`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_resource_db#(int)::set("GLOBAL","WRITE_COUNT",100,this);
	uvm_resource_db#(int)::set("GLOBAL","READ_COUNT",100,this);
endfunction

task run_phase(uvm_phase phase);
	write_delay_seq write_seq_i;
	read_delay_seq read_seq_i;

	write_seq_i=write_delay_seq::type_id::create("write_seq_i");
	read_seq_i=read_delay_seq::type_id::create("read_seq_i");

	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this,100);
	fork
		write_seq_i.start(env.write_agent_i.sqr);
		read_seq_i.start(env.read_agent_i.sqr);
	join
	phase.drop_objection(this);
endtask
endclass

class fifo_wr_rd_top_sqr_test extends async_fifo_base_test;
`uvm_component_utils(fifo_wr_rd_top_sqr_test)
`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_resource_db#(int)::set("GLOBAL","WRITE_COUNT",`DEPTH,this);
	uvm_resource_db#(int)::set("GLOBAL","READ_COUNT",`DEPTH,this);
endfunction

task run_phase(uvm_phase phase);
	wr_rd_top_seq top_seq;
	top_seq=wr_rd_top_seq::type_id::create("top_seq");

	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this,50);
	top_seq.start(env.top_sqr_i);
	phase.drop_objection(this);
endtask
endclass

class concurrent_wr_rd_top_sqr_test extends async_fifo_base_test;
`uvm_component_utils(concurrent_wr_rd_top_sqr_test)
`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_resource_db#(int)::set("GLOBAL","WRITE_COUNT",`DEPTH,this);
	uvm_resource_db#(int)::set("GLOBAL","READ_COUNT",`DEPTH,this);
endfunction

task run_phase(uvm_phase phase);
	concurrent_wr_rd_top_seq top_seq;
	top_seq=concurrent_wr_rd_top_seq::type_id::create("top_seq");

	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this,50);
	top_seq.start(env.top_sqr_i);
	phase.drop_objection(this);
endtask
endclass

