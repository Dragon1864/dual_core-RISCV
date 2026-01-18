module imm_gen(instr, imm);
input [31:0] instr;
output reg [31:0] imm;

wire [6:0] opcode = instr[6:0];

always @(*) begin
        case (opcode)

            // I-Type (ADDI, LW, JALR)
            7'b0010011,
            7'b0000011,
            7'b1100111:
                imm = {{20{instr[31]}}, instr[31:20]};

            // S-Type (SW)
            7'b0100011:
                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};

            // B-Type (BEQ, BNE)
            7'b1100011:
                imm = {{19{instr[31]}},
                        instr[31],
                        instr[7],
                        instr[30:25],
                        instr[11:8],
                        1'b0};

            // J-Type (JAL)
            7'b1101111:
                imm = {{11{instr[31]}},
                        instr[31],
                        instr[19:12],
                        instr[20],
                        instr[30:21],
                        1'b0};

            default:
                imm = 32'b0;
        endcase
    end
endmodule