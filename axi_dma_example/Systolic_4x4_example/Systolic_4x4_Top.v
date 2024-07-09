`timescale 1ns / 1ps

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

    
    wire axis_prog_full;
    wire [31:0] col1, col2, col3, col4;
    wire [31:0] row1, row2, row3, row4;
    wire buffer_valid;
    
    wire [31:0] mmu_out1, mmu_out2, mmu_out3, mmu_out4;
    wire mmu_valid1, mmu_valid2, mmu_valid3, mmu_valid4;
    
    reg mmu_valid;
    
    wire [31:0] accum_out;
    wire accum_out_valid;
    
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
        
        .o_data1(mmu_out1), .o_data2(mmu_out2), .o_data3(mmu_out3), .o_data4(mmu_out4),
        .o_valid1(mmu_valid1), .o_valid2(mmu_valid2), .o_valid3(mmu_valid3), .o_valid4(mmu_valid4)
    );
    
    
    
    
    accumulate_buffer accum_buffer(
        .i_clk(axi_clk),
        .i_rst(axi_rst),
        .i_data1(mmu_out1),
        .i_data2(mmu_out2),
        .i_data3(mmu_out3),
        .i_data4(mmu_out4),
        
        .i_valid1(mmu_valid1),
        .i_valid2(mmu_valid2),
        .i_valid3(mmu_valid3),
        .i_valid4(mmu_valid4),
        
        .o_data(accum_out),
        .o_valid(accum_out_valid)
    );
    
    fifo_generator_0 Stream_Buffer(
        .wr_rst_busy(),        // output wire wr_rst_busy
        .rd_rst_busy(),        // output wire rd_rst_busy
        .s_aclk(axi_clk),                  // input wire s_aclk
        .s_aresetn(axi_rst),            // input wire s_aresetn
        .s_axis_tvalid(accum_out_valid),    // input wire s_axis_tvalid
        .s_axis_tready(),    // output wire s_axis_tready
        .s_axis_tdata(accum_out),     
       
        .m_axis_tvalid(m_axis_valid),    
        .m_axis_tready(m_axis_ready),   
        .m_axis_tdata(m_axis_data),      
        .axis_prog_full(axis_prog_full)
    
    
    );
         
endmodule
