
module Bram_read_write(
  input clk,
  input rst
);
  // Using FSM 
  parameter IDLE = 2'b000; 
  parameter WR = 2'b0011;
  parameter RD = 2'b010;
  
  // setting for test
  parameter set_clk = 100; // Setting clock what you want
  parameter bram_size = 50; // setting for 2024, but for example do 50
  
  // enable flag , counter for example
  reg en; // enable to BRAM
  reg [31:0] counter; // counter for Write or Read flag
  
  // using system-verilog when porting FPGA
  reg[3:0] system_state_reg;
  reg [31:0] state_timeout_reg;
  reg[15:0] write_data_reg;
  reg[19:0] read_addr_reg;
  reg[19:0] write_addr_reg;

  wire [15:0] read_data;
  wire [15:0] write_data;
  reg read_en_reg;
  reg write_en_reg;

  wire [3:0] system_state;
  wire is_write_read_flag;
  
  assign system_state = system_state_reg;
  assign write_data[15:0] = write_data_reg[15:0];
  assign is_write_read_flag = (system_state[3:0] == IDLE) ? 0 : 1;

  //always block, 1s trigger once to read write
  // using counter for limit position
  always@(posedge clk or negedge rst)begin
    // counter reset process
    if(rst ==0)begin
      counter <= 0;
    end
    else begin
      if(counter < (set_clk-1)) begin
        counter <= counter + 1;
      end
      else begin
      // counter is just for FSM  initial setting
        counter <= counter;
      end
    end
  end

  // FSM Setting
  always@(posedge clk or negedge rst)begin
    if(rst==0)begin
      system_state_reg <= 0;
      state_timeout_reg <= 0;
      en <= 0;
    end
    else begin
      // wait for clocks, then start BRAM interfacing
      if(counter == (set_clk -1)) begin
        // first is to write data in to BRAM
        system_state_reg <= WR;
        state_timeout_reg <= 0;
        en <= 1;
      end
      else begin
        if(system_state_reg == WR)begin
          if(state_timeout_reg < bram_size -1)begin
            state_timeout_reg <= state_timeout_reg +1;
          end
          else begin
            state_timeout_reg <= 0;
            system_state_reg <= RD;
          end
        end
        else begin
          if(system_state_reg == RD)begin
            if(state_timeout_reg < bram_size-1) state_timeout_reg <= state_timeout_reg +1;
            else begin
              state_timeout_reg <= 0;
              system_state_reg <= IDLE;
              en <= 0;
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

    blk_mem_gen_0 BRAM_DUAL_PORT_16_2048(
           .clka(clk),
           .ena(en),
           .wea(write_en_reg),
           .addra(write_addr_reg),
           .dina(write_data),
           .clkb(clk),
           .enb(read_en_reg),
           .addrb(read_addr_reg),
           .doutb(read_data)
     );


endmodule
