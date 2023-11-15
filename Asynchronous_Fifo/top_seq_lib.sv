class top_base_seq extends uvm_sequence;
uvm_phase phase;
`uvm_object_utils(top_base_seq)
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

class wr_rd_top_seq extends top_base_seq;
write_seq write_seq_i;
read_seq read_seq_i;
`uvm_object_utils(wr_rd_top_seq)
`uvm_declare_p_sequencer(top_sqr)
`NEW_OBJ	

task body();
	`uvm_do_on(write_seq_i, p_sequencer.write_sqr_i)
	`uvm_do_on(read_seq_i, p_sequencer.read_sqr_i)
endtask
endclass

class concurrent_wr_rd_top_seq extends top_base_seq;
write_seq write_seq_i;
read_seq read_seq_i;
`uvm_object_utils(concurrent_wr_rd_top_seq)
`uvm_declare_p_sequencer(top_sqr)
`NEW_OBJ	

task body();
fork
	`uvm_do_on(write_seq_i, p_sequencer.write_sqr_i)
	`uvm_do_on(read_seq_i, p_sequencer.read_sqr_i)
join
endtask
endclass
