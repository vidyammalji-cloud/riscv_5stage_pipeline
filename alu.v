module alu(
    input [31:0] a,
    input [31:0] b,
    input [3:0] alu_ctrl,
    output reg [31:0] result
);
always @(*) begin
    case(alu_ctrl)
        4'b0010: result = a + b;  // ADD
        4'b0110: result = a - b;  // SUB
        default: result = 0;
    endcase
end


endmodule