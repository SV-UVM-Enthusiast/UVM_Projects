class apb_agent extends uvm_agent;
apb_drv drv;
apb_sqr sqr;
apb_mon mon;
apb_cov cov;

`uvm_component_utils(apb_agent)

function new(string name,uvm_component parent);
   super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	$display("apb_agent::build_phase");
	drv = apb_drv::type_id::create("drv",this);
	sqr = apb_sqr::type_id::create("sqr",this);
	mon = apb_mon::type_id::create("mon",this);
	cov = apb_cov::type_id::create("cov",this);
endfunction

function void connect_phase(uvm_phase phase);
	$display("apb_agent::connect_phase");
	drv.seq_item_port.connect(sqr.seq_item_export);
	mon.ap_port.connect(cov.analysis_export);
endfunction
endclass
