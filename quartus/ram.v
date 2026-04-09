module ram (
    input  [16:0] address,   // 17-bit address for 131072 locations
    input  [7:0]  data,      // 8-bit data in
    input         wren,
    input         clock,
    output [7:0]  q          // 8-bit data out
);

    wire [7:0] sub_wire0;
    wire [7:0] q = sub_wire0[7:0];

    altsyncram altsyncram_component (
        .address_a      (address),
        .clock0         (clock),
        .data_a         (data),
        .wren_a         (wren),
        .q_a            (sub_wire0),
        .aclr0          (1'b0),
        .aclr1          (1'b0),
        .address_b      (1'b1),
        .addressstall_a (1'b0),
        .addressstall_b (1'b0),
        .byteena_a      (1'b1),
        .byteena_b      (1'b1),
        .clock1         (1'b1),
        .clocken0       (1'b1),
        .clocken1       (1'b1),
        .clocken2       (1'b1),
        .clocken3       (1'b1),
        .data_b         (1'b1),
        .rden_a         (1'b1),
        .rden_b         (1'b1),
        .wren_b         (1'b0)
    );

    defparam
        altsyncram_component.operation_mode          = "SINGLE_PORT",
        altsyncram_component.width_a                 = 8,     // changed
        altsyncram_component.widthad_a               = 17,    // changed
        altsyncram_component.numwords_a              = 131072, // changed
        altsyncram_component.width_byteena_a         = 1,
        altsyncram_component.intended_device_family  = "MAX 10",
        altsyncram_component.lpm_type                = "altsyncram",
        altsyncram_component.lpm_hint                = "ENABLE_RUNTIME_MOD=NO",
        altsyncram_component.outdata_reg_a           = "CLOCK0",
        altsyncram_component.outdata_aclr_a          = "NONE",
        altsyncram_component.address_aclr_a          = "NONE",
        altsyncram_component.clock_enable_input_a    = "BYPASS",
        altsyncram_component.clock_enable_output_a   = "BYPASS";

endmodule