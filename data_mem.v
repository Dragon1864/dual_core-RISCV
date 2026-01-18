module data_mem(clk,memread,memwrite,addr,writedata,readdata);
input clk,memread,memwrite;
input [31:0] addr, writedata;
output reg [31:0] readdata;
(* rom_style = "block" *)
reg [31:0] mem [0:255]; 

always @(posedge clk) begin
    if(memwrite) begin
        mem[addr] <= writedata;
    end
    if(memread) begin
        readdata <= mem[addr[9:2]];
    end
end

endmodule