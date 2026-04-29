module Seven_Segment_Display(
	input logic [3:0] in,
	output logic [6:0] out
);

always_comb begin
	case(in)
		0: out = 7'b100_0000;
		1: out = 7'b111_1001;
		2: out = 7'b010_0100;
		3: out = 7'b011_0000;
		4: out = 7'b001_1001;
		5: out = 7'b001_0010;
		6: out = 7'b000_0010;
		7: out = 7'b111_1000;
		8: out = 7'b000_0000;
		9: out = 7'b001_1000;
		10: out = 7'b000_1000;
		11: out = 7'b000_0011;
		12: out = 7'b100_0110;
		13: out = 7'b010_0001;
		14: out = 7'b000_0110;
		15: out = 7'b000_1110;
	endcase
end

endmodule