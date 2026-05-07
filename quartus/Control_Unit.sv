module ControlUnit(
	input logic clock, input logic reset_n,
	
	input logic [7:0] ir, input logic [7:0] dr,
	
	output logic pc_enable, output logic ir_enable,
	output logic dr_enable, output logic sr_enable,
	output logic marH_enable, output logic marL_enable,
	output logic mdr_enable, output logic ac_enable,
	output logic A_enable, output logic B_enable,
	output logic C_enable, output logic hexA_enable,
	output logic hexB_enable, output logic hexC_enable,

	output logic ac_select, output logic sr_select,
	output logic wr_select, output logic mdr_select,
	output logic [1:0] mar_select,
	output logic [1:0] pc_select,
	output logic [3:0] alu_select,
	output logic [3:0] bus_select,
	
	output logic [9:0] status_lights
);

endmodule