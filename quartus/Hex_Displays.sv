module Hex_Displays(
	input logic hex_flag,
	input logic [7:0] pc,
	input logic [7:0] ir,
	input logic [7:0] dr,
	input logic [7:0] hexA,
	input logic [7:0] hexB,
	input logic [7:0] hexC,
	output logic [5:0][6:0] displays
);

logic [5:0][3:0] inputs;

Multiplexer #(
	.WIDTH(24),
	.SEL(1)
) Displays_Mux(
	.in({pc, ir, dr, hexA, hexB, hexC}),
	.select(hex_flag),
	.out(inputs)
);


Seven_Segment_Display seg0(
	.in(inputs[0]),
	.out(displays[0])
);
Seven_Segment_Display seg1(
	.in(inputs[1]),
	.out(displays[1])
);
Seven_Segment_Display seg2(
	.in(inputs[2]),
	.out(displays[2])
);
Seven_Segment_Display seg3(
	.in(inputs[3]),
	.out(displays[3])
);
Seven_Segment_Display seg4(
	.in(inputs[4]),
	.out(displays[4])
);
Seven_Segment_Display seg5(
	.in(inputs[5]),
	.out(displays[5])
);

endmodule