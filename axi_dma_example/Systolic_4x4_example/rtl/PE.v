
`timescale 1ns / 1ps

module PE(
    i_clk, 
    i_rst, 
    row_in, 
    col_in, 
    row_result, 
    col_result,
    in_valid, 
    out_valid);
    
    // clk: clock , rst : reset, 
    // data_in1
    input i_clk, i_rst;
    input [31:0] row_in; //row data
    input [31:0] col_in; // GEMM -> data, DNN,CNN -> 0, col data 
    input in_valid;
    
    output reg out_valid;
    output signed  [31:0] row_result;
    output signed  [31:0] col_result;
    
    reg [31:0] buffer; 
    reg [31:0] from_col;
    reg [31:0] from_row;

    
    always@(posedge i_clk) begin
        if(!i_rst)begin
            from_col <= 0;
            from_row <= 0;
            buffer <= 0;
        end
        else begin
            if(in_valid == 1)begin //pass to activation
                out_valid <= 1;
                buffer <= row_in * col_in + buffer;
                from_row <= row_in;
                from_col <= col_in;
            end
            else begin
                 out_valid <=0;
                 from_col <= buffer;
                 buffer <= col_in;
            end
        end
      end
    assign  row_result = from_row;
    assign  col_result = from_col;
endmodule
