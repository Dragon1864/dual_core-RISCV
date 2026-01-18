module control_unit(opcode,funct3,funct7,regwrite,memread,memwrite,memtoreg,alusrc,branch,jump,alucntrl);
input [6:0] opcode;
input [2:0] funct3;
input [6:0] funct7;

output reg regwrite, memread, memwrite, memtoreg, alusrc, branch, jump;
output reg [3:0] alucntrl;

always@(*)
begin
        regwrite=0;
        memread=0;
        memwrite=0;
        memtoreg=0;
        alusrc=0;
        branch=0;
        jump=0;
        alucntrl= 4'b0000;
    case(opcode)
        
    //R-type
    7'b0110011: begin
        regwrite=1;
        memread=0;
        memwrite=0;
        memtoreg=0;
        alusrc=0;
        branch=0;
        jump=0;

        case(funct3)
            3'b000: begin
                if(funct7==7'b0000000)
                    alucntrl=4'b0001; //ADD
                else if(funct7==7'b0100000)
                    alucntrl=4'b0010; //SUB
            end
            3'b111: alucntrl=4'b0011; //AND
            3'b110: alucntrl=4'b0100; // OR
            3'b001: alucntrl=4'b0111; // SLL
            3'b011: alucntrl = 4'b0110; //SLTU
            3'b100: alucntrl = 4'b0101; //XOR
            3'b101: alucntrl = 4'b1000; //SRL 
            default: alucntrl=4'b0;
        endcase
    end

    // I type
    7'b0010011: begin
        regwrite=1;
        memread=0;
        memwrite=0;
        memtoreg=0;
        alusrc=1;
        branch=0;
        jump=0;
        
        case(funct3)
       
            3'b000: alucntrl = 4'b0001; // ADDI
            3'b001: alucntrl = 4'b0111; // SLLI
            3'b011: alucntrl = 4'b0110; // SLTIU
            3'b100: alucntrl = 4'b0101; // XORI
            3'b101: alucntrl = 4'b1000; // SRLI
            3'b111: alucntrl = 4'b0011; // ANDI
            3'b110: alucntrl = 4'b0100; // ORI
            default: alucntrl = 4'b0;
        endcase
    end

    // LOAD
    7'b0000011: begin
        regwrite=1;
        memread=1;
        memwrite=0;
        memtoreg=1;
        alusrc=1;
        branch=0;
        jump=0;
        alucntrl=4'b0001;
    end

    // Store
    7'b0100011: begin
        regwrite=0;
        memread=0;
        memwrite=1;
        memtoreg=0;
        alusrc=1;
        branch=0;
        jump=0;
        alucntrl=4'b0001;
    end

    // Branch
    7'b1100011: begin
        regwrite=0;
        memread=0;
        memwrite=0;
        memtoreg=0;
        alusrc=0;
        branch=1;
        jump=0;
        alucntrl=4'b0010;
    end

    // JAL
    7'b1101111: begin
        regwrite=1;
        memread=0;
        memwrite=0;
        memtoreg=0;
        alusrc=0;
        branch=0;
        jump=1;
        alucntrl=4'b0001;
    end

    default: begin
        regwrite=0;
        memread=0;
        memwrite=0;
        memtoreg=0;
        alusrc=0;
        branch=0;
        jump=0;
        alucntrl=4'b0000;
    end 
    endcase
end
endmodule