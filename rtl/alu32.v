`timescale 1ns/1ps

module alu32 (
    input wire clk,
    input wire rst,
    input wire valid_in,
    input wire [31:0] a, b,
    input wire [2:0] op,
    output reg [31:0] result,
    output reg valid_out
);

    wire [31:0] next_result;

    assign next_result =
        (op == 3'd0) ? (a + b) :
        (op == 3'd1) ? (a - b) :
        (op == 3'd2) ? (a & b) :
        (op == 3'd3) ? (a | b) :
        (op == 3'd4) ? (a ^ b) :
        (op == 3'd5) ? (a << b[4:0]) :
        (op == 3'd6) ? (a >> b[4:0]) :
        (op == 3'd7) ?
            (($signed(a) < $signed(b)) ? 32'd1 : 32'd0) :
        32'd0;

    always @(posedge clk) begin
        if (rst) begin
            result <= 32'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= valid_in;
            if (valid_in)
                result <= next_result;
        end
    end

endmodule
