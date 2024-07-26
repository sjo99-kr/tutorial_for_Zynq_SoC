set_property IOSTANDARD TMDS_33 [get_ports {TMDSp[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDSn[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDSp[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDSn[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDSp[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDSn[2]}]
set_property PACKAGE_PIN D19 [get_ports {TMDSp[0]}]
set_property PACKAGE_PIN D20 [get_ports {TMDSn[0]}]
set_property PACKAGE_PIN C20 [get_ports {TMDSp[1]}]
set_property PACKAGE_PIN B20 [get_ports {TMDSn[1]}]
set_property PACKAGE_PIN B19 [get_ports {TMDSp[2]}]
set_property PACKAGE_PIN A20 [get_ports {TMDSn[2]}]


set_property PACKAGE_PIN K17 [get_ports clock]
set_property IOSTANDARD LVCMOS33 [get_ports clock]

set_property IOSTANDARD TMDS_33 [get_ports TMDSp_clock]

set_property PACKAGE_PIN H16 [get_ports TMDSp_clock]
set_property PACKAGE_PIN H17 [get_ports TMDSn_clock]
set_property IOSTANDARD TMDS_33 [get_ports TMDSn_clock]

set_property PACKAGE_PIN H18 [get_ports HDMI_out]
set_property IOSTANDARD LVCMOS33 [get_ports HDMI_out]

set_property PACKAGE_PIN M20 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
