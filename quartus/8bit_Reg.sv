module 8bit_Reg(
	input logic clock,
	input logic enable,
	input logic reset_n,
	input logic [7:0] in,
	output logic [7:0] out
);

always_ff @(posedge clock, negedge reset_n)begin
	if(!reset_n) begin
		out <= 0;
	end else begin
		if(enable) begin
			out <= in;
		end
	end
end

endmodule