module Memory_Unit(
	input logic clock,
	input logic reset_n,
	input logic [7:0] bus_in,
	input logic [7:0] marH,
	input logic [7:0] marL,
	input logic wr_select,
	input logic mdr_enable,
	input logic mdr_select,
	output logic [7:0] mdr
);

logic [7:0] mdr_next;
logic [7:0] data;

Multiplexer #(
	.WIDTH(8),
	.SEL(1)
) marH_Mux(
	.in({bus_in, data}),
	.select(mdr_select),
	.out(mdr_next)
);

Register mdr_register(
	.clock(clock),
	.enable(mdr_enable),
	.reset_n(reset_n),
	.in(mdr_next),  
	.out(mdr)
);

Data_Memory data_inst(
	.address({marH[5:0], marL}),
	.data(mdr),
	.wr_en(wr_select),
	.clock(clock),
	.out(data)
);

endmodule