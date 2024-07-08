`timescale 1ns / 1ps

/******************************************************************************

Tutorial Materials for Embedded Software using Vitis IDE

Using Acumulator Custom Ip, Do AXI-DMA process

made by Seongwon Jo,


*******************************************************************************/

module accumulator_Top(
    input axi_clk,
    input axi_rst,
    // slave interface (s_axis interface)
    // in AXI_INTERFACE, there are 4 signals in master/slave ports
    // s_axis_valid(input) : it signals the received data is valid data to Custom IP
    // s_axis_data (input) : it signals the data that is from DMA  
    // s_axis_last (input) : it signals the received data is last data.
    // s_axis_ready (output) : it signals that Custom IP is ready for receive data, and send this signal to DMA
    input [31:0] s_axis_data,
    input s_axis_valid,
    input s_axis_last,
    output s_axis_ready,
    // master interace
    output [31:0] m_axis_data,
    output m_axis_valid,
    input m_axis_ready,
    
    //interrupt 
    output o_intr
    );
    
    wire [31:0] acc_out;
    wire acc_valid;
    wire axis_prog_full;
    
    assign s_axis_ready = !axis_prog_full;
    
    accumulator c1(
        .i_clk(axi_clk),
        .i_rst(axi_rst),
        .i_data(s_axis_data),
        .i_data_valid(s_axis_valid),
        .i_data_last(s_axis_last),
        
        .o_data(acc_out),
        .o_data_valid(acc_valid),
        .o_intr(o_intr)
    );

    // set AXI-Stream FIFO
    // axi-dma is interface between Memory Mapped I/O and Axi stream interface.
    // So we have to set AXI-STREAM FIFO for interfacing DMA.
    // if we want to send data from BRAM to DMA, we have to use cdma which is the interface between Memory Mapped I/O and Memory Mapped I/O
    fifo_generator_0 buffer(
        .wr_rst_busy(),        // output wire wr_rst_busy
       .rd_rst_busy(),        // output wire rd_rst_busy
       .s_aclk(axi_clk),                  // input wire s_aclk
       .s_aresetn(axi_rst),            // input wire s_aresetn
       .s_axis_tvalid(acc_valid),    // input wire s_axis_tvalid
       .s_axis_tready(),    // output wire s_axis_tready
       .s_axis_tdata(acc_out),      // input wire [7 : 0] s_axis_tdata
       
       .m_axis_tvalid(m_axis_valid),    // output wire m_axis_tvalid
       .m_axis_tready(m_axis_ready),    // input wire m_axis_tready
       .m_axis_tdata(m_axis_data),      // output wire [7 : 0] m_axis_tdata
   .    axis_prog_full(axis_prog_full)  // output wire axis_prog_full
    );
endmodule
