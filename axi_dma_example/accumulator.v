`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 01:02:11 PM
// Design Name: 
// Module Name: accumulator
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


module accumulator(
    input i_clk,
    input i_rst,
    input [31:0] i_data,
    input [31:0] i_data_valid,
    input i_data_last,
    
    output reg [31:0] o_data,
    output reg o_data_valid,
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
                o_intr <= 1;
            end
            else begin
                o_intr <= 0;
            end
        end
    end
    

endmodule
