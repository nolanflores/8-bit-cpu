module cpu(
	input logic clock,
	input logic reset,
	input logic [7:0] instruction,
	
	output logic instruction_reg_en,
	output logic address_reg_en,
	output logic pc_en,
	output logic ac_en
);

endmodule