`timescale 1ns / 1ps

module Input_buffer(
    input i_clk,
    input i_rst,
   // Slave Port 
    input [31:0] s_axis_data,
    input s_axis_valid,
    output reg s_axis_ready,
    // Master Port
    output reg [31:0] m_axis_data,
    output reg m_axis_valid,
    input m_axis_ready
    );
    reg [7:0] buffer [0:100];
    reg [9:0] wr_pt;
    reg [9:0] rd_pt;
    reg flag;
    integer i;

    // setting for wr, rd
    always@(posedge i_clk)begin
        if(!i_rst)begin
            // reset signals
            m_axis_valid <= 0;
            m_axis_data <= 0;
            for(i = 0; i<100; i= i+1)begin
                buffer[i] <= 0;
            end
            rd_pt <= 0;
            wr_pt <= 0;
            flag <= 0;
        end

        else begin
            if(s_axis_valid & s_axis_ready)begin
                buffer[wr_pt] <= s_axis_data;
                wr_pt <= wr_pt + 1;
            end
            else if(wr_pt > 23)begin
                flag <= 1;
                if(!s_axis_ready & m_axis_ready)begin
                    m_axis_valid <= 1;
                    m_axis_data <= buffer[rd_pt];
                    rd_pt <= rd_pt  + 1;
                    
                    if(rd_pt == wr_pt)begin
                        rd_pt <= 0;
                        wr_pt <= 0;
                        m_axis_valid <= 0;
                        flag <= 0;
                    end
                end
            end

        end
    end

  // setting for s_axis_ready part
    always@(posedge i_clk)begin
            if(!i_rst)begin
                s_axis_ready <= 1;
            end
            else begin
                if(flag == 1 &&(wr_pt == rd_pt))begin
                    s_axis_ready <= 1;
                
                end
                else begin
                    if(wr_pt>23)begin
                        s_axis_ready <= 0;
                    end
                end
            end
    end 
    
endmodule
