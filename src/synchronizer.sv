module synchronizer #(parameter int WIDTH = 4) (rstb, clk, ena, data_in, data_out);

  input logic rstb;
  input logic clk;
  input logic ena;
  input logic [WIDTH-1:0] data_in;

  output logic [WIDTH-1:0] data_out;

  logic [WIDTH-1:0] data_sync;
  logic [WIDTH-1:0] data_sync2;

  always_ff @(negedge(rstb) or posedge(clk)) begin
    if (!rstb) begin
      data_sync <= '0;
      data_sync2 <= '0;
    end else begin
      if (ena == 1'b1) begin
        data_sync <= data_in;
        data_sync2 <= data_sync;
      end
    end
  end

  assign data_out = data_sync2;

endmodule
