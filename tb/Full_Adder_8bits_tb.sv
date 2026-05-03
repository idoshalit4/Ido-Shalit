`timescale 1ns/1ps

`include "Full_Adder_8bits.v"

module Full_Adder_8bits_tb_sv; 
    logic [7:0] a;
    logic [7:0] b;
    logic sub;
    logic [7:0] sum;
    logic cout;      

    //We will add another variable for software calculation of a+b, We will use it to compare with the Hardware calculation
    logic [8:0] expected_result;


    //DUT:
    Full_Adder_8bits dut(
        .a (a),
        .b (b),
        .sub (sub),
        .sum (sum),
        .cout (cout)
);

    // stimulus block:
    initial begin

        $dumpfile("full_adder_waves.vcd");
        $dumpvars(0, Full_Adder_8bits_tb_sv);

        // system reset:
        a = 8'b0;
        b = 8'b0;
        sub = 1'b0;
        

        $monitor ("Time = %0t | sub = %b | a = %b | b = %b |  sum = %b | cout = %b", $time , sub , a , b ,sum , cout);

        $display("=== Starting Tests For Full Adder ===");

        //Test Edge Cases 1 : Ripple Carry Propagation (255+1)
        $display("Testing Edge case : Ripple Carry Propagation");
    
        #10;
        a = 8'b1111_1111; //a = 255
        b = 8'b0000_0001; //b = 1
        sub = 1'b0;
        //Expected Result: sum = 0000_0000 , cout = 1

        //Case 2: Unsigned Max Overflow (255+255)
        #10;
        $display ("Tesing Edge Case : Unsigned Max Overflow");
        a = 8'b1111_1111;
        b = 8'b1111_1111;
        sub = 1'b0;
        //Expected Result: sum = 1111_1110 , cout = 1

        //Case 3: Zero Subtraction (255-255)
        #10;
        $display("Tesing Edge Case : Zero Substraction");
        a = 8'b1111_1111;
        b = 8'b1111_1111;
        sub = 1'b1;
        //Expected Result: sum = 0000_0000 , cout = 1

        //Case 4: Negative Result (0-1-> Result in Two's complement)
        #10;
        $display("Tesing Edge Case : Negative Result");
        a = 8'b0000_0000; // a=0
        b = 8'b0000_0001; // b=1
        sub = 1'b1; //sub =1
        // Expected Result: sum = 1111_1111, cout = 0 (No carry = Borrow)
        
        $display("==Starting Automated Verification==");

        //Randomized Addition Tests (sub = 0)
        $display("Starting 100 Randomized Addition Tests:");
        sub = 1'b0;
        for (int i = 0; i<100; i++) begin
            a = $urandom();
            b = $urandom();
            #10;
            // Calculate expected 9-bit result using exact 2's complement hardware logic
            expected_result = a + b;
            if (sum !== expected_result[7:0] || cout !== expected_result[8] ) begin
                $display("ERROR at ADD: a = %b , b = %b | Expected Sum = %b, Expected Cout = %b | Got: Sum = %b , Cout = %b ",
                a , b , expected_result[7:0], expected_result[8], sum , cout);
                
            end
        end

        // --- Randomized Subtraction Tests (sub = 1) ---
        $display("Starting 100 Randomized Subtraction Tests:");
        sub = 1'b1;
        for (int i = 0; i < 100; i++) begin
            a = $urandom();
            b = $urandom();
            #10;
            
            // Calculate expected 9-bit result using exact 2's complement hardware logic
            expected_result = (a-b);
            
            if ((sum !== expected_result[7:0]) || (cout !== ~(expected_result[8]))) begin
                $display("ERROR at SUB: a = %b, b = %b | Expected sum = %b, cout = %b | Got sum = %b, cout = %b", 
                         a, b, expected_result[7:0], ~(expected_result[8]), sum, cout);
            end
        end
        //End Of Simulation
        #10;
        $display("=== Full_Adder_8bits Automated Tests Completed ===");
        $finish;
        
    end
endmodule
