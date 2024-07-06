`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2024 08:40:51 PM
// Design Name: 
// Module Name: counter
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


module counter(
    input i_clk,
    input i_rst,
    input [31:0] i_data,
    input i_data_valid,
    
    output reg [31:0] o_data,
    output reg o_data_valid,
    output reg o_intr
    );
    

    always@(posedge i_clk)begin
        if(!i_rst)begin
            o_data <= 0;
            o_data_valid <= 0;
            o_intr <= 0;
        end
        if(i_data_valid)begin
            o_data <= o_data + i_data;
            o_data_valid <= 1;
            o_intr <= 0;
        end
        else begin
            o_intr <= 1;
            o_data_valid <= 0;
            o_data <= 0;
        end
    end
endmodule
