`timescale 1ns/1ps

module tb_alu;

    localparam int WIDTH = 8;

    logic [WIDTH-1:0] a;
    logic [WIDTH-1:0] b;
    logic [2:0] op;
    logic [WIDTH-1:0] y;
    logic zero;

    alu #(.WIDTH(WIDTH)) dut (
        .a(a),
        .b(b),
        .op(op),
        .y(y),
        .zero(zero)
    );

    task automatic check(
        input logic [WIDTH-1:0] test_a,
        input logic [WIDTH-1:0] test_b,
        input logic [2:0] test_op,
        input logic [WIDTH-1:0] expected_y
    );
        a = test_a;
        b = test_b;
        op = test_op;
        #1;

        if (y !== expected_y) begin
            $error(
                "a=%0d b=%0d op=%b expected=%0d got=%0d",
                a, b, op, expected_y, y
            );
            $finish;
        end

        if (zero !== (expected_y == '0)) begin
            $error("zero flag incorrect");
            $finish;
        end
    endtask

    initial begin
        check(8'd10, 8'd3, 3'b000, 8'd13);
        check(8'd10, 8'd3, 3'b001, 8'd7);
        check(8'hA5, 8'h3C, 3'b010, 8'h24);
        check(8'hA5, 8'h3C, 3'b011, 8'hBD);
        check(8'hA5, 8'h3C, 3'b100, 8'h99);
        check(8'd0, 8'd99, 3'b101, 8'd0);
        check(8'd10, 8'd3, 3'b110, 8'd3);
        check(8'd10, 8'd3, 3'b111, 8'd0);

        $display("PASS: ALU test");
        $finish;
    end

endmodule
