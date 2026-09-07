`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project   : CDC Handshake
// Module    : cdc_handshake_tb
// Description:
//   Testbench for verifying CDC request/acknowledge
//   data transfer between asynchronous clock domains.
//
// Test Configuration:
//   Data Width = 8 bits
//   Clock A    = 10 ns period
//   Clock B    = 14 ns period
//
// Author    : Niharika Naik
//////////////////////////////////////////////////////////////////////////////////

module cdc_handshake_tb ;

    reg clk_A, clk_B;
    reg rst_A, rst_B;
    reg start;
    reg [7:0] data_A;

    wire [7:0] data_B;

    // DUT
 cdc_handshake_top DUT (
        .clk_A(clk_A),
        .rst_A(rst_A),
        .clk_B(clk_B),
        .rst_B(rst_B),
        .start(start),
        .data_A(data_A),
        .data_B(data_B)
    );

    // Clock A: 10 ns period
    always #5 clk_A = ~clk_A;

    // Clock B: 14 ns period
    always #7 clk_B = ~clk_B;

    initial begin

        // Initial values
        clk_A = 0;
        clk_B = 0;
        rst_A = 1;
        rst_B = 1;
        start = 0;
        data_A = 8'b0;

        // Reset
        #20;
        rst_A = 0;
        rst_B = 0;

        // Send data
        #10;
        data_A = 8'b10101010;
        start = 1;

        #10;
        start = 0;

        // Wait for transfer
        #150;

        $finish;
    end

endmodule