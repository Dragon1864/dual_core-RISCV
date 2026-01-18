module alu_control(a,b,alu_cntrl,result,zero);
input [31:0]a,b;
input [3:0] alu_cntrl;
output zero;
output reg [31:0] result;

always @(*) begin
    case(alu_cntrl)
        4'b0001: result = a+b;
        4'b0010: result = a-b;
        4'b0011: result = a&b;
        4'b0100: result = a|b;
        4'b0101: result = a^b;
        4'b0110: result = (a<b) ? 32'b1: 32'b0; // Set less than
        4'b0111: result = b<<a[4:0]; //shift left logical
        4'b1000: result = b>>a[4:0]; // shift right logical
        default: result = 32'b0;
    endcase
end
assign zero = (result == 32'b0);
endmodule
