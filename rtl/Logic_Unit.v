//Include relevant boxes:
`include "Bit_Wise_And.v"
`include "Bit_Wise_Or.v"
`include "Bit_Wise_Xor.v"

module Logic_Unit (
    input [7:0] a,
    input [7:0] b,
    input [1:0] opcode,
    output reg [7:0] result

);
//3 wire Declerations:
wire [7:0] or_wire, and_wire, xor_wire;

//Instantiation and Structural Connection:
Bit_Wise_And and_inst1 (.a(a), .b(b), .result( and_wire));
Bit_Wise_Or or_inst1 (.a(a), .b(b), .result( or_wire));
Bit_Wise_Xor xor_inst1 (.a(a), .b(b), .result( xor_wire));

//multiplexer:
always @(*) begin
    case (opcode)

        2'b00: result = or_wire;
        2'b01: result = and_wire;
        2'b10: result = xor_wire;
        default: result = 8'b0;
        
    endcase 
    
end

    
endmodule