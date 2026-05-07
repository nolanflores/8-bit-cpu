module Memory_Addresser(
	input logic clock,
	input logic reset_n,
	input logic [7:0] bus_in,
	input logic marH_enable,
	input logic marL_enable,
	input logic [1:0] select,
	output logic [7:0] marH,
	output logic [7:0] marL
);

logic [13:0] mar_next;
logic mux_select;

always_comb begin
	mar_next = {marH[5:0], marL} + select - 14'b1;
	mux_select = (select == 2'h3);
end

logic [5:0] marH_next;
logic [7:0] marL_next;

Multiplexer #(
	.WIDTH(6),
	.SEL(1)
) marH_Mux(
	.in({bus_in[5:0], mar_next[13:8]}),
	.select(mux_select),
	.out(marH_next)
);

Multiplexer #(
	.WIDTH(8),
	.SEL(1)
) marL_Mux(
	.in({bus_in, mar_next[7:0]}),
	.select(mux_select),
	.out(marL_next)
);

Register marH_register(
	.clock(clock),
	.enable(marH_enable),
	.reset_n(reset_n),
	.in({2'b00, marH_next}),
	.out(marH)
);

Register marL_register(
	.clock(clock),
	.enable(marL_enable),
	.reset_n(reset_n),
	.in(marL_next),
	.out(marL)
);

endmodule