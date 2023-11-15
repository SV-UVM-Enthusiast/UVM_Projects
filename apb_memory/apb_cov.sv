class apb_cov extends uvm_subscriber#(apb_tx);
apb_tx tx;
`uvm_component_utils(apb_cov)

covergroup apb_cg;  
	coverpoint tx.addr{
    	option.auto_bin_max=8;
 	}
endgroup

function new(string name="",uvm_component parent=null);
	super.new(name,parent);
	apb_cg = new();
endfunction

function void write(T t);
	$cast(tx,t);
	apb_cg.sample();
endfunction
endclass
