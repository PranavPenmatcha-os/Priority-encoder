/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_priority_encoder (
    input  wire [7:0] ui_in,    // A[7:0]
    output wire [7:0] uo_out,   // C[7:0]
    input  wire [7:0] uio_in,   // B[7:0]
    output wire [7:0] uio_out,  // Unused
    output wire [7:0] uio_oe,   // Unused
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    always @ (*)
        begin
            if (ui_in[7] == 1) uo_out = 8b'15;
            else if(ui_in[6] == 1) uo_out = 8b'14;
            else if(ui_in[5] == 1) uo_out = 8b'13;
            else if(ui_in[4] == 1) uo_out = 8b'12;
            else if(ui_in[3] == 1) uo_out = 8b'11;
            else if(ui_in[2] == 1) uo_out = 8b'10;
            else if(ui_in[1] == 1) uo_out = 8b'9;
            else if(ui_in[0] == 1) uo_out = 8b'8;
            else if(uio_in[6] == 1) uo_out = 8b'7;
            else if(uio_in[5] == 1) uo_out = 8b'6;
            else if(uio_in[6] == 1) uo_out = 8b'5;
            else if(uio_in[4] == 1) uo_out = 8b'4;
            else if(uio_in[3] == 1) uo_out = 8b'3;
            else if(uio_in[2] == 1) uo_out = 8b'2;
            else if(uio_in[1] == 1) uo_out = 8b'1;
            else
                uo_out = 8b'11110000 // special case

    always uio_oe = 0;

endmodule
