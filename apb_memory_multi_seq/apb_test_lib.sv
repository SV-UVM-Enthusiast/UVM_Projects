//base test : has things common to every testcase
//functional test : has things specific to the test
//functional test : extended from base test 
class apb_base_test extends uvm_test;
apb_env env;

`uvm_component_utils(apb_base_test)

function new(string name,uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	env = apb_env::type_id::create("env",this);
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction
endclass


class apb_wr_rd_test extends apb_base_test;

`uvm_component_utils(apb_wr_rd_test)

function new(string name,uvm_component parent);
	super.new(name,parent);
endfunction

task run_phase(uvm_phase phase);
	apb_wr_rd_seq seq;
	seq = apb_wr_rd_seq::type_id::create("seq");
	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this, 100);
	seq.start(env.agent.sqr);
	phase.drop_objection(this);
endtask

endclass

class apb_n_wr_n_rd_test extends apb_base_test;

`uvm_component_utils(apb_n_wr_n_rd_test)

function new(string name,uvm_component parent);
	super.new(name,parent);
endfunction

task run_phase(uvm_phase phase);
	apb_n_wr_n_rd_seq seq;
	uvm_resource_db#(int)::set("GLOBAL","COUNT",3,this);
	seq = apb_n_wr_n_rd_seq::type_id::create("seq");
	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this, 100);
	seq.start(env.agent.sqr);
	phase.drop_objection(this);
endtask

endclass

 //there is a two ways to develope a test 
 // one : map sequence with the sequencer in the build phase
class apb_n_wr_rd_build_test extends apb_base_test;
`uvm_component_utils(apb_n_wr_rd_build_test)
`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_resource_db#(int)::set("GLOBAL","COUNT",10,this);//setting the count
	uvm_config_db#(uvm_object_wrapper)::set(this, "env.agent.sqr.run_phase","default_sequence", apb_n_wr_rd_seq::get_type());
endfunction
endclass


// two : map sequence with the sequencer in the run phase
class apb_n_wr_rd_run_test extends apb_base_test;
`uvm_component_utils(apb_n_wr_rd_run_test)
`NEW_COMP

task run_phase(uvm_phase phase);
	apb_n_wr_rd_seq seq;      
	uvm_resource_db#(int)::set("GLOBAL","COUNT",10,this);
	seq = apb_n_wr_rd_seq::type_id::create("seq");
	phase.raise_objection(this);
	phase.phase_done.set_drain_time(this, 100);
	seq.start(env.agent.sqr);
	phase.drop_objection(this);
endtask
endclass

/* we can replace whole task run_phase with this

function void build_phase(uvm_phase phase);
 uvm_config_db#(uvm_object_wrapper)::set(this, "env.agent.sqr.run_phase","default_sequence", apb_n_wr_rd_seq::get_type());
endfunction*/


class apb_multi_seq_test extends apb_base_test;
`uvm_component_utils(apb_multi_seq_test)
`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_resource_db#(int)::set("GLOBAL","COUNT",10,this);//setting the count
	uvm_config_db#(uvm_object_wrapper)::set(this, "env.agent.sqr.run_phase","default_sequence", apb_multi_seq::get_type());
endfunction
endclass

class apb_multi_seq_test1 extends apb_base_test;
`uvm_component_utils(apb_multi_seq_test1)
`NEW_COMP
 
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_resource_db#(int)::set("GLOBAL","COUNT",10,this);//setting the count
endfunction

task run_phase(uvm_phase phase);
	apb_multi_seq seq;
	seq = apb_multi_seq::type_id::create("seq");
	phase.raise_objection(this);
	seq.start(env.agent.sqr);
	phase.drop_objection(this);
endtask
endclass
