`timescale 1ns / 1ps



module buffer(
     input i_clk,
     input i_rst,


     output reg [31:0] bram_addr,
     output reg o_intr,
     output reg ena,
     output reg [3:0]we,
     output reg [31:0] d_out
    );
    
   
    reg [6:0] count;
    reg flag;
    
    always@(posedge i_clk)begin
        if(!i_rst)begin
            bram_addr <= 8'h4000_0000;
            flag <= 0;
            ena <= 1;
            we <= 1;
            d_out <= 0;
        end
        else begin
            if(flag ==0)begin
                d_out <= d_out + 2;
                bram_addr<= bram_addr + 4;
                if(count==63)begin
                    flag <= 1;
                    ena<= 0;
                    we <= 0;
                end
            end
        end
    end
    
    always@(posedge i_clk)begin 
        if(!i_rst)begin
            o_intr <= 0;
            count <= 0;
        end
        else begin
            count <= count  + 1;
            if(count ==62)begin
                o_intr <= 1;
            end
            else if(count == 63) begin
                count <= 0;
                o_intr <= 0;
            end
        end
    
    end
endmodule
