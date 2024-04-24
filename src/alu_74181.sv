module alu_74181 (a, b, cn, s, m, f, cn4, equal, p, g);

  input logic [3:0] a, b, s;
  input logic cn, m;
  output logic [3:0] f;
  output logic cn4, equal, p, g;

  assign f = '0;
  assign cn4 = '0;
  assign equal = '0;
  assign p = '0;
  assign g = '0;

endmodule
