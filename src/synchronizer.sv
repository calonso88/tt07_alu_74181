/*
 * Copyright (c) 2024 Caio Alonso da Costa
 * SPDX-License-Identifier: Apache-2.0
 */

module synchronizer #(parameter int WIDTH = 4) (rstb, clk, ena, data_in, data_out);

  input logic rstb;
  input logic clk;
  input logic ena;
  input logic [WIDTH-1:0] data_in;

  output logic [WIDTH-1:0] data_out;

  logic [WIDTH-1:0] data_sync;
  logic [WIDTH-1:0] data_sync2;

  reclocking reclocking_i0 #(.WIDTH(WIDTH)) (.rstb(rstb), .clk(clk), .ena(ena), .data_in(data_in), .data_out(data_sync));
  reclocking reclocking_i1 #(.WIDTH(WIDTH)) (.rstb(rstb), .clk(clk), .ena(ena), .data_in(data_sync), .data_out(data_sync2));

  assign data_out = data_sync2;

endmodule
