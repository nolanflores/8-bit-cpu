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

logic [15:0] mar_next;
logic mux_select;

always_comb begin
	mar_next = {marH, marL} + select - 1;
	mux_select = (select == 2'h3);
end

logic [7:0] marH_next;
logic [7:0] marL_next;

Multiplexer #(
	.WIDTH(8),
	.SEL(1)
) marH_Mux(
	.in({bus_in, mar_next[15:8]}),
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
	.in({2'b00, marH_next[5:0]}),
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