module dual_core(clk, rst);
input clk,rst;

//core1
wire [31:0] pc1;
wire [31:0] instr1;

//core2
wire [31:0] pc2;
wire [31:0] instr2;

//core1
riscv_cpu core1(.clk(clk),.reset(rst), .instr_in(instr1), .pc_out(pc1));

//core2
riscv_cpu core2(.clk(clk),.reset(rst), .instr_in(instr2), .pc_out(pc2));

//instr_mem1
instr_mem IM1(.addr(pc1), .instr(instr1));
//instr_mem2
instr_mem IM2(.addr(pc2), .instr(instr2));


endmodule





