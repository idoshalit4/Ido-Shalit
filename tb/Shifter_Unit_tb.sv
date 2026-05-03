`timescale 1ns/1ps

`include "Shifter_Unit.v"

module Shifter_Unit_tb_sv;
    logic [7:0] a;
    logic direction;
    logic [7:0] result;
    logic cout;

    //DUT:
    Shifter_Unit dut (
        .a(a),
        .direction(direction),
        .result(result),
        .cout(cout)
    );

    //stimulus block:
    initial begin
        //system reset:
        a = 8'b0;
        direction = 1'b0;

        $monitor ("Time = %0t | a = %b | direction = %b | result = %b | cout = %b", $time, a, direction, result, cout);

        $display("=== Starting Tests For Shifter Unit ===");

        //Case 1: We will try to push the MSB to cout
        $display("== Starting Edge Case 1: Pushing MSB To Cout ==");
        #10;
        a = 8'b1000_0000;
        direction = 1'b1;
        //Expected Result: result = 0000_0000, cout = 1

        $display("== Starting Edge Case 2: Pushing LSB to Cout ==");
        #10;
        a = 8'b0000_0001;
        direction = 1'b0;
        //Expected Result: result = 0000_0000, cout = 1

        $display("== Starting Edge Case 3: Pusing 0 to Result");
        #10;
        a = 8'b1111_1111;
        direction = 1;
        //Expected Result: result = 1111_1110, cout = 1

        $display("== Starting Automated Verification for Shifter Unit ==");
        $display("== Starting 100 Randomized Verifications For Right Shift ==");
        direction =1'b0;
        for (int i = 0 ;i<100 ;i++) begin
            a = $urandom();
            #10;
            if (result !== (a >> 1) || cout !== a[0]) begin
                $display("ERROR at Right Shift: a = %b | Expected Result = %b , Expected Cout = %b | Got: result = %b , cout = %b",
                a, a >> 1, a[0], result , cout);
            end
        end

        $display("== Starting 100 Randomized Verifications For Left Shift ==");
        direction = 1'b1;
         for (int i = 0 ;i<100 ;i++) begin
            a = $urandom();
            #10;
            if (result !== (a << 1) || cout !== a[7]  ) begin
                $display("ERROR at Left Shift: a = %b | Expected Result = %b , Expected Cout = %b | Got: result = %b , cout = %b",
                a, a << 1, a[7], result , cout);
            end
        end
    

        // End of Simulation
        #10;
        $display("=== Shifter_Unit Automated Tests Completed ===");
        $finish;
    end

    
endmodule