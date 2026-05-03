`timescale 1ns / 1ps

module bitwisexor_tb ();

    logic [7:0] a, b;
    logic [7:0] result;

    Bit_Wise_Xor dut(
        .a(a),
        .b(b),
        .result(result)
    );

    initial begin
       
        $dumpfile("waveform.vcd");
        $dumpvars(0, bitwisexor_tb); 

        a = 8'd0;
        b = 8'd0;

        $display("starting bitwise xor simulation");

        #10;

        a = 8'd5;
        b = 8'd4;

        #10;

        $display("time=%0t | a=%d, b=%d | result= %b", $time, a, b, result);
        $display("\nsimulation complete.");
        #10 $finish;
    end
    
endmodule