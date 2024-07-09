/******************************************************************************

Tutorial Materials for Embedded Software using Vitis IDE

Using Custom IP port , GPIO control.

made by Seongwon Jo,


*******************************************************************************/
module led_stream(
    output reg [3:0] led, // LED4 to LED1, 1 on, 0 off
    input clk, // FPGA PL clock, 50 MHz
    input rst_n, // FPGA reset pin
    output reg o_intr
);

    
    reg [31:0] cnt;
    reg [1:0] led_on_number;
    //clock input 50000000
    parameter CLOCK_FREQ =50000000;
    parameter COUNTER_MAX_CNT=CLOCK_FREQ/2-1;//change time 0.5s
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            cnt <= 32'd0;
            led_on_number <= 2'd0;
        end
        else begin
            cnt <= cnt + 1'b1;
            if(cnt == COUNTER_MAX_CNT) begin//计数0.5s
                cnt <= 32'd0;
                led_on_number <= led_on_number + 1'b1;
            end
        end
    end

    always @(led_on_number) begin
        case(led_on_number)
            0: led <= 4'b0001;
            1: led <= 4'b0010;
            2: led <= 4'b0100;
            3: led <= 4'b1000;
                
        endcase
    end
    always @(led_on_number) begin
    
        case(led_on_number)
            0: o_intr <= 0;
            1: o_intr <= 0;
            2: o_intr <= 0;
            3: o_intr <= 1;
        endcase
    end
    
    
endmodule
