class write_tx extends uvm_sequence_item;
rand bit [`WIDTH-1:0]data;
rand bit [32:0]delay;
`uvm_object_utils_begin(write_tx)
	`uvm_field_int(data,UVM_ALL_ON)
	`uvm_field_int(delay,UVM_ALL_ON)
`uvm_object_utils_end
`NEW_OBJ

constraint soft_del{
	soft delay == 0;
}
endclass
