/*
 * Copyright (c) 2024 Caio Alonso da Costa
 * SPDX-License-Identifier: Apache-2.0
 */

module bin_to_7seg_decoder (bin, a, b, c, d, e, f, g, dp);

  input logic [3:0] bin;
  output logic a, b, c, d, e, f, g, dp;
  
  // Auxiliar signals
  logic [7:0] temp;

  // Outputs
  assign a = temp[7];
  assign b = temp[6];
  assign c = temp[5];
  assign d = temp[4];
  assign e = temp[3];
  assign f = temp[2];
  assign g = temp[1];
  assign dp = temp[0];
  
  // Implement logical operation based on selection
  always_comb begin

    case (bin)
      
      4'b0000: begin
        temp = 8'b11111100;
      end

      4'b0001 : begin
        temp = 8'b01100000;
      end

      4'b0010 : begin
        temp = 8'b11011010;
      end

      4'b0011 : begin
        temp = 8'b11110010;
      end
      
      4'b0100 : begin
        temp = 8'b01100110;
      end

      4'b0101 : begin
        temp = 8'b10110110;
      end

      4'b0110 : begin
        temp = 8'b10111110;
      end

      4'b0111 : begin
        temp = 8'b11100000;
      end

      4'b1000 : begin
        temp = 8'b11111110;
      end

      4'b1001 : begin
        temp = 8'b11100110;
      end

      4'b1010 : begin
        temp = 8'b11101110;
      end

      4'b1011 : begin
        temp = 8'b00111110;
      end

      4'b1100 : begin
        temp = 8'b10011100;
      end

      4'b1101 : begin
        temp = 8'b01111010;
      end

      4'b1110 : begin
        temp = 8'b10011110;
      end

      4'b1111 : begin
        temp = 8'b10001110;
      end

      default : begin
        temp = '0;
      end
      
    endcase

  end

endmodule
