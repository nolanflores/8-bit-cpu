module Multiplexer #(
	parameter WIDTH = 8,
	parameter SEL = 2
)(
	input logic [2**SEL-1:0][WIDTH-1:0] in,
	input logic [SEL-1:0] select,
	output logic [WIDTH-1:0] out
);

assign out = in[select];

endmodule