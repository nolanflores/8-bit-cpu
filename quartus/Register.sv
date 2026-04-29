module Register(
	input logic clock,
	input logic enable,
	input logic reset_n,
	input logic [7:0] in,
	output logic [7:0] out
);

always_ff @(posedge clock, negedge reset_n) begin
	if(!reset_n) begin
		out <= 8'b0;
	end else if(enable) begin
		out <= in;
	end
end

endmodule