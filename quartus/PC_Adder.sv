module PC_Adder(
	input logic [7:0] d,
	input logic [1:0] s,
	output logic [7:0] q
);

always_comb begin
	q = d + s - 1;
end

endmodule