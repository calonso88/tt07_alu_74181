module alu_74181 (a, b, cn, s, m, f, cn4, equal, p, g);

  input logic [3:0] a, b, s;
  input logic cn, m;
  output logic [3:0] f;
  output logic cn4, equal, p, g;

  // Auxiliar signals
  logic [3:0] f_logic;

  // Instance for logic operations
  alu_74181_logic alu_74181_logic_inst (.a(a), .b(b), .s(s), .f(f_logic));

  // Outputs
  assign f = f_logic;
  assign cn4 = '0;
  assign equal = '0;
  assign p = '0;
  assign g = '0;

endmodule
