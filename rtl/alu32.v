// Original educational RTL. Synchronous active-high reset.
module alu32 (
    input wire clk,
    input wire rst,
    input wire valid_in,
    input wire [31:0] a, b,
    input wire [2:0] op,
    output reg [31:0] result,
    output reg valid_out
);
    reg [31:0] next_result;
    always @* begin
        case (op)
            3'd0: next_result = a + b;
            3'd1: next_result = a - b;
            3'd2: next_result = a & b;
            3'd3: next_result = a | b;
            3'd4: next_result = a ^ b;
            3'd5: next_result = a << b[4:0];
            3'd6: next_result = a >> b[4:0];
            3'd7: next_result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            default: next_result = 32'd0;
        endcase
    end
    always @(posedge clk) begin
        if (rst) begin
            result <= 32'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= valid_in;
            if (valid_in) result <= next_result;
        end
    end
endmodule
