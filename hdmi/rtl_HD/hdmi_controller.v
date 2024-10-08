//////////////////////////////////////////////////////////////////////////////////
// HDMI Displat Driver Module
//////////////////////////////////////////////////////////////////////////////////
module hdmi_controller(
	input          clk,              // 100Mhz
	// pixel clock -> 74.125 Mhz
	/////// s_axis_stream_data
	input  [23:0]  s_axis_video_data,
	input          s_axis_video_valid,
	output         s_axis_video_ready,
	input          s_axis_video_last,
	input          s_axis_video_user,
	
	input          reset,
	output [2:0]   TMDSp, 
	output [2:0]   TMDSn,
	output         TMDSp_clock, 
	output         TMDSn_clock,
	output         HDMI_out
);

//////////////////////////////////////////////////////////////////////////////////
// Clock Generator Instantiation
//////////////////////////////////////////////////////////////////////////////////
    assign HDMI_out = 1'b1;
    assign s_axis_video_ready = 1;
    // clock _ pix => 74.125 Mhz 이어야 한다.-> 1280x720
// clock_pix -> clk * mult_master / div_master / div_pix => 74.125 Mhz
// clock_tmds -> clk * mult_master / div_master / div_tmds =>  741.25 Mhz
    clock_gen #(
        .MULT_MASTER (37.125   ),  // master clock multiplier (2.000-64.000)
        .DIV_MASTER  (5        ),  // master clock divider (1-106)
        .DIV_PIX     (10        ),  // pixel clock divider (1-128)
        .DIV_TMDS    (1        ),  // tmds clock divider (1-128)
	.IN_PERIOD   (10        )   // period of master clock in ns // 100Mhz
    ) clock_gen_inst (
        .clk        (clk        ),  // Input Clock 100MHz
        .clk_pix    (clk_pix    ),  // pixel clock output pixel clock 
        .clk_tmds   (clk_tmds   )   // tmds clock output tmds clock = pixel clock * 5
    );
    
    // resolution :1920 x 1080 : clk_pix = 148.5Mhz, clk_tmds = clk_pix * 5

    wire clk_pix, clk_tmds;
//////////////////////////////////////////////////////////////////////////////////
// Sync Signal Generator Instantiation
//////////////////////////////////////////////////////////////////////////////////
    wire [11:0] sx, sy;
    wire hsync, vsync, de;
sync_gen #(
    // horizontal timings
    .HA_END     (1279),  // end of active pixels (0-based index)
    .HS_STA     (1368),  // sync starts after front porch
    .HS_END     (1412),  // sync ends
    .LINE       (1559),  // last pixel on line (after back porch)

    // vertical timings
    .VA_END     (719),   // end of active pixels (0-based index)
    .VS_STA     (725),   // sync starts after front porch
    .VS_END     (730),   // sync ends
    .SCREEN     (750)    // last line on screen (after back porch)
) sync_gen_inst (
    .clk_pix    (clk_pix    ),     // pixel clock
    .rgb_valid  (s_axis_video_valid),
    .reset      (reset),
    .sx         (sx         ),     // horizontal screen position
    .sy         (sy         ),     // vertical screen position
    .hsync      (hsync      ),     // horizontal sync
    .vsync      (vsync      ),     // vertical sync
    .de         (de         )      // data enable (low in blanking interval)
);

/////////////////////////////////////////////////////////////////////////////////
// 8 Colour Strip Pattern Generator Logic
////////////////////////////////////////////////////////////////////////////////
    wire [7:0] red, green, blue;
    assign red = s_axis_video_data[7:0];
    assign green = s_axis_video_data[15:8];
    assign blue =  s_axis_video_data[23:16];
/////////////////////////////////////////////////////////////////////////////////
// TMDS Encoder Instntiation
////////////////////////////////////////////////////////////////////////////////
    wire [9:0] tmds_red, tmds_green, tmds_blue;
    
    tmds_enc enc_r(
        .clk    (clk_pix        ), 
        .vd     (red            ), 
        .cd     (2'b00          ), 
        .de     (de             ), 
        .tmds   (tmds_red       )
    );
    
    tmds_enc enc_g(
        .clk    (clk_pix        ), 
        .vd     (green          ), 
        .cd     (2'b00          ), 
        .de     (de             ), 
        .tmds   (tmds_green     )
    );
    
    tmds_enc enc_b(
        .clk    (clk_pix        ), 
        .vd     (blue           ), 
        .cd     ({vsync,hsync}  ), 
        .de     (de             ), 
        .tmds   (tmds_blue      )
    );

/////////////////////////////////////////////////////////////////////////////////
// Serializer Instantiation
////////////////////////////////////////////////////////////////////////////////
    wire ser_red, ser_green, ser_blue;
    
    serializer ser_r(
        .clk_pix    (clk_pix    ),
        .clk_tmds   (clk_tmds   ),
        .data_i     (tmds_red   ),
        .data_o     (ser_red    )
    );
    
    serializer ser_g(
        .clk_pix    (clk_pix    ),
        .clk_tmds   (clk_tmds   ),
        .data_i     (tmds_green ),
        .data_o     (ser_green  )
    );
    
    serializer ser_b(
        .clk_pix    (clk_pix    ),
        .clk_tmds   (clk_tmds   ),
        .data_i     (tmds_blue  ),
        .data_o     (ser_blue   )
    );

/////////////////////////////////////////////////////////////////////////////////
// Differential Output Buffers
////////////////////////////////////////////////////////////////////////////////
    OBUFDS #
    (
        .IOSTANDARD ("DEFAULT"  ),  // Specify the output I/O standard
        .SLEW       ("SLOW"     )   // Specify the output slew rate
    ) OBUFDS_red 
    (
        .O  (TMDSp[2]   ),          // Diff_p output (connect directly to top-level port)
        .OB (TMDSn[2]   ),          // Diff_n output (connect directly to top-level port)
        .I  (ser_red    )           // Buffer input
    );
    
    OBUFDS #
    (
        .IOSTANDARD("DEFAULT"),
        .SLEW("SLOW")
    ) OBUFDS_green 
    (
        .O(TMDSp[1]),
        .OB(TMDSn[1]),
        .I(ser_green)
    );
    
    OBUFDS #
    (
        .IOSTANDARD("DEFAULT"),
        .SLEW("SLOW") 
    ) OBUFDS_blue 
    (
        .O(TMDSp[0]), 
        .OB(TMDSn[0]),
        .I(ser_blue)
    );
    
    OBUFDS #
    (
        .IOSTANDARD("DEFAULT"),
        .SLEW("SLOW")
    ) OBUFDS_clock 
    (
        .O(TMDSp_clock),
        .OB(TMDSn_clock), 
        .I(clk_pix)
    );

endmodule
