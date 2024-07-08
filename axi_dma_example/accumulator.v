`timescale 1ns / 1ps
/******************************************************************************

Tutorial Materials for Embedded Software using Vitis IDE

Using Acumulator Custom Ip, Do AXI-DMA process

made by Seongwon Jo,


*******************************************************************************/


// Accumulator Custom IP in PL
module accumulator(
    input i_clk,
    input i_rst,
    input [31:0] i_data,
    input [31:0] i_data_valid,
    input i_data_last,
    
    output reg [31:0] o_data,
    output reg o_data_valid,

    //INTERRUPT SIGNAL
    output reg o_intr
    );
    reg [4:0] counter;
    
    always@(posedge i_clk)begin
        if(!i_rst)begin
            o_data <= 0;
            o_data_valid <= 0;
            counter <= 1;
        end
        else begin
            // I_data_valid signal comes from AXI-Slave singal(s_axis_valid)
            // AXI_DMA data comes s_axis ports. 
            // if we sent 8 datas from DDR, i_data_valid set up for 8 cycles based on PL-Clock Cycle (100MHz)
            if(i_data_valid)begin
                o_data <= o_data + i_data;
                o_data_valid <= 1;
                if(counter ==8)begin
                    counter <= 1;
                end
                else begin
                    counter <= counter + 1;
                end
            end
            else begin
                o_data_valid <= 0;
            end
        end
    end
    
    always@(posedge i_clk)begin
        if(!i_rst)begin
            o_intr <= 0;
        end
        else begin
            if( counter % 8 == 0)begin
                // INTERRUPT SIGNAL O_intr
                // turn valid when data sent is over
                // only valid when we get 8 datas each time. 
                o_intr <= 1;
            end
            else begin
                // initialize o_intr
                // PL-Clock Cycles cant not be over 250 MHz,
                // But PS-clock Cycles (CPU or DDR) is over than 500MHz.
                // so, Just turn on for one cycle is enought for PS interrupt.
                o_intr <= 0;
            end
        end
    end
    

endmodule
