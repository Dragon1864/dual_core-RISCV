module riscv_cpu(clk,reset,instr_in,stall,pc_out);
input clk,reset,stall;
input [31:0] instr_in;
output [31:0] pc_out;

wire [31:0] instr = instr_in;


// Program counter
reg [31:0] pc;
wire [31:0] pc_next, pc_plus4;

always @(posedge clk or posedge reset)
begin
    if(reset)
    pc<=32'b0;
    else if(!stall)
    pc<=pc_next;
end
assign pc_next = jump? (pc + imm) :
    branch_taken ? branch_target :pc_plus4;

//instruction memory
//wire [31:0] instr;
//instr_mem IM(.addr(pc),.instr(instr));
//fixing branch logic.
wire beq = branch && (funct3 == 3'b000);
//writeback
wire [31:0] write_back = memtoreg ? mem_data:result;
//Decoding fields
wire[6:0] opcode = instr[6:0];
wire[4:0] rd = instr[11:7];
wire[2:0] funct3 = instr[14:12];
wire[4:0] rs1 = instr[19:15];
wire[4:0] rs2 = instr[24:20];
wire[6:0] funct7 = instr[31:25];
wire jump;
wire regwrite,memread,memwrite,memtoreg;
wire alusrc,branch;
wire [3:0] alucntrl;
wire [31:0] reg_rs1, reg_rs2;
wire [31:0] result;
wire zero;

control_unit CU(.opcode(opcode), .funct3(funct3), .funct7(funct7),.regwrite(regwrite),.memread(memread),.memwrite(memwrite),.memtoreg(memtoreg),.alusrc(alusrc),.branch(branch),.alucntrl(alucntrl),.jump(jump));

reg_file rf(.clk(clk),.rst(reset),.we(regwrite),.rs1(rs1),.rs2(rs2),.rd(rd),.wd(write_back),.rd1(reg_rs1),.rd2(reg_rs2));


// Immediate generator
wire [31:0] imm;
imm_gen img(.instr(instr),.imm(imm));

//alu_mux
wire [31:0] alu_in = (alusrc) ? imm:reg_rs2;

//ALU

alu_control ALU(.a(reg_rs1),.b(alu_in),.alu_cntrl(alucntrl),.result(result),.zero(zero));

//Data memory
wire [31:0] mem_data;
data_mem DMEM(.clk(clk), .memread(memread), .memwrite(memwrite),.addr(result),.writedata(reg_rs2),.readdata(mem_data));

//write back mux


//branch logic
wire branch_taken = beq & zero;
wire[31:0] branch_target = pc+imm;



assign pc_plus4 = pc + 4;

assign pc_out = pc;
always @(posedge clk) begin
    if (branch) begin
        $display("BR pc=%h imm=%h rs1=%0d rs2=%0d zero=%b taken=%b next_pc=%h",
                 pc, imm, reg_rs1, reg_rs2, zero, branch_taken, pc_next);
    end
end

endmodule


