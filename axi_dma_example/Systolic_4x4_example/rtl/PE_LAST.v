`timescale 1ns / 1ps


module PE_LAST(
    i_clk, 
    i_rst, 
    row_in, 
    col_in, 
    col_result,
    in_valid,
    out_valid);
    
    input in_valid;
    input i_clk, i_rst;
    input [31:0] row_in;
    input [31:0] col_in;
  
    output [31:0]col_result; 
    output reg out_valid;
    
    reg [31:0] buffer; 
    reg [31:0] from_col;
    

    always@(posedge i_clk) begin
        if(!i_rst)begin
            from_col <=0;
            buffer<=0;
        end
        else begin
            if(in_valid)begin
                out_valid <= 1;
                buffer <= row_in * col_in + buffer;
                from_col <= col_in; 
            end
            else begin
                out_valid <= 0; 
                from_col <= buffer;
                buffer<= col_in;
            end  
        end
      end
    
    
    assign col_result = from_col;

endmodule
