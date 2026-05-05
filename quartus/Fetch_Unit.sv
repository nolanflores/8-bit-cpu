module Fetch_Unit(
	input logic clock,
	input logic reset_n,
	input logic ir_enable,
	input logic dr_enable,
	input logic [7:0] pc,
	output logic [7:0] ir,
	output logic [7:0] dr
);

logic [15:0] program_wire;

Program_Memory(
    .address(pc),
    .clock(clock),
    .out(program_wire)
);

Register instruction_register(
	.clock(clock),
	.enable(ir_enable),
	.reset_n(reset_n),
	.in(program_wire[15:8]),
	.out(ir)
);

Register data_register(
	.clock(clock),
	.enable(dr_enable),
	.reset_n(reset_n),
	.in(program_wire[7:0]),
	.out(dr)
);

endmodule