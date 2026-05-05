module Eight_Bit_CPU(
	input logic clk,
	input logic mode,
	input logic [9:0] switches,
	input logic [1:0] buttons,
	output logic [5:0][6:0] displays,
	output logic [9:0] lights
);

logic clock;
logic reset_n;

Multiplexer #(
	.WIDTH(2),
	.SEL(1)
) Mode_Mux(
	.in({clk, 1'b1, buttons[0], buttons[1]}),
	.select(mode),
	.out({clock, reset_n})
);

logic [7:0] bus_wire;
logic [7:0] pc_wire;
logic [7:0] ir_wire;
logic [7:0] dr_wire;
logic [7:0] marH_wire;
logic [7:0] marL_wire;
logic [7:0] mdr_wire;
logic [7:0] ac_wire;
logic [7:0] a_wire;
logic [7:0] b_wire;
logic [7:0] c_wire;

Program_Counter(
	.clock(clock),
	.reset_n(reset_n),
	.bus_in(8'h00),
	.pc_enable(switches[0]),
	.select(2'd2),
	.pc(pc_wire)
);

Fetch_Unit(
	.clock(clock),
	.reset_n(reset_n),
	.ir_enable(1'b1),
	.dr_enable(1'b1),
	.pc(pc_wire),
	.ir(ir_wire),
	.dr(dr_wire)
);

Hex_Displays(
	.hex_flag(switches[1]),
	.pc(pc_wire),
	.ir(ir_wire),
	.dr(dr_wire),
	.hexA(8'hAA),
	.hexB(8'hBB),
	.hexC(8'hCC),
	.displays(displays)
);

endmodule