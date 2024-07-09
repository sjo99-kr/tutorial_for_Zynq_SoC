`timescale 1ns / 1ps


module UserTop(
    input [14:0] DDR_addr,
    input [2:0] DDR_ba,
    input DDR_cas_n,
    input DDR_ck_n,
    input DDR_ck_p,
    input DDR_cke,
    input DDR_cs_n,
    input  [3:0] DDR_dm,
    input  [31:0] DDR_dq,
    input  [3:0] DDR_dqs_n,
    input DDR_odt,
    input DDR_ras_n,
    input DDR_reset_n,
    input DDR_we_n,
    input FIXED_IO_ddr_vrn,
    input FIXED_IO_ddr_vrp,
    input [53:0] FIXED_IO_mio,
    input FIXED_IO,ps_clk,
    input FIXED_IO_ps_porb,
    input FIXED_IO_ps_srstb
    );
    wire [14:0] DDR_addr;
    wire [2:0] DDR_ba;
    wire DDR_cas_n;
    wire DDR_ck_n;
    wire DDR_ck_p;
    wire DDR_cke;
    wire DDR_cs_n;
    wire  [3:0] DDR_dm;
    wire  [31:0] DDR_dq;
    wire  [3:0] DDR_dqs_n;
    wire DDR_odt;
    wire DDR_ras_n;
    wire DDR_reset_n;
    wire DDR_we_n;
    wire FIXED_IO_ddr_vrn;
    wire FIXED_IO_ddr_vrp;
    wire [53:0] FIXED_IO_mio;
    wire FIXED_IO,ps_clk;
    wire FIXED_IO_ps_porb;
    wire FIXED_IO_ps_srstb;
    
    wire [12:0] spram0_addr;
    wire spram0_clk;
    wire [31:0] spram0_din;
    wire [31:0] spram0_dout;
    wire spram0_en;
    wire spram0_rst;
    wire [3:0] spram0_we;
    
    main_wrapper main_wrapper(
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srwstb),
        .sparm0_addr(spram0_addr),
        .sparm0_clk(spram0_clk),
        .sparm0_din(spram0_din),
        .sparm0_dout(spram0_dout),
        .sparm0_en(spram0_en),
        .sparm0_rst(spram0_rst),
        .sparm0_we(spram0_we)
    );
    wire rsta_busy;
    spram_8192x32 spram8192x32(
        .clka (spram0_clk),
        .rsta(spram0_rst),
        .ena(spram0_en),
        .wea(spram0_we),
        .addra(spram0_addr),
        .dina(spram0_din),
        .douta(spram0_dout),
        .rsta_busy(rsta_busy)
    );

endmodule
