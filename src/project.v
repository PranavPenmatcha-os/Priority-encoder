/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none
module tt_um_priority_encoder (
    input  wire [7:0] ui_in,    // A[7:0]
    output reg  [7:0] uo_out,   // C[7:0]
    input  wire [7:0] uio_in,   // B[7:0]
    output wire [7:0] uio_out,  // Unused
    output wire [7:0] uio_oe,   // Unused
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    // Changed output type to "reg" since it's assigned in an always block
    
    always @(*)
    begin
        if (ui_in[7] == 1) uo_out = 8'h15;
        else if(ui_in[6] == 1) uo_out = 8'h14;
        else if(ui_in[5] == 1) uo_out = 8'h13;
        else if(ui_in[4] == 1) uo_out = 8'h12;
        else if(ui_in[3] == 1) uo_out = 8'h11;
        else if(ui_in[2] == 1) uo_out = 8'h10;
        else if(ui_in[1] == 1) uo_out = 8'h09;
        else if(ui_in[0] == 1) uo_out = 8'h08;
        else if(uio_in[7] == 1) uo_out = 8'h07; // Fixed index (was uio_in[6])
        else if(uio_in[6] == 1) uo_out = 8'h06;
        else if(uio_in[5] == 1) uo_out = 8'h05; // Fixed value (was duplicate [6])
        else if(uio_in[4] == 1) uo_out = 8'h04;
        else if(uio_in[3] == 1) uo_out = 8'h03;
        else if(uio_in[2] == 1) uo_out = 8'h02;
        else if(uio_in[1] == 1) uo_out = 8'h01;
        else if(uio_in[0] == 1) uo_out = 8'h00; // Added missing check for uio_in[0]
        else
            uo_out = 8'hF0; // Fixed literal (was 8b'11110000)
    end

    // Fixed continuous assignment syntax
    assign uio_oe = 8'h00;
    assign uio_out = 8'h00; // Added missing assignment for uio_out
endmodule
