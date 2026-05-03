module alu_control(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [3:0] alu_ctrl
);

always @(*) begin
    case(opcode)

        7'b0010011: begin // ADDI
            alu_ctrl = 4'b0010; // ADD
        end

        7'b0110011: begin // R-type
            case({funct7, funct3})
                {7'b0000000, 3'b000}: alu_ctrl = 4'b0010; // ADD
                {7'b0100000, 3'b000}: alu_ctrl = 4'b0110; // SUB
                default: alu_ctrl = 4'b0000;
            endcase
        end

        default: alu_ctrl = 4'b0000;
    endcase
end

endmodule