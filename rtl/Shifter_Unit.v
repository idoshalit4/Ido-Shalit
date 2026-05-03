module Shifter_Unit (
    input [7:0] a,
    input direction, //1 for Left, 0 for Right
    output reg [7:0] result,
    output reg cout
);

always @(*) begin
    if (direction==1'b1) begin
        cout = a[7]; //saving MSB
        result = a << 1; //Left shift by 1 bit
    end
    else begin
        cout = a[0]; //saving LSB
        result = a >> 1; //Right shift by 1 bit
    end
end



    

    
endmodule