module dual_core(clk, rst);
input clk,rst;

//core1
wire [31:0] pc1;
wire [31:0] instr1;
wire stall1;
//core2
wire [31:0] pc2;
wire [31:0] instr2;
wire stall2;

wire [31:0] mem_addr;
wire [31:0] mem_instr;

//shared memory
instr_mem SIM(.addr(mem_addr),.instr(mem_instr));


//arbiter
instr_arbiter rr(.clk(clk), .rst(rst), .pc1(pc1), .pc2(pc2), .instr1(instr1), .instr2(instr2), .stall1(stall1), .stall2(stall2), .mem_addr(mem_addr), .mem_data(mem_instr));

//core1
riscv_cpu core1(.clk(clk),.reset(rst), .stall(stall1), .instr_in(instr1), .pc_out(pc1));

//core2
riscv_cpu core2(.clk(clk),.reset(rst),.stall(stall2), .instr_in(instr2), .pc_out(pc2));

////instr_mem1
//instr_mem IM1(.addr(pc1), .instr(instr1));
////instr_mem2
//instr_mem IM2(.addr(pc2), .instr(instr2));


endmodule





