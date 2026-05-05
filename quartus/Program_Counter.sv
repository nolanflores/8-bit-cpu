module Program_Counter(
	input logic clock,
	input logic reset_n,
	input logic [7:0] bus_in,
	input logic pc_enable,
	input logic [1:0] select,
	output logic [7:0] pc
);

logic [7:0] pc_next;

Register pc_reg(
	.clock(clock),
	.enable(pc_enable),
	.reset_n(reset_n),
	.in(pc_next),
	.out(pc)
);

always_comb begin
	if(select == 2'b01) begin
		pc_next = bus_in;
	end else begin
		pc_next = pc + select - 1;
	end
end

endmodule