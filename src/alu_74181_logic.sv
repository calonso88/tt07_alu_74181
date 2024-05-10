/*
 * Copyright (c) 2024 Caio Alonso da Costa
 * SPDX-License-Identifier: Apache-2.0
 */

module alu_74181_logic (a, b, s, f);

  input logic [3:0] a, b, s;
  output logic [3:0] f;
  
  // Auxiliar variable
  logic [3:0] temp;

  // Outputs
  assign f = temp;

  // Implement logical operation based on selection
  always_comb begin

    case (s)
      
      4'b0000: begin
        temp = ~a;
      end

      4'b0001 : begin
        temp = ~(a | b);
      end

      4'b0010 : begin
        temp = (~a) & b;
      end

      4'b0011 : begin
        temp = '0;
      end
      
      4'b0100 : begin
        temp = ~(a & b);
      end

      4'b0101 : begin
        temp = (~b);
      end

      4'b0110 : begin
        temp = a ^ b;
      end

      4'b0111 : begin
        temp = a & (~b);
      end

      4'b1000 : begin
        temp = (~a) | b;
      end

      4'b1001 : begin
        temp = ~(a ^ b);
      end

      4'b1010 : begin
        temp = b;
      end

      4'b1011 : begin
        temp = a & b;
      end

      4'b1100 : begin
        temp = '1;
      end

      4'b1101 : begin
        temp = a | (~b);
      end

      4'b1110 : begin
        temp = a | b;
      end

      4'b1111 : begin
        temp = a;
      end

      default : begin
        temp = '0;
      end
      
    endcase

  end

endmodule
