module Execute_Unit(
	input logic clock,
	input logic reset_n,
	input logic [7:0] bus_in,
	input logic ac_select,
	input logic sr_select,
	input logic [3:0] alu_select,
	input logic sr_enable,
	input logic ac_enable,
	output logic ac,
	output logic sr
);

logic [7:0] ac_next;
logic [7:0] sr_next;

logic [7:0] alu_wire;

logic [3:0] status_wire;

Arithmetic_Logic_Unit(
	.a(ac),
	.b(bus_in),
	.select(alu_select),
	.c_in(sr[0]),
	.q(alu_wire),
	.c_out(status_wire[0]),
	.z_out(status_wire[1]),
	.v_out(status_wire[2]),
	.s_out(status_wire[3])
);

Multiplexer #(
	.WIDTH(8),
	.SEL(1)
) Displays_Mux(
	.in({bus_in, 1'b1, 3'b000, status_wire}),
	.select(sr_select),
	.out(sr_next)
);

Register status_register(
	.clock(clock),
	.enable(sr_enable),
	.reset_n(reset_n),
	.in(sr_next),
	.out(sr)
);

endmodule