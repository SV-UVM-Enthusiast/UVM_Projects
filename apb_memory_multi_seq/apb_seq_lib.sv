//base sequence : do common things for all the sequence 
class apb_base_seq extends uvm_sequence#(apb_tx);
uvm_phase phase;
`uvm_object_utils(apb_base_seq)

function new(string name="");
	super.new(name);
endfunction

task pre_body();
	phase = get_starting_phase();
	if(phase != null)begin
		phase.raise_objection(this);
		phase.phase_done.set_drain_time(this,100);
	end
endtask

task post_body();
	if(phase != null)begin
		phase.drop_objection(this);
	end
endtask

endclass

//functional sequence
class apb_wr_rd_seq extends apb_base_seq;
apb_tx tx;
`uvm_object_utils(apb_wr_rd_seq)

function new(string name="");
	super.new(name);
endfunction

task body();
	`uvm_do_with(req, {req.wr_rd==1;})
	tx = new req;
	`uvm_do_with(req, {req.wr_rd==0; req.addr==tx.addr;})
	//allow constraints to be applied to the randomization (uvm_do_with)
endtask
endclass

class apb_n_wr_n_rd_seq extends apb_base_seq;
apb_tx txQ[$], tx;
int tx_num;
`uvm_object_utils(apb_n_wr_n_rd_seq)

function new(string name="");
	super.new(name);
endfunction

task body();
	uvm_resource_db#(int)::read_by_type("GLOBAL",tx_num,this);
	repeat(tx_num)begin
		`uvm_do_with(req, {req.wr_rd==1;})
		tx = new req;
		txQ.push_back(tx);
	end	
	repeat(tx_num)begin
		tx = txQ.pop_front();	
		`uvm_do_with(req, {req.wr_rd==0; req.addr==tx.addr;})
	end
endtask

endclass

// n-times wr-rd{wr-rd} 
// we can create this sequence using the existing apb_wr_rd_seq sequence
class apb_n_wr_rd_seq extends apb_base_seq;
int tx_num;
apb_wr_rd_seq seq;
function new(string name="");
	super.new(name);
endfunction
`uvm_object_utils(apb_n_wr_rd_seq)
task body();
	uvm_resource_db#(int)::read_by_name("GLOBAL","COUNT",tx_num,this);
	repeat(tx_num) `uvm_do(seq)
endtask
endclass


//we are creation bigger seq using existing seq also called as "sequence layering"
class apb_multi_seq extends apb_base_seq;
apb_wr_rd_seq seq1;
apb_n_wr_n_rd_seq seq2;

function new(string name="");
	super.new(name);
endfunction

`uvm_object_utils(apb_multi_seq)

task body();
	`uvm_do(seq1)
	`uvm_do(seq2)
endtask
 
endclass
