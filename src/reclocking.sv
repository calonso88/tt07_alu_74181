/*
 * Copyright (c) 2024 Caio Alonso da Costa
 * SPDX-License-Identifier: Apache-2.0
 */

module reclocking #(parameter int WIDTH = 4) (rstb, clk, ena, data_in, data_out);

  input logic rstb;
  input logic clk;
  input logic ena;
  input logic [WIDTH-1:0] data_in;

  output logic [WIDTH-1:0] data_out;

  logic [WIDTH-1:0] data_sync;

  always_ff @(negedge(rstb) or posedge(clk)) begin
    if (!rstb) begin
      data_sync <= '0;
    end else begin
      if (ena == 1'b1) begin
        data_sync <= data_in;
      end
    end
  end

  assign data_out = data_sync;

endmodule
