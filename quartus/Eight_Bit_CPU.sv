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
logic [7:0] bus;

Multiplexer #(
	.WIDTH(2),
	.SEL(1)
) Mode_Mux(
	.in({clk, 1'b1, buttons[0], buttons[1]}),
	.select(mode),
	.out({clock, reset_n})
);

logic [2:0][7:0] r_to_segs;

/* ================================================
 * Segment 0 And Segment 1
 * ================================================
*/

Register r_seg01(
	.clock(clock),
	.enable(1'b0),//add enable line
	.reset_n(reset_n),
	.in(bus),
	.out(r_to_segs[0])
);

Seven_Segment_Display seg0(
	.in(r_to_segs[0][3:0]),
	.out(displays[0])
);

Seven_Segment_Display seg1(
	.in(r_to_segs[0][7:4]),
	.out(displays[1])
);

/* ================================================
 * Segment 2 And Segment 3
 * ================================================
*/

Register r_seg23(
	.clock(clock),
	.enable(1'b0),//add enable line
	.reset_n(reset_n),
	.in(bus),
	.out(r_to_segs[1])
);

Seven_Segment_Display seg2(
	.in(r_to_segs[1][3:0]),
	.out(displays[2])
);

Seven_Segment_Display seg3(
	.in(r_to_segs[1][7:4]),
	.out(displays[3])
);

/* ================================================
 * Segment 4 And Segment 5
 * ================================================
*/

Register r_seg45(
	.clock(clock),
	.enable(1'b0),//add enable line
	.reset_n(reset_n),
	.in(bus),
	.out(r_to_segs[2])
);

Seven_Segment_Display seg4(
	.in(r_to_segs[2][3:0]),
	.out(displays[4])
);

Seven_Segment_Display seg5(
	.in(r_to_segs[2][7:4]),
	.out(displays[5])
);

endmodule