/*
 * Copyright (c) 2024 Caio Alonso da Costa
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
  wire [3:0] a_sync, b_sync, s_sync;
  wire cn_sync, m_sync;
  wire [3:0] f;
  wire cn4, equal;
  wire [7:0] decod;

  // Assign IOs [5:0] as input and IOs[7:6] as outputs
  assign uio_oe[5:0] = '0;
  assign uio_oe[7:6] = '1;
  
  // Input ports
  assign a = ui_in[3:0];
  assign b = ui_in[7:4];
  assign s = uio_in[3:0];
  assign m = uio_in[4];
  assign cn = uio_in[5];

  // Output ports
  assign uo_out[7:0] = decod;
  assign uio_out[6] = cn4;
  assign uio_out[7] = equal;
  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out[5:0] = '0;

  // Synchronizer instances
  synchronizer #(.WIDTH(4)) sync_a (.rstb(rst_n), .clk(clk), .ena(ena), .data_in(a), .data_out(a_sync));
  synchronizer #(.WIDTH(4)) sync_b (.rstb(rst_n), .clk(clk), .ena(ena), .data_in(b), .data_out(b_sync));
  synchronizer #(.WIDTH(4)) sync_s (.rstb(rst_n), .clk(clk), .ena(ena), .data_in(s), .data_out(s_sync));
  synchronizer #(.WIDTH(1)) sync_cn (.rstb(rst_n), .clk(clk), .ena(ena), .data_in(cn), .data_out(cn_sync));
  synchronizer #(.WIDTH(1)) sync_m (.rstb(rst_n), .clk(clk), .ena(ena), .data_in(m), .data_out(m_sync));
  
  // 74181 ALU
  alu_74181 alu_74181_inst (.a(a_sync), .b(b_sync), .cn(cn_sync), .s(s_sync), .m(m_sync), .f(f), .cn4(cn4), .equal(equal), .p(), .g());
  
  // Binary to 7 segments display decoder
  bin_to_7seg_decoder bin_to_7seg_decoder_inst (.bin(f), .a(decod[0]), .b(decod[1]), .c(decod[2]), .d(decod[3]), .e(decod[4]), .f(decod[5]), .g(decod[6]), .dp(decod[7]));

endmodule
