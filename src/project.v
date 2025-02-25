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

  wire [15:0] in_data = {ui_in, uio_in}; // Concatenating A[7:0] and B[7:0]
  reg  [7:0]  C;
  integer i;

  always @(*) begin
    C = 8'b1111_0000; // Default case when in_data is all 0s
    for (i = 15; i >= 0; i = i - 1) begin
      if (in_data[i]) begin
        C = i[7:0];
        break;
      end
    end
  end

  assign uo_out  = C; // Output C[7:0]
  assign uio_out = 8'b0000_0000; // Unused
  assign uio_oe  = 8'b0000_0000; // Unused

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
