`include "Full_Adder_1bit.v"
module Full_Adder_8bits (
    input [7:0] a, b,
    input sub,
    output  [7:0] sum,
    output  cout

);

//carry:
wire [8:0] c;

//wire for: b ^ sub input:
wire [7:0] b_final;

//(b ^ sub) for sub/add:
assign b_final = b ^ {8{sub}};
assign c[0] = sub;
assign cout = c[8];

//
Full_Adder_1bit fa0 (.a(a[0]), .b(b_final[0]), .cin(c[0]), .cout(c[1]), .sum(sum[0]));
Full_Adder_1bit fa1 (.a(a[1]), .b(b_final[1]), .cin(c[1]), .cout(c[2]), .sum(sum[1]));
Full_Adder_1bit fa2 (.a(a[2]), .b(b_final[2]), .cin(c[2]), .cout(c[3]), .sum(sum[2]));
Full_Adder_1bit fa3 (.a(a[3]), .b(b_final[3]), .cin(c[3]), .cout(c[4]), .sum(sum[3]));
Full_Adder_1bit fa4 (.a(a[4]), .b(b_final[4]), .cin(c[4]), .cout(c[5]), .sum(sum[4]));
Full_Adder_1bit fa5 (.a(a[5]), .b(b_final[5]), .cin(c[5]), .cout(c[6]), .sum(sum[5]));
Full_Adder_1bit fa6 (.a(a[6]), .b(b_final[6]), .cin(c[6]), .cout(c[7]), .sum(sum[6]));
Full_Adder_1bit fa7 (.a(a[7]), .b(b_final[7]), .cin(c[7]), .cout(c[8]), .sum(sum[7]));
    

endmodule