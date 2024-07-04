
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
  // using counter for limit position
  always@(posedge clk or negedge rst)begin
    // counter reset process
    if(rst ==0)begin
      counter <= 0;
    end
    else begin
      if(counter < (clk_freq-1) begin
        counter <= counter + 1;
      end
      else begin
        counter <= 0;
      end
    end
  end

  // FSM Setting
  always@(posedge clk or negedge rst)begin
    if(rst==0)begin
      system_state_reg <= 0;
      system_timeout_reg <= 0;
    end
    else begin
      // start writing
      if(counter_reg == (clk_freq -1)) begin
        system_state_reg <= WR;
        state_timeout_reg <= 0;
      end
      else begin
        if(system_state_reg == WR)begin
          if(state_timeout_reg < BRAM_size -1)begin
            state_timeout_reg <= state_timeout_reg +1;
          end
          else begin
            state_timeout_reg <= 0;
            system_state_reg <= RD;
          end
        end
        else begin
          if(system_state_reg == RD)begin
            if(state_timeout_reg < RAM_size-1) state_timeout_reg <= state_timeout_reg +1;
            else begin
              state_timeout_reg <= 0;
              system_state_reg <= IDLE;
            end
          end
        end
      end
    end
  end

  // What data do you wanna write?
  always@(posedge clk or negedge rst)begin
    if(rst==0)begin
      write_data_reg <=0;
      write_addr_reg <=0;
      read_addr_reg <=0;
    end
    else begin
      if(system_state_reg == WR)begin
        // WRITE_DATA -> COUNT DATA.
        write_data_reg <= write_data_reg + 1;
        // UP REGISTER VALUE
        write_addr_reg <= write_addr_reg +1;
        read_en_reg <= 0;
        write_en_reg <= 1;
      end
      else if(system_state_reg == RD)begin
        read_addr_reg <= read_addr_reg +1;
        read_en_reg <= 1;
        write_en_reg <= 0;
      end
      else if(system_state_reg == IDLE)begin
        write_data_reg <=0;
        read_addr_reg <=0;
        write_addr_reg <=0;
        write_en_reg <= 0;
        read_en_reg <= 0;
      end
      end
    end
  end
  





endmodule
