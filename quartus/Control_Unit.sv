module ControlUnit(
	input logic clock,
	input logic reset_n,
	input logic [7:0] instruction,
	input logic [7:0] data,
	
	output logic [14:0] register_enables,
	output logic [3:0] bus_mux_select,
	output logic [2:0] mux_selects,
	output logic [9:0] status_lights
);

logic [2:0] cycles;

always_comb begin
	case(cycles)
		3'd0: status_lights[6:0] = 7'b000_0000;
		3'd1: status_lights[6:0] = 7'b000_0001;
		3'd2: status_lights[6:0] = 7'b000_0011;
		3'd3: status_lights[6:0] = 7'b000_0111;
		3'd4: status_lights[6:0] = 7'b000_1111;
		3'd5: status_lights[6:0] = 7'b001_1111;
		3'd6: status_lights[6:0] = 7'b011_1111;
		3'd7: status_lights[6:0] = 7'b111_1111;
	endcase
end


always_ff @(posedge clock, negedge reset_n) begin
	if(!reset_n) begin
		cycles <= 3'd0;
	end else begin
		if(cycles == 3'd0) begin //fetch
			
		end
	end
end

endmodule