`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2024 08:45:57 PM
// Design Name: 
// Module Name: counter_Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module counter_Top(
    input axi_clk,
    input axi_reset_n,
    // slave interface
    input i_data_valid,
    input [31:0] i_data,
    output o_data_ready,
    
    //master interface
    output [31:0] o_data,
    output o_data_valid,
    input i_data_ready,
    
    // interrupt
    output o_intr
    );
    
    wire [31:0] count_out;
    wire count_valid;
    wire axis_prog_full;
    assign o_data_ready = !axis_prog_full;
    
    counter count(
        .i_clk(axi_clk),
        .i_rst(axi_reset_n),
        .i_data(i_data),
        .i_data_valid(i_data_valid),
        
        .o_data(count_out),
        .o_data_valid(count_valid),
        .o_intr(o_intr)
    );
    
    outputBuffer OB(
    .wr_rst_busy(),
    .rd_rst_busy(),
    .s_aclk(axi_clk),
    .s_aresetn(axi_reset_n),
    .s_axis_tvalid(count_valid),
    .s_axis_tready(o_data_ready),
    .s_axis_tdata(count_out),
    .m_axis_tvalid(o_data_valid),
    .m_axis_tready(i_data_ready),
    .m_axis_tdata(o_data),
    .axis_prog_full(axis_prog_full)
  );
    
    
endmodule
