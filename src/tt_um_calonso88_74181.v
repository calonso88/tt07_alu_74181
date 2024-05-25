/*
 * Copyright (c) 2024 Caio Alonso da Costa
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_calonso88_74181 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // SPI Auxiliars
  wire spi_cs_n;
  wire spi_clk;
  wire spi_miso;
  wire spi_mosi;
  wire cpol;
  wire cpha;
    
  // Sync'ed
  wire spi_cs_n_sync;
  wire spi_clk_sync;
  wire spi_mosi_sync;
  wire cpol_sync;
  wire cpha_sync;

  // Bi direction IOs [6:4] as inputs
  assign uio_oe[6:4] = 3'b000;
  // Bi direction IOs [7] and [3:0] as outputs
  assign uio_oe[7]   = 1'b1;
  assign uio_oe[3:0] = 4'b1111;

  // Input ports
  assign cpol      = ui_in[0];
  assign cpha      = ui_in[1];
  assign spi_cs_n  = uio_in[4];
  assign spi_clk   = uio_in[5];
  assign spi_mosi  = uio_in[6];

  // MISO Output port
  assign uio_out[3] = spi_miso;
  // Unused ouputs needs to be assigned to 0.
  assign uio_out[2:0] = 3'b000;
  assign uio_out[7:4] = 4'b0000;

  // Number of stages in each synchronizer
  localparam int SYNC_STAGES = 2;
  localparam int SYNC_WIDTH = 1;

  // Synchronizers
  synchronizer #(.STAGES(SYNC_STAGES), .WIDTH(SYNC_WIDTH)) synchronizer_spi_cs_n_inst (.rstb(rst_n), .clk(clk), .ena(ena), .data_in(spi_cs_n), .data_out(spi_cs_n_sync));
  synchronizer #(.STAGES(SYNC_STAGES), .WIDTH(SYNC_WIDTH)) synchronizer_spi_clk_inst  (.rstb(rst_n), .clk(clk), .ena(ena), .data_in(spi_clk),  .data_out(spi_clk_sync));
  synchronizer #(.STAGES(SYNC_STAGES), .WIDTH(SYNC_WIDTH)) synchronizer_spi_mosi_inst (.rstb(rst_n), .clk(clk), .ena(ena), .data_in(spi_mosi), .data_out(spi_mosi_sync));
  synchronizer #(.STAGES(SYNC_STAGES), .WIDTH(SYNC_WIDTH)) synchronizer_spi_mode_cpol (.rstb(rst_n), .clk(clk), .ena(ena), .data_in(cpol), .data_out(cpol_sync));
  synchronizer #(.STAGES(SYNC_STAGES), .WIDTH(SYNC_WIDTH)) synchronizer_spi_mode_cpha (.rstb(rst_n), .clk(clk), .ena(ena), .data_in(cpha), .data_out(cpha_sync));

  // Amount of CFG Regs and Status Regs + Regs Width
  localparam int NUM_CFG = 8;
  localparam int NUM_STATUS = NUM_CFG;
  localparam int REG_WIDTH = 8;

  // Config Regs and Status Regs
  wire [NUM_CFG*REG_WIDTH-1:0] config_regs;
  wire [NUM_STATUS*REG_WIDTH-1:0] status_regs;

  // Auxiliar mapping signals
  wire [15:0] a, b;
  wire [3:0] s;
  wire c_in0, m, c_out0, c_out1, c_out2, c_out3, equal0, p0, g0, equal1, p1, g1, equal2, p2, g2, equal3, p3, g3;
  wire [15:0] f;
  wire [2:0] decod_sel;
  wire [3:0] bin, bin0, bin1;
  wire [7:0] decod;
  wire [7:0] decod_reg;
  
  // Assign config regs
  assign a[7:0] = config_regs[7:0];    // [0][7:0]
  assign b[7:0] = config_regs[15:8];   // [1][7:0]
  assign s = config_regs[19:16];  // [2][3:0]
  assign m = config_regs[20];     // [2][4]
  assign c_in0 = config_regs[21]; // [2][5]
                                  // [2][7:6] unused
  assign decod_sel = config_regs[27:24]; // [3][3:0]
  assign a[15:8] = config_regs[39:32]; // [4][7:0]
  assign b[15:8] = config_regs[47:40]; // [5][7:0]

  // Assign status regs
  assign status_regs[7:0]   = f[7:0]; // [0][7:0]
  assign status_regs[15:8]  = {c_out0, equal0, p0, g0, c_out1, equal1, p1, g1}; // [1][7:0]
  assign status_regs[19:16] = bin0; // [2][3:0]
  assign status_regs[23:20] = bin1; // [2][7:4]
  assign status_regs[31:24] = decod; // [3][7:0]
  assign status_regs[39:32] = 8'hC4;
  assign status_regs[47:40] = 8'h10;
  assign status_regs[55:48] = f[15:8];
  assign status_regs[63:56] = {c_out2, equal2, p2, g2, c_out3, equal3, p3, g3}; // [7][7:0]

  // SPI wrapper
  spi_wrapper #(.NUM_CFG(NUM_CFG), .NUM_STATUS(NUM_STATUS), .REG_WIDTH(REG_WIDTH)) spi_wrapper_i (.rstb(rst_n), .clk(clk), .ena(ena), .mode({cpol_sync, cpha_sync}), .spi_cs_n(spi_cs_n_sync), .spi_clk(spi_clk_sync), .spi_mosi(spi_mosi_sync), .spi_miso(spi_miso), .config_regs(config_regs), .status_regs(status_regs));

  // 74181 ALU
  alu_74181 alu_74181_i0 (.a(a[3:0]),   .b(b[3:0]),   .cn(c_in0),  .s(s), .m(m), .f(f[3:0]),   .cn4(c_out0), .equal(equal0), .p(p0), .g(g0));
  alu_74181 alu_74181_i1 (.a(a[7:4]),   .b(b[7:4]),   .cn(c_out0), .s(s), .m(m), .f(f[7:4]),   .cn4(c_out1), .equal(equal1), .p(p1), .g(g1));
  alu_74181 alu_74181_i2 (.a(a[11:8]),  .b(b[11:8]),  .cn(c_out1), .s(s), .m(m), .f(f[11:8]),  .cn4(c_out2), .equal(equal2), .p(p2), .g(g2));
  alu_74181 alu_74181_i3 (.a(a[15:12]), .b(b[15:12]), .cn(c_out2), .s(s), .m(m), .f(f[15:12]), .cn4(c_out3), .equal(equal3), .p(p3), .g(g3));

  // Mux for 7seg display
  mux6x1 mux6x1_i0 (.sel(decod_sel), .a(a[3:0]),  .b(a[7:4]),   .c(b[3:0]),  .d(b[7:4]),   .e(f[3:0]),  .f(f[7:4]),   .dout(bin0));
  mux6x1 mux6x1_i1 (.sel(decod_sel), .a(a[11:8]), .b(a[15:12]), .c(b[11:8]), .d(b[15:12]), .e(f[11:8]), .f(f[15:12]), .dout(bin1));
  assign bin = decod_sel[3] ? bin1 : bin0;

  // Binary to 7 segments display decoder
  bin_to_7seg_decoder bin_to_7seg_decoder_inst (.bin(bin), .a(decod[0]), .b(decod[1]), .c(decod[2]), .d(decod[3]), .e(decod[4]), .f(decod[5]), .g(decod[6]), .dp(decod[7]));

  // Reclocking output of bin_to_7seg_decoder
  reclocking #(.WIDTH(REG_WIDTH)) reclocking_7seg (.rstb(rst_n), .clk(clk), .ena(ena), .data_in(decod), .data_out(decod_reg));

  // Drive 7 segments display
  assign uo_out  = decod_reg;

endmodule
