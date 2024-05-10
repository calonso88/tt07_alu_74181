/*
 * Copyright (c) 2024 Caio Alonso da Costa
 * SPDX-License-Identifier: Apache-2.0
 */

module mux6x1 (sel, a, b, c, d, e, f, dout);

  input logic [2:0] sel;
  input logic [3:0] a, b, c, d, e, f;
  output logic [3:0] dout;
  
  // Implement logical operation based on selection
  always_comb begin

    case (sel)
      
      3'b000: begin
        dout = a;
      end

      3'b001: begin
        dout = b;
      end

      3'b010: begin
        dout = c;
      end

      3'b011: begin
        dout = d;
      end
      
      3'b100: begin
        dout = e;
      end

      3'b101: begin
        dout = f;
      end

      default : begin
        dout = '0;
      end
      
    endcase

  end

endmodule
