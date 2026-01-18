module reg_file(clk,rst,we,rs1,rs2,rd,wd,rd1,rd2);
input clk,we,rst;
input [4:0] rs1,rs2,rd;
input [31:0] wd;
output [31:0] rd1,rd2;

reg [31:0] regs[0:31];
integer i;

assign rd1 = (rs1 !=0) ? regs[rs1]:32'b0;
assign rd2 = (rs2!=0) ? regs[rs2]:32'b0;

always @(posedge clk or posedge rst) begin
if(rst) begin
for (i =0; i<32; i=i+1)
regs[i] <=32'b0;
end
else if(we && rd!=0) begin
        regs[rd]<=wd;
    end
end
endmodule
