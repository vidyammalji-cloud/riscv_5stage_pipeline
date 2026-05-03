module id_ex(
    input clk,
    input reset,
    input flush,

    // ================= INPUTS =================
    input [31:0] rs1_data_in,
    input [31:0] rs2_data_in,
    input [31:0] imm_in,
    input        alu_src_in,
    input [3:0]  alu_ctrl_in,
    input        reg_write_in,
    input        mem_read_in,
    input        mem_write_in,
    input        mem_to_reg_in,
    input [4:0]  rd_in,

    input [4:0] rs1_addr_in,
    input [4:0] rs2_addr_in,

    // ================= OUTPUTS =================
    output reg [31:0] rs1_data_out,
    output reg [31:0] rs2_data_out,
    output reg [31:0] imm_out,
    output reg        alu_src_out,
    output reg [3:0]  alu_ctrl_out,
    output reg        reg_write_out,
    output reg        mem_read_out,
    output reg        mem_write_out,
    output reg        mem_to_reg_out,
    output reg [4:0]  rd_out,

    output reg [4:0] rs1_addr_out,
    output reg [4:0] rs2_addr_out
);

always @(posedge clk or posedge reset) begin
    // ================= RESET or FLUSH =================
    if (reset || flush) begin
        rs1_data_out   <= 32'b0;
        rs2_data_out   <= 32'b0;
        imm_out        <= 32'b0;
        alu_src_out    <= 1'b0;
        alu_ctrl_out   <= 4'b0000;
        reg_write_out  <= 1'b0;
        mem_read_out   <= 1'b0;
        mem_write_out  <= 1'b0;
        mem_to_reg_out <= 1'b0;
        rd_out         <= 5'b00000;

        rs1_addr_out   <= 5'b00000;
        rs2_addr_out   <= 5'b00000;
    end 
    // ================= NORMAL OPERATION =================
    else begin
        rs1_data_out   <= rs1_data_in;
        rs2_data_out   <= rs2_data_in;
        imm_out        <= imm_in;
        alu_src_out    <= alu_src_in;
        alu_ctrl_out   <= alu_ctrl_in;
        reg_write_out  <= reg_write_in;
        mem_read_out   <= mem_read_in;
        mem_write_out  <= mem_write_in;
        mem_to_reg_out <= mem_to_reg_in;
        rd_out         <= rd_in;

        rs1_addr_out   <= rs1_addr_in;
        rs2_addr_out   <= rs2_addr_in;
    end
end

endmodule