module alu_74181_arith (a, b, s, cn, f, cn4);

  input logic [3:0] a, b, s;
  input logic cn;
  output logic [3:0] f;
  output logic cn4;

  // Auxiliar variable
  logic [4:0] temp;
  logic [4:0] temp_cn;

  // Add carry
  assign temp_cn = temp + cn;

  // Outputs
  assign f = cn ? temp_cn[3:0] : temp[3:0];
  assign cn4 = cn ? temp_cn[4] : temp[4];
  
  // Implement arithmetical operation based on selection
  always_comb begin

    case (s)
      
      4'b0000: begin
        temp = a;
      end

      4'b0001 : begin
        temp = a | b;
      end

      4'b0010 : begin
        temp = a | (~b);
      end

      4'b0011 : begin
        temp = '1;
      end
      
      4'b0100 : begin
        temp = a + (a & (~b));
      end

      4'b0101 : begin
        temp = (a | b) + (a & (~b));
      end

      4'b0110 : begin
        temp = a - b - 1'b1;
      end

      4'b0111 : begin
        temp = (a & (~b)) - 1'b1;
      end

      4'b1000 : begin
        temp = a + (a & b);
      end

      4'b1001 : begin
        temp = a + b;
      end

      4'b1010 : begin
        temp = (a | (~b)) + (a & b);
      end

      4'b1011 : begin
        temp = (a & b) - 1'b1;
      end

      4'b1100 : begin
        temp = a + a;
      end

      4'b1101 : begin
        temp = (a | b) + a;
      end

      4'b1110 : begin
        temp = (a | (~b)) + a;
      end

      4'b1111 : begin
        temp = a - 1'b1;
      end

      default : begin
        temp = '0;
      end
      
    endcase

  end

endmodule
