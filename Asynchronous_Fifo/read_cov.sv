class read_cov extends uvm_subscriber#(read_tx);
`uvm_component_utils(read_cov)
read_tx tx;

covergroup read_cg;
	RD_DELAY_CP : coverpoint tx.delay {
		bins ZERO = {0};
		bins LOWER = {[1:3]};
		bins MEDIUM = {[4:6]};
		bins HIGHER = {[7:`MAX_RD_DELAY]};
	}
endgroup

function new(string name,uvm_component parent);
	super.new(name,parent);
	read_cg=new();
endfunction

function void write(read_tx t);
	$cast(tx,t);
	read_cg.sample();
endfunction
endclass
