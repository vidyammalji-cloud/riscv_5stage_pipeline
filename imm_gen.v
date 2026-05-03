module imm_gen(
    input [31:0] instr,
    output reg [31:0] imm
);

always @(*) begin
    case (instr[6:0])
        7'b0010011: begin // ADDI
            imm = {{20{instr[31]}}, instr[31:20]};
        end
        default: imm = 0;
    endcase
end

endmodule