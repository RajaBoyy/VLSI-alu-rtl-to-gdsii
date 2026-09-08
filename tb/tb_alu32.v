`timescale 1ns/1ps
module tb_alu32;
    reg clk=0, rst=1, valid_in=0;
    reg [31:0] a=0, b=0;
    reg [2:0] op=0;
    wire [31:0] result;
    wire valid_out;
    reg [31:0] expected=0;
    integer i, j, count=0;
    alu32 dut(clk,rst,valid_in,a,b,op,result,valid_out);
    always #5 clk=~clk;
    function [31:0] reference;
        input [31:0] x,y;
        input [2:0] f;
        begin
            case(f)
                0: reference=x+y;
                1: reference=x-y;
                2: reference=x&y;
                3: reference=x|y;
                4: reference=x^y;
                5: reference=x << y[4:0];
                6: reference=x >> y[4:0];
                7: reference=($signed(x)<$signed(y));
            endcase
        end
    endfunction
    task check;
        input [31:0] x,y;
        input [2:0] f;
        input v,r;
        begin
            @(negedge clk);
            a=x; b=y; op=f; valid_in=v; rst=r;
            if(r) expected=0;
            else if(v) expected=reference(x,y,f);
            @(posedge clk); #1;
            if(result !== expected || valid_out !== (v & ~r)) begin
                $display("FAIL op=%0d a=%h b=%h expected=%h actual=%h", f,x,y,expected,result);
                $fatal(1);
            end
            count=count+1;
        end
    endtask
    initial begin
        check(0,0,0,0,1);
        for(j=0;j<8;j=j+1) begin
            check(0,0,j,1,0);
            check(32'hffffffff,1,j,1,0);
            check(32'h80000000,31,j,1,0);
            check(32'h7fffffff,32'hffffffff,j,1,0);
            check(32'h80000000,32,j,1,0);
            for(i=0;i<100;i=i+1) check($random,$random,j,1,0);
        end
        check(123,456,0,0,0); // Output holds across invalid cycle.
        check(123,456,0,1,1); // Reset overrides valid.
        check(1,2,0,1,0);    // Resume after reset.
        $display("PASS: %0d checked cycles",count);
        $finish;
    end
    initial begin #100000; $fatal(1,"Timeout"); end
endmodule
