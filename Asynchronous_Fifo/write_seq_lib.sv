class write_base_seq extends uvm_sequence#(write_tx);
uvm_phase phase;
`uvm_object_utils(write_base_seq)
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

class write_seq extends write_base_seq;
int tx_num;
`uvm_object_utils(write_seq)
`NEW_OBJ	

task body();
	uvm_resource_db#(int)::read_by_name("GLOBAL","WRITE_COUNT",tx_num,this);
	repeat(tx_num)begin
		`uvm_do(req)
	end
endtask
endclass

class write_delay_seq extends write_base_seq;
int tx_num;
int write_delay;
`uvm_object_utils(write_delay_seq)
`NEW_OBJ	

task body();
	uvm_resource_db#(int)::read_by_name("GLOBAL","WRITE_COUNT",tx_num,this);
	repeat(tx_num)begin
		write_delay = $urandom_range(1,`MAX_WR_DELAY);
		`uvm_do_with (req, {req.delay == write_delay;})
	end
endtask
endclass
