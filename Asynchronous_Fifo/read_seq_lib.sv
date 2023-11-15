class read_base_seq extends uvm_sequence#(read_tx);
uvm_phase phase;
`uvm_object_utils(read_base_seq)
`NEW_OBJ

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

class read_seq extends read_base_seq;
int tx_num;
`uvm_object_utils(read_seq)
`NEW_OBJ		

task body();
	uvm_resource_db#(int)::read_by_name("GLOBAL","READ_COUNT",tx_num,this);
	repeat(tx_num)begin
		`uvm_do(req)
	end
endtask
endclass

class read_delay_seq extends read_base_seq;
int tx_num;
int read_delay;
`uvm_object_utils(read_delay_seq)
`NEW_OBJ		

task body();
	uvm_resource_db#(int)::read_by_name("GLOBAL","READ_COUNT",tx_num,this);
	repeat(tx_num)begin
		read_delay = $urandom_range(1,`MAX_RD_DELAY);
		`uvm_do_with(req, {req.delay == read_delay;})
	end
endtask
endclass
