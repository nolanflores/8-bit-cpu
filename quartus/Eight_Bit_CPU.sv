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
logic [7:0] hexA_wire;
logic [7:0] hexB_wire;
logic [7:0] hexC_wire;

logic pc_enable;
logic ir_enable;
logic dr_enable;
logic sr_enable;
logic marH_enable;
logic marL_enable;
logic mdr_enable;
logic ac_enable;
logic A_enable;
logic B_enable;
logic C_enable;
logic hexA_enable;
logic hexB_enable;
logic hexC_enable;

logic ac_select;
logic sr_select;
logic wr_select;
logic mdr_select;
logic [1:0] mar_select;
logic [1:0] pc_select;
logic [3:0] alu_select;
logic [3:0] bus_select;

ControlUnit control_inst(
	.clock(clock), .reset_n(reset_n),
	
	.ir(ir_wire), .dr(dr_wire),
	
	.pc_enable(pc_enable), .ir_enable(ir_enable),
	.dr_enable(dr_enable), .sr_enable(sr_enable),
	.marH_enable(marH_enable), .marL_enable(marL_enable),
	.mdr_enable(mdr_enable), .ac_enable(ac_enable),
	.A_enable(A_enable), .B_enable(B_enable),
	.C_enable(C_enable), .hexA_enable(hexA_enable),
	.hexB_enable(hexB_enable), .hexC_enable(hexC_enable),

	.ac_select(ac_select), .sr_select(sr_select),
	.wr_select(wr_select), .mdr_select(mdr_select),
	.mar_select(mar_select),
	.pc_select(pc_select),
	.alu_select(alu_select),
	.bus_select(bus_select),
	
	.status_lights(lights)
);

Multiplexer #(
	.WIDTH(8),
	.SEL(4)
) Bus_Mux(
	.in({
		8'b0, 8'b0, 8'b0, sw0_wire, sw1_wire,
		pc_wire, ir_wire, dr_wire,
		sr_wire, marH_wire, marL_wire,
		mdr_wire, ac_wire, A_wire,
		B_wire, C_wire
	}),
	.select(bus_select),
	.out(bus_wire)
);

Program_Counter counter_inst(
	.clock(clock),
	.reset_n(reset_n),
	.bus_in(bus_wire),
	.pc_enable(pc_enable),
	.select(pc_select),
	.pc(pc_wire)
);

Fetch_Unit fetch_inst(
	.clock(clock),
	.reset_n(reset_n),
	.ir_enable(ir_enable),
	.dr_enable(dr_enable),
	.pc(pc_wire),
	.ir(ir_wire),
	.dr(dr_wire)
);

Execute_Unit execute_inst(
	.clock(clock),
	.reset_n(reset_n),
	.bus_in(bus_wire),
	.ac_select(ac_select),
	.sr_select(sr_select),
	.alu_select(alu_select),
	.sr_enable(sr_enable),
	.ac_enable(ac_enable),
	.ac(ac_wire),
	.sr(sr_wire)
);

Memory_Addresser addresser_inst(
	.clock(clock),
	.reset_n(reset_n),
	.bus_in(bus_wire),
	.marH_enable(marH_enable),
	.marL_enable(marL_enable),
	.select(mar_select),
	.marH(marH_wire),
	.marL(marL_wire)
);

Memory_Unit memory_inst(
	.clock(clock),
	.reset_n(reset_n),
	.bus_in(bus_wire),
	.marH(marH_wire),
	.marL(marL_wire),
	.mdr_enable(mdr_enable),
	.mdr_select(mdr_select),
	.wr_select(wr_select),
	.mdr(mdr_wire)
);

Register A_register(
	.clock(clock),
	.reset_n(reset_n),
	.enable(A_enable),
	.in(bus_wire),
	.out(A_wire)
);
Register B_register(
	.clock(clock),
	.reset_n(reset_n),
	.enable(B_enable),
	.in(bus_wire),
	.out(B_wire)
);
Register C_register(
	.clock(clock),
	.reset_n(reset_n),
	.enable(C_enable),
	.in(bus_wire),
	.out(C_wire)
);

Register hexA_register(
	.clock(clock),
	.reset_n(reset_n),
	.enable(hexA_enable),
	.in(bus_wire),
	.out(hexA_wire)
);
Register hexB_register(
	.clock(clock),
	.reset_n(reset_n),
	.enable(hexB_enable),
	.in(bus_wire),
	.out(hexB_wire)
);
Register hexC_register(
	.clock(clock),
	.reset_n(reset_n),
	.enable(hexC_enable),
	.in(bus_wire),
	.out(hexC_wire)
);

Synchronizer sw0_sync(
	.async_in(switches[7:0]),
	.clock(clock),
	.sync_out(sw0_wire)
);
Synchronizer sw1_sync(
	.async_in({4'b0, buttons, switches[9:8]}),
	.clock(clock),
	.sync_out(sw1_wire)
);

Hex_Displays displays_inst(
	.hex_flag(sr_wire[4]),
	.pc(pc_wire),
	.ir(ir_wire),
	.dr(dr_wire),
	.hexA(hexA_wire),
	.hexB(hexB_wire),
	.hexC(hexC_wire),
	.displays(displays)
);

endmodule