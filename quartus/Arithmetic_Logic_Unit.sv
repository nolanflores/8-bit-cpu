module Arithmetic_Logic_Unit(
	input logic [7:0] a,
	input logic [7:0] b,
	input logic [3:0] select,
	input logic c_in,
	output logic [7:0] q,
	output logic c_out,
	output logic z_out,
	output logic v_out,
	output logic s_out
);

always_comb begin
	c_out = 1'b0;
	v_out = 1'b0;
	case(select)
		0: begin //add
				{c_out, q} = a + b;
				v_out = (~a[7] & ~b[7] & q[7]) | ( a[7] &  b[7] & ~q[7]);
			end
		1: begin //addc
				{c_out, q} = a + b + c_in;
				v_out = (~a[7] & ~b[7] & q[7]) | ( a[7] &  b[7] & ~q[7]);
			end
		2: begin //sub
				{c_out, q} = a + (~b) + 1;
				v_out = (~a[7] &  b[7] & q[7]) | ( a[7] & ~b[7] & ~q[7]);
			end
		3: begin //subc
				{c_out, q} = a + (~b) + c_in;
				v_out = (~a[7] &  b[7] & q[7]) | ( a[7] & ~b[7] & ~q[7]);
			end
		4: begin //and
				q = a & b;
			end
		5: begin //or
				q = a | b;
			end
		6: begin //xor
				q = a ^ b;
			end
		7: begin //not
				q = ~a;
			end
		8: begin //neg
				q = ~a + 1;
				v_out = (a == 8'h80);
			end
		9: begin //lsl
				c_out = a[7];
				q = {a[6:0], 1'b0};
			end
		10: begin //lslc
				c_out = a[7];
				q = {a[6:0], c_in};
			end
		11: begin //lsr
				c_out = a[0];
				q = {1'b0, a[7:1]};
			end
		12: begin //lsrc
				c_out = a[0];
				q = {c_in, a[7:1]};
			end
		13: begin //asr
				c_out = a[0];
				q = {a[7], a[7:1]};
			end
		14: begin //inc
				{c_out, q} = a + 1;
				v_out = (~a[7] & q[7]);
			end
		15: begin //dec
				{c_out, q} = a + 8'hFF;
				v_out = ( a[7] & ~q[7]);
			end
	endcase
	z_out = (q == 8'b0);
	s_out = q[7];
end

endmodule