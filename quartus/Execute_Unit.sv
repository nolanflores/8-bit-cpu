module Execute_Unit(
	input logic clock,
	input logic reset_n,
	input logic [7:0] bus_in,
	input logic ac_select,
	input logic sr_select,
	input logic [3:0] alu_select,
	input logic sr_enable,
	input logic ac_enable,
	output logic [7:0] ac,
	output logic [7:0] sr
);

logic [7:0] ac_alu;
logic [3:0] sr_alu;

Arithmetic_Logic_Unit alu(
	.a(ac),
	.b(bus_in),
	.select(alu_select),
	.c_in(sr[0]),
	.q(ac_alu),
	.c_out(sr_alu[0]),
	.z_out(sr_alu[1]),
	.v_out(sr_alu[2]),
	.s_out(sr_alu[3])
);

logic [7:0] ac_next;
logic [4:0] sr_next;

Multiplexer #(
	.WIDTH(8),
	.SEL(1)
) ac_Mux(
	.in({bus_in, ac_alu}),
	.select(ac_select),
	.out(ac_next)
);

Register ac_register(
	.clock(clock),
	.enable(ac_enable),
	.reset_n(reset_n),
	.in(ac_next),
	.out(ac)
);

Multiplexer #(
	.WIDTH(5),
	.SEL(1)
) sr_Mux(
	.in({bus_in[4:0], sr[4], sr_alu}),
	.select(sr_select),
	.out(sr_next)
);

Register status_register(
	.clock(clock),
	.enable(sr_enable),
	.reset_n(reset_n),
	.in({3'b000, sr_next}),
	.out(sr)
);

endmodule