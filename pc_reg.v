module pc_reg(
    input clk,
    input reset,
    input stall,        // ? REQUIRED
    input [31:0] pc_next,
    output reg [31:0] pc
);

always @(posedge clk or posedge reset) begin
    if (reset)
        pc <= 0;
    else if (!stall)
        pc <= pc_next;
end

endmodule