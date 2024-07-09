`timescale 1ns / 1ps

module accumulate_buffer(
    input i_clk,
    input i_rst,
    input [31:0] i_data1, i_data2, i_data3, i_data4,
    input i_valid1, i_valid2, i_valid3, i_valid4,
    
    output reg o_valid,
    output reg [31:0] o_data
    );
    
    reg [31:0] accum_buffer [15:0];
    integer i;
    reg [2:0] in1, in2, in3, in4;
    reg [4:0] count;
    always@(posedge i_clk)begin
        if(!i_rst)begin
            for(i=0; i<16; i=i+1)begin
                accum_buffer[i] <= 0;
            end
            in1 <= 0;
            in2 <= 0;
            in3 <= 0;
            in4 <= 0;
        end
        else begin
            if(i_valid1)begin
                accum_buffer[in1] <= i_data1;
                in1 <= in1 + 1;
            end
            if(i_valid2)begin
                accum_buffer[in2 + 4] <= i_data2;
                in2 <= in2 +1;
            end
            if(i_valid3) begin
                accum_buffer[in3 + 8] <= i_data3;
                in3 <= in3 +1;
            end
            if(i_valid4)begin
                accum_buffer[in4 + 12] <= i_data4;
                in4 <= in4 +1;
            end
            else begin
                if(count ==16)begin
                    in1 <= 0;
                    in2 <= 0;
                    in3 <= 0;
                    in4 <= 0;
                end
            end
        end
    end
    
    always@(posedge i_clk)begin
        if(!i_rst)begin
            count <= 0;
            o_valid<= 0;
            o_data <= 0;
        end
        else begin
            if(count ==16)begin
                count <= 0;
                o_valid <= 0;
            end
            else begin
                if((in4==4) && (in3==4) && (in2==4) && (in1==4)) begin
                    count <= count + 1;
                    o_valid <= 1;
                    o_data <= accum_buffer[count];
                end
           end
        end
     end    
     
     
endmodule
