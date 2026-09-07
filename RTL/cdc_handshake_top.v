`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project   : CDC Handshake
// Module    : cdc_handshake_top
// Description:
//   Top-level module connecting the source and destination
//   clock domains for CDC data transfer.
//
// Author    : Niharika Naik
//////////////////////////////////////////////////////////////////////////////////

module cdc_handshake_top (
    input clk_A,
    input rst_A,
    input clk_B,
    input rst_B,
    input start,
    input [7:0] data_A,
    output [7:0] data_B
);

    wire req_A;
    wire ack_B;
    wire [7:0] data_hold;

  cdc_source DUT_A (
        .clk_A(clk_A),
        .rst_A(rst_A),
        .start(start),
        .ack_B(ack_B),
        .data_A(data_A),
        .req_A(req_A),
        .data_hold(data_hold)
    );

cdc_destination DUT_B (
        .clk_B(clk_B),
        .rst_B(rst_B),
        .req_A(req_A),
        .data_hold(data_hold),
        .ack_B(ack_B),
        .data_B(data_B)
    );

endmodule