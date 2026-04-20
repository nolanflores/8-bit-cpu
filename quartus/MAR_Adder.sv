module MAR_Adder(
	input logic [7:0] low,
	input logic [7:0] high,
	input logic [1:0] s,
	output logic [7:0] q_low,
	output logic [7:0] q_high
);

logic [15:0] word;

always_comb begin
	word <= {high, low} + s - 1;
	
	q_high <= word[15:8];
	q_low <= word[7:0];
end

endmodule