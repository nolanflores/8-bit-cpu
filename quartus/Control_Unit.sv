module ControlUnit(
    input logic clock, reset_n,
    input logic [7:0] ir, dr, sr,
    output logic [13:0] register_enables,
    output logic ac_select, sr_select,
    output logic wr_select, mdr_select,
    output logic [1:0] mar_select, pc_select,
    output logic [3:0] alu_select, bus_select,
    output logic [9:0] status_lights
);

// ─── Register indices ──────────────────────────────────────────────────────
localparam R_PC   = 4'd0;
localparam R_IR   = 4'd1;
localparam R_DR   = 4'd2;
localparam R_A    = 4'd3;
localparam R_B    = 4'd4;
localparam R_C    = 4'd5;
localparam R_AC   = 4'd6;
localparam R_SR   = 4'd7;
localparam R_MDR  = 4'd8;
localparam R_MARL = 4'd9;
localparam R_MARH = 4'd10;
localparam R_HEXA = 4'd11;
localparam R_HEXB = 4'd12;
localparam R_HEXC = 4'd13;

// ─── Sequential state ──────────────────────────────────────────────────────
logic [2:0] cycle, next_cycle;
logic [1:0] startup;

always_ff @(posedge clock, negedge reset_n) begin
	if(!reset_n) begin
		cycle <= 3'd0;
		startup <= 2'd0;
	end else if(startup == 2'b11) begin
		cycle <= next_cycle;
	end else begin
		startup <= startup + 2'd1;
	end
end

// ─── Combinational control ─────────────────────────────────────────────────
//
//  register_enables[N] = 1 : latch register N from the internal bus
//  ac_select  = 1          : latch AC  from ALU result  (dedicated path, not bus)
//  sr_select  = 1          : latch SR  from ALU / SR-bit logic (dedicated path)
//  mdr_select = 1          : latch MDR from memory data bus    (dedicated path)
//  wr_select  = 1          : write M[MAR] <- MDR
//
//  bus_select[3:0] : register index whose output drives the internal bus.
//                    Matches R_xx constants above (0-13).
//
//  mar_select : 2'b00 = hold  |  2'b01 = MAR+1  |  2'b10 = MAR-1
//               2'b11 = load MAR from the instruction-embedded address
//                       (datapath muxes {2'b0,ir[5:0]} -> marH, dr -> marL)
//
//  pc_select  : 2'b00 = hold  |  2'b01 = PC+1   |  2'b10 = jump (bus)
//               2'b11 = conditional skip -- datapath adds 2 to PC if
//                       SR[alu_select[2:0]] == alu_select[3]
//
//  FETCH model: memory is 16-bit wide, addressed by PC (word address).
//    Upper byte -> IR, lower byte -> DR, both latched together in cycle 1.
//    PC increments by 1 word in cycle 2.
//
//  sr_select dual use:
//    ALU instructions  : SR <- ALU flag outputs
//    SR bit ops        : SR <- bit-force using {alu_select[3]=polarity,
//                                               alu_select[2:0]=bit index}
//    The datapath distinguishes these from the surrounding instruction context.

always_comb begin
    // ── Defaults (safe / inactive) ────────────────────────────────────────
    register_enables = 14'd0;
    ac_select        = 1'b0;
    sr_select        = 1'b0;
    wr_select        = 1'b0;
    mdr_select       = 1'b0;
    mar_select       = 2'b00;
    pc_select        = 2'b00;
    alu_select       = 4'd0;
    bus_select       = 4'd0;
    next_cycle       = cycle + 3'd1;
    status_lights    = {7'd0, cycle};

    // ── FETCH  cycle 1 ────────────────────────────────────────────────────
    register_enables[R_IR] = (cycle == 3'd1);
    register_enables[R_DR] = (cycle == 3'd1);

    // ── FETCH  cycle 2 ────────────────────────────────────────────────────
    // PC <- PC + 1  (advance to next instruction word).
    register_enables[R_PC] = (cycle == 3'd2);
    if (cycle == 3'd2) pc_select = 2'b01;

    // ── EXECUTE  cycle  ─────────────────────────────────────────────────
    if (cycle >= 3'd3) begin

        if (ir[7]) begin
            // ── Absolute-address memory ────────────────────────────────────
            //   10aa_aaaa  aaaa_aaaa : M[{ir[5:0], dr}] -> MDR   (load)
            //   11aa_aaaa  aaaa_aaaa : MDR -> M[{ir[5:0], dr}]   (store)
            //
            //   Cycle 3 : load MAR with the 14-bit embedded address.
            //   Cycle 4 : perform the read or write.
            case(cycle)
                3'd3: begin
                    register_enables[R_MARL] = 1'b1;
                    register_enables[R_MARH] = 1'b1;
                    mar_select = 2'b11;        // MAR <- {ir[5:0], dr}
                    next_cycle = 3'd4;
                end
                3'd4: begin
                    mdr_select = ~ir[6];       // ir[6]=0 -> MDR <- M[MAR]
                    wr_select  =  ir[6];       // ir[6]=1 -> M[MAR] <- MDR
                    next_cycle = 3'd1;
                end
                default: next_cycle = 3'd1;
            endcase

        end else begin
            case (ir[6:5])
                // 0000_dddd  xxxx_rrrr : reg[r] -> reg[d]
                // 0001_dddd  iiii_iiii : DR -> reg[d]
                2'b00: begin
                    bus_select = ir[4] ? R_DR : dr[3:0];
                    if(cycle == 3'd3) begin
                        register_enables[ir[3:0]] = 1'b1;
                        next_cycle = 3'd1;
                    end
                end
                //   0010_oooo  xxxx_rrrr : ALU(AC, reg[r], o) -> AC, SR
                //   0011_oooo  iiii_iiii : ALU(AC, DR, o) -> AC, SR
                2'b01: begin
                    bus_select = ir[4] ? R_DR : dr[3:0];
                    if(cycle == 3'd3) begin
                        alu_select = ir[3:0];
                        ac_select = 1'b1;
                        sr_select = 1'b1;
                        next_cycle = 3'd1;
                    end
                end

                // ── SR / Skip ─────────────────────────────────────────────────
                //   0100_0fff : SR[f] <- 0   clear bit
                //   0100_1fff : SR[f] <- 1   set   bit
                //   0101_0fff : skip next instruction if SR[f] = 0
                //   0101_1fff : skip next instruction if SR[f] = 1
                //
                //   alu_select[3]   = polarity  (0 = clear / skip-if-0)
                //   alu_select[2:0] = bit index f  (c=0, z=1, v=2, s=3)
                2'b10: begin
						if(ir[3]) begin
							//clear and set ir bits
						end else begin
							if(sr[ir[2:0]] == ir[3]) begin
								pc_select = 2'b1;
							end
						end
                end

                // ── MAR-relative memory ops ───────────────────────────────────
                //   011x_0000 : m[mar]  -> mdr    hold  MAR
                //   011x_0001 : m[mar+] -> mdr    MAR <- MAR+1 after access
                //   011x_0010 : m[mar-] -> mdr    MAR <- MAR-1 after access
                //   011x_0011 : mdr     -> m[mar] hold  MAR
                //   011x_0100 : mdr     -> m[mar+] MAR <- MAR+1 after access
                //   011x_0101 : mdr     -> m[mar-] MAR <- MAR-1 after access
                //   011x_0110 : nop
                //
                //   marL/marH write enables are only asserted when MAR changes.
                //   If your memory read has >0 latency, split reads into two
                //   execute cycles (address on cycle 3, latch MDR on cycle 4).
                2'b11: begin
                    if (cycle == 3'd3) begin
                        case (ir[3:0])
                            4'd0: begin  // m[mar] -> mdr
                                mdr_select = 1'b1;
                            end
                            4'd1: begin  // m[mar+] -> mdr
                                mdr_select = 1'b1;
                                mar_select = 2'b01;
                                register_enables[R_MARL] = 1'b1;
                                register_enables[R_MARH] = 1'b1;
                            end
                            4'd2: begin  // m[mar-] -> mdr
                                mdr_select = 1'b1;
                                mar_select = 2'b10;
                                register_enables[R_MARL] = 1'b1;
                                register_enables[R_MARH] = 1'b1;
                            end
                            4'd3: begin  // mdr -> m[mar]
                                wr_select = 1'b1;
                            end
                            4'd4: begin  // mdr -> m[mar+]
                                wr_select  = 1'b1;
                                mar_select = 2'b01;
                                register_enables[R_MARL] = 1'b1;
                                register_enables[R_MARH] = 1'b1;
                            end
                            4'd5: begin  // mdr -> m[mar-]
                                wr_select  = 1'b1;
                                mar_select = 2'b10;
                                register_enables[R_MARL] = 1'b1;
                                register_enables[R_MARH] = 1'b1;
                            end
                            default: ; // nop / undefined
                        endcase
                        next_cycle = 3'd1;
                    end
                end

            endcase
        end
    end
end

endmodule