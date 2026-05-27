module Program_Counter(
	input logic clock,
	input logic reset_n,
	input logic [7:0] bus_in,
	input logic pc_enable,
	input logic [1:0] select,
	output logic [7:0] pc
);

logic [7:0] pc_next;

Register pc_register(
	.clock(clock),
	.enable(pc_enable),
	.reset_n(reset_n),
	.in(pc_next),
	.out(pc)
);

always_comb begin
	if(select[1]) begin
		pc_next = bus_in;
	end else begin
		pc_next = pc + 1'b1 + select[0];
	end
end

endmodule