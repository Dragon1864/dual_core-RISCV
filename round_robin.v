module instr_arbiter(clk,rst,pc1,pc2,instr1,instr2,stall1,stall2,mem_addr,mem_data);
input clk,rst;
input [31:0] mem_data;
input [31:0] pc1,pc2;
output reg [31:0] instr1,instr2;
output reg stall1,stall2;
output reg [31:0] mem_addr;

reg turn;

always @(posedge clk or posedge rst)
begin
if(rst)
turn<=1'b0;

else
turn<=~turn;
end


always@(*) begin

stall1=1'b1;
stall2=1'b1;
instr1=32'b0;
instr2=32'b0;
mem_addr=32'b0;

if(turn == 1'b0) begin
mem_addr = pc1;
instr1=mem_data;
stall1=1'b0;
end
else
begin
mem_addr = pc2;
instr2 = mem_data;
stall2 = 1'b0;
end
end
endmodule
