`timescale 1ns / 1ps


module MMU_4x4(
    input i_clk,
    input i_rst,
    input [31:0] col1_in, col2_in, col3_in, col4_in,
    input [31:0] row1_in, row2_in, row3_in, row4_in,
    input in_valid,
    
    output [31:0] o_data1, o_data2, o_data3, o_data4,
    output reg o_valid1, o_valid2, o_valid3, o_valid4
    );
    
    // pe11 line and valid
    wire [31:0] line11_12, line11_21; 
    wire pe11_valid;
    // pe12 line and valid
    wire [31:0] line12_13, line12_22; 
    wire pe12_valid;
    // pe13 line and valid
    wire [31:0] line13_14, line13_23; 
    wire pe13_valid;
    // pe14 line and valid
    wire [31:0] line14_24; 
    wire pe14_valid;
    
    // pe21 line and valid
    wire [31:0] line21_22, line21_31;
    wire  pe21_valid;
    // pe22 line and valid
    wire [31:0] line22_23, line22_32; 
    wire pe22_valid;
    // pe23 line and valid
    wire [31:0] line23_24, line23_33;
    wire pe23_valid;
    // pe24 line and valid
    wire [31:0] line24_34;
    wire pe24_valid;
    
    // pe31 line and valid
    wire [31:0] line31_32, line31_41;
    wire  pe31_valid;
    // pe32 line and valid
    wire [31:0] line32_33, line32_42; 
    wire pe32_valid;
    // pe33 line and valid
    wire [31:0] line33_34, line33_43;
    wire pe33_valid;
    // pe34 line and valid
    wire [31:0] line34_44;
    wire pe34_valid;
    
    // pe41 line and valid
    wire [31:0] line41_42;
    wire pe41_valid, pe42_valid, pe43_valid;
    // pe42 line and valid
    wire [31:0] line42_43;
    // pe43 line and valid
    wire [31:0] line43_44;
    // pe44 line and valid
    
    reg flag;
    reg  [4:0] count;
    // PE  ROW LINE 1
    
    PE      pe11 (.i_clk(i_clk), .i_rst(i_rst), .in_valid(in_valid), .row_in(row1_in), .col_in(col1_in), .out_valid(pe11_valid), .row_result(line11_12),
                .col_result(line11_21));
    PE      pe12 (.i_clk(i_clk), .i_rst(i_rst), .in_valid(pe11_valid), .row_in(line11_12), .col_in(col2_in), .out_valid(pe12_valid), .row_result(line12_13),
                .col_result(line12_22));
    PE      pe13( .i_clk(i_clk), .i_rst(i_rst), .in_valid(pe12_valid), .row_in(line12_13), .col_in(col3_in), .out_valid(pe13_valid), .row_result(line13_14),
                .col_result(line13_23));
                
    PE_LAST pe_last14( .i_clk(i_clk), .i_rst(i_rst), .in_valid(pe13_valid), .row_in(line13_14), .col_in(col4_in), .out_valid(pe14_valid), .col_result(line14_24));
           
    
    // PE ROW LINE 2
    PE      pe21( .i_clk(i_clk), .i_rst(i_rst), .in_valid(pe11_valid), .row_in(row2_in), .out_valid(pe21_valid), .col_in(line11_21), .row_result(line21_22), .col_result(line21_31));
    PE      pe22( .i_clk(i_clk), .i_rst(i_rst), .in_valid(pe21_valid), .row_in(line21_22), .col_in(line12_22), .row_result(line22_23), .col_result(line22_32), .out_valid(pe22_valid));
    PE      pe23( .i_clk(i_clk), .i_rst(i_rst), .in_valid(pe22_valid), .row_in(line22_23), .col_in(line13_23), .row_result(line23_24), .col_result(line23_33),. out_valid(pe23_valid));
    
    PE_LAST pe_last24( .i_clk(i_clk), .i_rst(i_rst), .in_valid(pe23_valid), .row_in(line23_24), .col_in(line14_24), .out_valid(pe24_valid), .col_result(line24_34));
    
    // PE ROW LINE 3
    PE      pe31( .i_clk(i_clk), .i_rst(i_rst), .in_valid(pe21_valid), .row_in(row3_in), .out_valid(pe31_valid), .col_in(line21_31), .row_result(line31_32), .col_result(line31_41));
    PE      pe32( .i_clk(i_clk), .i_rst(i_rst), .in_valid(pe31_valid), .row_in(line31_32), .out_valid(pe32_valid), .col_in(line22_32), .row_result(line32_33), .col_result(line32_42));
    PE      pe33( .i_clk(i_clk), .i_rst(i_rst), .in_valid(pe32_valid), .row_in(line32_33), .out_valid(pe33_valid), .col_in(line23_33), .row_result(line33_34), .col_result(line33_43));
    
    PE_LAST pe_last34( .i_clk(i_clk), .i_rst(i_rst), .in_valid(pe33_valid), .row_in(line33_34), .col_in(line24_34), .out_valid(pe34_valid), .col_result(line34_44));
    
    // PE ROW LINE 4
    PE      pe41( .i_clk(i_clk), .i_rst(i_rst), .in_valid(pe31_valid), .row_in(row4_in), .out_valid(pe41_valid), .col_in(line31_41), .row_result(line41_42), .col_result(o_data1));
    PE      pe42( .i_clk(i_clk), .i_rst(i_rst), .in_valid(pe41_valid), .row_in(line41_42), .out_valid(pe42_valid), .col_in(line32_42), .row_result(line42_43), .col_result(o_data2));
    PE      pe43( .i_clk(i_clk), .i_rst(i_rst), .in_valid(pe42_valid), .row_in(line42_43), .out_valid(pe43_valid), .col_in(line33_43), .row_result(line43_44), .col_result(o_data3));
    
    PE_LAST pe_last44( .i_clk(i_clk), .i_rst(i_rst), .in_valid(pe43_valid), .row_in(line43_44), .out_valid(), .col_in(line34_44), .col_result(o_data4)); 
    
    
    
    // Valid Singal Controller
    always@(posedge i_clk)begin
        if(!i_rst)begin
            flag <= 0;
        end
        else begin
            if(in_valid)begin
                flag <= 1;
            end
            else begin
                if(count ==19)begin
                    flag <= 0;
                end
            end
        end
    end
    
    always@(posedge i_clk)begin
        if(!i_rst)begin
            count <= 0;
            o_valid1 <= 0;
            o_valid2 <= 0;
            o_valid3 <= 0;
            o_valid4 <= 0;
        end
        else begin
            if(flag == 1)begin
                count <= count +1;
                if( count == 12)begin
                    o_valid1 <= 1;
                end
                else if( count == 13)begin
                    o_valid2 <= 1;
                end
                else if(count == 14) begin
                    o_valid3 <= 1;
                end
                else if (count == 15) begin
                    o_valid4 <= 1;
                end
                else if (count == 16) begin
                    o_valid1 <= 0;
                end
                else if (count == 17) begin
                    o_valid2 <= 0;
                end
                else if (count == 18) begin
                    o_valid3 <= 0;
                end
                else if (count== 19) begin
                    o_valid4 <= 0;
                    count <= 0;
                end
            end
        end
    
    end
    
    
    
endmodule
