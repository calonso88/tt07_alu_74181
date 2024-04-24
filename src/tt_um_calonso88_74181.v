/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_calonso88_74181 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Auxiliar mapping signals
  wire [3:0] a, b, s;
  wire cn, m;
  wire [3:0] f;
  wire cn4, equal, p, g;

  // Assign IOs as input
  assign uio_oe = '0;
  
  // Input ports
  assign a = ui_in[3:0];
  assign b = ui_in[7:4];
  assign s = uio_in[3:0];
  assign m = uio_in[4];
  assign cn = uio_in[5];

  // Output ports
  assign uo_out[3:0] = f;
  assign uo_out[4] = cn4;
  assign uo_out[5] = equal;
  assign uo_out[6] = p;
  assign uo_out[7] = g;
  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out = '0;

  // Instance
  alu_74181 alu_74181_inst (a, b, cn, s, m, f, cn4, equal, p, g);

endmodule
