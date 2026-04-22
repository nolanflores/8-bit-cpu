module Multiplexer(
	input logic [1:0] d,
	input logic s,
	output logic q
);

always_comb begin
	if(s) begin
		q = d[1];
	end else begin
		q = d[0];
	end
end

endmodule