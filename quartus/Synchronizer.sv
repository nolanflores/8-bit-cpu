module Synchronizer(
	input logic [7:0] async_in,
	input logic clock,
	output logic [7:0] sync_out
);

logic [7:0] meta;

always_ff @(posedge clock) begin
	meta <= async_in;
	sync_out <= meta;
end

endmodule