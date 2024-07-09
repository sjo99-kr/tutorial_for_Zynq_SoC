`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2024 10:56:34 PM
// Design Name: 
// Module Name: Systolic_4x4_Top
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


module Systolic_4x4_Top(
    input axi_clk,
    input axi_rst,
    
    //slave port (s_axis)
    input [31:0] s_axis_data,
    input s_axis_valid,
    output s_axis_ready,
    
    //master port (m_axis)
    output [31:0] m_axis_data,
    output m_axis_valid,
    input m_axis_ready,
    
    // interrupt
    output o_intr
    );
    reg mmu_buffer_valid;
    reg [4:0] valid_count;
    
    wire axis_prog_full;
    wire [31:0] col1, col2, col3, col4;
    wire [31:0] row1, row2, row3, row4;
    wire buffer_valid;
    
    wire [127:0] mmu_out;
    
    reg mmu_valid;
    assign s_axis_ready = !axis_prog_full;
    
    Matrix_Buffer MB( 
        .i_clk(axi_clk),
        .i_rst(axi_rst),
        
        // s_axis interface
        .i_data(s_axis_data),
        .i_data_valid(s_axis_valid),
        .row1(row1), .row2(row2), .row3(row3), .row4(row4),
        .col1(col1), .col2(col2), .col3(col3), .col4(col4),
        .o_intr(o_intr),
        .o_data_valid(buffer_valid)
        );
        
    MMU_4x4 MMU(
        .i_clk(axi_clk),
        .i_rst(axi_rst),
        .in_valid(buffer_valid),
        .col1_in(col1), .col2_in(col2), .col3_in(col3), .col4_in(col4),
        .row1_in(row1), .row2_in(row2), .row3_in(row3), .row4_in(row4),
        
        .out_data(mmu_out)
    );
    

    
    mmu_buffer(
        .wr_rst_busy(),
        .rd_rst_busy(),
        .s_aclk(axi_clk),
        .s_aresetn(axi_rst),
        .s_axis_tvalid(
    
    
    )
    
    

        
endmodule
