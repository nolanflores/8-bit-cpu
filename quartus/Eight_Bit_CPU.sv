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
logic [7:0] sr_wire;
logic [7:0] marH_wire;
logic [7:0] marL_wire;
logic [7:0] mdr_wire;
logic [7:0] ac_wire;
logic [7:0] A_wire;
logic [7:0] B_wire;
logic [7:0] C_wire;
logic [7:0] sw0_wire;
logic [7:0] sw1_wire;

logic pc_enable;
logic ir_enable;
logic dr_enable;
logic sr_enable;
logic wr_enable;
logic marH_enable;
logic marL_enable;
logic mdr_enable;
logic ac_enable;
logic A_enable;
logic B_enable;
logic C_enable;
logic sw0_enable;
logic sw1_enable;

logic ac_select;
logic sr_select;
logic mdr_select;
logic [1:0] mar_select;
logic [1:0] pc_select;
logic [3:0] alu_select;

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

Memory_Addresser(
	.clock(clock),
	.reset_n(reset_n),
	.bus_in(bus_wire),
	.marH_enable(marH_enable),
	.marL_enable(marL_enable),
	.select(2'b01),
	.marH(marH_wire),
	.marL(marL_wire)
);

Memory_Unit(
	.clock(clock),
	.reset_n(reset_n),
	.bus_in(bus_wire),
	.marH(marH_wire),
	.marL(marL_wire),
	.wr_enable(wr_enable),
	.mdr_enable(mdr_enable),
	.mdr_select(mdr_select),
	.mdr(mdr_wire)
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