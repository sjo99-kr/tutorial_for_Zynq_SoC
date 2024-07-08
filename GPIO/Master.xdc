// for switch K2
set_property -dict { PACKAGE_PIN M20   IOSTANDARD LVCMOS33     } [get_ports { gpio_rtl_0_tri_i }]; 


// FOR LED D1
set_property -dict { PACKAGE_PIN T12   IOSTANDARD LVCMOS33     } [get_ports { gpio_rtl_1_tri_o[0] }];             
// FOR LED D2
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33     } [get_ports { gpio_rtl_1_tri_o[1] }];             
// FOR LED D3
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { gpio_rtl_1_tri_o[2] }]; 				 
// FOR LED D4
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports { gpio_rtl_1_tri_o[3] }]; 
