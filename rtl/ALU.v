`include "Logic_Unit.v"
`include "Shifter_Unit.v"
`include "Full_Adder_8bits.v"

module ALU (
    input [7:0] a,
    input [7:0] b,
    input [2:0] OpCode,
    output reg [7:0] result,
    output reg  Carry_Flag,
    output reg Zero_Flag
);

//Wires Decleration:
wire [7:0] fa_wire, logic_wire, shifter_wire; //results wires
wire [2:0] c; // carry wires

Full_Adder_8bits fa1 (.a(a), .b(b), .sub(OpCode[0]), .cout(c[0]), .sum(fa_wire) );
Logic_Unit lu1 ( .a(a), .b(b), .opcode(OpCode[1:0]), .result(logic_wire) );
Shifter_Unit su1 ( .a(a), .direction(OpCode[0]), .cout(c[1]), .result(shifter_wire));

always @(*) begin
    case (OpCode)
      3'b000 : result = fa_wire;
      3'b001 : result = fa_wire;
      3'b010 : result = shifter_wire;
      3'b011 : result = shifter_wire;
      3'b100 : result = logic_wire;
      3'b101 : result = logic_wire;
      3'b110 : result = logic_wire;
        default: result = 8'b0;
    endcase 
    
end

//Carry Flag:
always @(*) begin
    case (OpCode)
      3'b000 : Carry_Flag = c[0];
      3'b001 : Carry_Flag = ~c[0]; // Create a Borrow Flag
      3'b010 : Carry_Flag = c[1];
      3'b011 : Carry_Flag = c[1];
        default: Carry_Flag = 1'b0;
    endcase
    
end

//Zero Flag:
always @(*) begin
    if (result == 8'b0) begin
        Zero_Flag = 1'b1;
    end
    else begin
        Zero_Flag = 1'b0;
    end
    
end
    
endmodule