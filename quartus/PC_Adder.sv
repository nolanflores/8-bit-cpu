module PC_Adder(
	input logic [7:0] in,
	input logic [1:0] delta,
	output logic [7:0] out
);

always_comb begin
	out = in + delta - 1;
end

endmodule