module alu_74181_logic (a, b, s, f);

  input logic [3:0] a, b, s;
  output logic [3:0] f;
  
  // Function types
  typedef enum logic [3:0] {
    FUNC_00, FUNC_01, FUNC_02, FUNC_03, FUNC_04, FUNC_05, FUNC_06, FUNC_07, FUNC_08, FUNC_09, FUNC_10, FUNC_11, FUNC_12, FUNC_13, FUNC_14, FUNC_15
  } func_type;

  // Auxiliar variables
  func_type func; 
  logic [3:0] temp;

  // Function selector
  assign func = func_type'(s);

  // Outputs
  assign f = temp;

  // Implement logical operation based on selection
  always_comb begin

    case (func)
      
      FUNC_00 : begin
        temp = ~a;
      end

      FUNC_01 : begin
        temp = ~(a | b);
      end

      FUNC_02 : begin
        temp = (~a) & b;
      end

      FUNC_03 : begin
        temp = '0;
      end
      
      FUNC_04 : begin
        temp = ~(a & b);
      end

      FUNC_05 : begin
        temp = (~b);
      end

      FUNC_06 : begin
        temp = a ^ b;
      end

      FUNC_07 : begin
        temp = a & (~b);
      end

      FUNC_08 : begin
        temp = (~a) | b;
      end

      FUNC_09 : begin
        temp = ~(a ^ b);
      end

      FUNC_10 : begin
        temp = b;
      end

      FUNC_11 : begin
        temp = a & b;
      end

      FUNC_12 : begin
        temp = '1;
      end

      FUNC_13 : begin
        temp = a | (~b);
      end

      FUNC_14 : begin
        temp = a | b;
      end

      FUNC_15 : begin
        temp = a;
      end

    endcase

  end

endmodule
