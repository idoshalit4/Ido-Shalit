`timescale 1ns/1ps

`include "ALU.v"

module ALU_tb_sv; 
    //inputs:
    logic [7:0] a;
    logic [7:0] b;
    logic [2:0] OpCode;

    //outputs:
    logic [7:0] result;
    logic Carry_Flag;
    logic Zero_Flag;

    ///
    logic [8:0] calc_temp;
    logic [7:0] exp_result;
    logic exp_carry;
    logic exp_zero;

    //DUT:
    ALU dut(
        .a(a),
        .b(b),
        .OpCode(OpCode),
        .result(result),
        .Carry_Flag(Carry_Flag),
        .Zero_Flag(Zero_Flag)
    );

    // stimulus block:
    initial begin
        // system reset:
        a = 8'b0;
        b = 8'b0;
        OpCode = 3'b000;

        $monitor ("Time = %0t | OpCode = %b | a = %b | b = %b | result = %b | Carry_Flag = %b | Zero_Flag = %b ",
        $time, OpCode, a, b, result, Carry_Flag, Zero_Flag);

        $display("== Starting Tests For ALU ==");
        $display("== Starting Basic Sanity Checks for ALU ==");
        
        //Manual check 1: ADD (Checking Zero Flag)
        #10;
        a = 8'b0000_0000;
        b = 8'b0000_0000;
        OpCode = 3'b000;
        #1;
        //Expected Result: sum = 0000_0000, Carry_Flag = 0, Zero_Flag = 1
        if (result !== (a+b) || Zero_Flag !== 1'b1 || Carry_Flag !== 1'b0) begin
            $display("ERROR In Manual Check 1: Expected: result = %b, Zero_Flag = %b, Carry_Flag = %b | Got: result = %b, Zero_Flag = %b, Carry_Flag = %b",
            (a+b), 1'b1, 1'b0, result, Zero_Flag, Carry_Flag);
        end
        
        //Manual Check 2: SUB (Negative Result)
        #10;
        a = 8'b0000_0000;
        b = 8'b0000_0001;
        OpCode = 3'b001;
        #1;
        if (result !== (a-b) || Zero_Flag !== 1'b0 || Carry_Flag !== 1'b1) begin
            $display("ERROR In Manual Check 2: Expected: result = %b, Zero_Flag = %b, Carry_Flag = %b | Got: result = %b, Zero_Flag = %b, Carry_Flag = %b",
            (a-b), 1'b0, 1'b1, result, Zero_Flag, Carry_Flag);
        end
        
        //Manual Check 3: Right Shift
        #10;
        a = 8'b0000_0001;
        b = 8'b0000_0000; // b doesn't matter for shifter in this architecture
        OpCode = 3'b010;
        #1;
        if (result !== (a>>1) || Carry_Flag !== a[0] || Zero_Flag !== 1'b1) begin
             $display("ERROR In Manual Check 3: Expected: result = %b, Zero_Flag = %b, Carry_Flag = %b | Got: result = %b, Zero_Flag = %b, Carry_Flag = %b",
            (a>>1), 1'b1, 1'b1, result, Zero_Flag, Carry_Flag);
        end

        //Manual Check 4: XOR
        #10;
        a = 8'b1010_1010;
        b = 8'b1010_1010;
        OpCode = 3'b110;
        #1;
        if (result !== (a^b) || Zero_Flag !== 1'b1) begin
             $display("ERROR In Manual Check 4: Expected: result = %b, Zero_Flag = %b, Carry_Flag = %b | Got: result = %b, Zero_Flag = %b, Carry_Flag = %b",
            (a^b), 1'b1, 1'b0, result, Zero_Flag, Carry_Flag);
        end

        $display("=== Starting 500 Automated Randomized Verification For ALU ===");

        for (int i = 0; i<500 ;i++ ) begin
            a = $urandom();
            b = $urandom();
            OpCode = $urandom_range(0,7);

            #10;

            case (OpCode)
                3'b000: begin
                    calc_temp = a+b;
                    exp_result = calc_temp[7:0];
                    exp_carry = calc_temp[8];
                end

                3'b001: begin // Substraction
                    calc_temp = (a - b);
                    exp_result = calc_temp[7:0];
                    exp_carry = calc_temp[8];
                end
                
                3'b010: begin //Right Shift
                    exp_result = a>>1;
                    exp_carry = a[0];
                end
                
                3'b011: begin //Left Shift
                    exp_result = a<<1;
                    exp_carry = a[7];
                end

                3'b100: begin //OR
                    exp_result = a | b ;
                    exp_carry = 1'b0;
                end

                3'b101: begin //AND
                    exp_result = a & b ;
                    exp_carry = 1'b0 ;
                end

                3'b110: begin //XOR
                    exp_result = a^b;
                    exp_carry = 1'b0;
                end

                3'b111: begin //Default
                    exp_result = 8'b0;
                    exp_carry = 1'b0;
                end
            endcase

            // Software calculation for Zero Flag (universally true for all opcodes)
            exp_zero = (exp_result == 8'b0) ? 1'b1 : 1'b0;

            // --- Hardware vs Software Comparison ---
            if (result !== exp_result || Carry_Flag !== exp_carry || Zero_Flag !== exp_zero) begin
                $display("ERROR at OpCode %b: a = %b, b = %b", OpCode, a, b);
                $display("  Expected: result = %b, Carry = %b, Zero = %b", exp_result, exp_carry, exp_zero);
                $display("  Got     : result = %b, Carry = %b, Zero = %b", result, Carry_Flag, Zero_Flag);
            end 
        end
        // End Of Simulation
        #10;
        $display("=== ALU Automated Tests Completed ===");
        $finish;
    
    end
    
endmodule
