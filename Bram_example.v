
module Bram_read_write(
  input clk,
  input rst
);
  // Using FSM
  parameter IDLE = d'0;
  parameter WR = d'1;
  parameter RD = d'2;
  parameter clk_freq = 50_000_000;
  parameter bram_size = 2048;

  reg [31:0] counter_reg;
  // using system-verilog
  (*mark_debug="true"*) reg[3:0] system_state_reg;
  reg [31:0] state_timeout_reg;
  (*mark_debug="true"*) reg[15:0] write_data_reg;
  (*mark_debug="true"*) reg[19:0] read_addr_reg;
  (*mark_debug="true"*) reg[19:0] write_addr_reg;

  (*mark_debug="true"*) wire [15:0] read_data;
  (*mark_debug="true"*) wire [15:0] write_data;
  (*mark_debug="true"*) reg read_en_rng;
  (*mark_debug="true"*) reg write_en_reg;

  wire [3:0] system_state;
  (*mark_debug="true"*) wire is_write_read_flag;
  assign system_state = system_state_reg;
  assign write_data[15:0] = write_data_reg[15:0];
  assign is_write_read_flag = (system_state[3:0] == IDLE) ? b'0 : b'1;

  //always block, 1s trigger once to read write
  always@(posedge clk or negedge rst)begin
    if(rst ==0)begin
      counter <= 0;
    end
  end
  





endmodule
