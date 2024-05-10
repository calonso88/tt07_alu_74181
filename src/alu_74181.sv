/*
 * Copyright (c) 2024 Caio Alonso da Costa
 * SPDX-License-Identifier: Apache-2.0
 */

module alu_74181 (a, b, cn, s, m, f, cn4, equal, p, g);

  input logic [3:0] a, b, s;
  input logic cn, m;
  output logic [3:0] f;
  output logic cn4, equal, p, g;

  // Auxiliar signals
  logic [3:0] f_logic;
  logic [3:0] f_arith;

  // Instance for logic operations
  alu_74181_logic alu_74181_logic_inst (.a(a), .b(b), .s(s), .f(f_logic));
  // Instance for arithmetic operations
  alu_74181_arith alu_74181_arith_inst (.a(a), .b(b), .s(s), .cn(cn), .f(f_arith), .cn4(cn4));

  // Outputs
  assign f = m ? f_logic : f_arith;
  assign equal = (a === b) ? 1'b1 : 1'b0;
  assign p = '0;
  assign g = '0;

endmodule
