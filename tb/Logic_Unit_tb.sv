`timescale 1ns/1ps

`include "Logic_Unit.v"

module Logic_Unit_tb_sv ;
    logic [7:0] a;
    logic [7:0] b;
    logic [1:0] opcode;
    logic [7:0] result;

    //DUT:
    Logic_Unit dut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result)
    );

    //stimulus block:
    initial begin

        $dumpfile("logic_unit_waves.vcd");
        $dumpvars(0, Logic_Unit_tb_sv);
        //system reset:
        a = 8'b0;
        b = 8'b0;
        opcode = 2'b0;

        $monitor ("Time = %0t | opcode = %b | a = %b | b = %b | result = %b", $time, opcode, a, b, result);

        $display("===Starting Tests For Logic Unit");
        //Test Edge Cases 1: OR Operation (opcode = 00):
        $display("Testing Edge cases for OR (00)");
          //All Zero:
        #10;
        opcode = 2'b00;
        a= 8'b0000_0000;
        b= 8'b0000_0000;
        //Expected Result: 0000_0000


          //All One:
        #10;
        opcode = 2'b00;
        a = 8'b1111_1111;
        b = 8'b1111_1111;
        //Expected Result: 1111_1111


        //Test Edge Cases 2: AND Operation (opcode = 01):
        #10;
        $display("Testing Edge cases for AND (01)");
         //All Zero:
        opcode = 2'b01;
        a= 8'b0000_0000;
        b= 8'b0000_0000;
        //Expected Result: 0000_0000

          //All One:
        #10;
        opcode = 2'b01;
        a = 8'b1111_1111;
        b = 8'b1111_1111;
        //Expected Result: 1111_1111

        
        //Test Edge Cases 3: XOR Operation (opcode = 10)
        #10;
        $display("Testing Edge cases for XOR (10)");
          //All Zero:
        opcode = 2'b10;
        a= 8'b0000_0000;
        b= 8'b0000_0000;
        //Expected Result: 0000_0000

          //All One:
        #10;
        opcode = 2'b10;
        a = 8'b1111_1111;
        b = 8'b1111_1111;
        //Expected Result: 0000_0000


        $display("=== Starting Automated Verification for Logic_Unit ===");

        //verification block for OR:
        $display("Starting Randomized OR Tests:");
        opcode = 2'b00;
        for (int i = 0 ;i<100 ;i++ ) begin
            a = $urandom();
            b = $urandom();
            #10;
            if (result !== (a|b)) begin
                $display("ERROR at OR: a = %b , b = %b | Expected: %b, Got: %b", a, b, (a|b), result);
            end

        end

        //Verification block for AND:
        $display("Starting Randomized AND Tests:");
        opcode = 2'b01;
        for (int i = 0 ;i<100 ;i++ ) begin
            a = $urandom();
            b = $urandom();
            #10;
            if (result !== (a&b)) begin
                $display("ERROR at AND: a = %b , b = %b | Expected: %b, Got: %b", a, b, (a&b), result);
            end

        end

        //Verification block for XOR:
         $display("Starting Randomized XOR Tests:");
          opcode = 2'b10;
          for (int i = 0 ;i<100 ;i++ ) begin
            a = $urandom();
            b = $urandom();
            #10;
            if (result !== (a^b)) begin
                $display("ERROR at XOR: a = %b , b = %b | Expected: %b, Got: %b", a, b, (a^b), result);
            end

        end

        // End of Simulation
        #10;
        $display("=== Logic_Unit Automated Tests Completed ===");
        $finish;
    end
endmodule


        


        




  