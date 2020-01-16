onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tf_AFE_ADS/uut/AFE_CTL/CLK_100M
add wave -noupdate /tf_AFE_ADS/uut/AFE_CTL/CLK_RST
add wave -noupdate -divider AFE
add wave -noupdate /tf_AFE_ADS/uut/AFE_CTL/AFE_IRST
add wave -noupdate /tf_AFE_ADS/uut/AFE_CTL/AFE_SHR
add wave -noupdate /tf_AFE_ADS/uut/AFE_CTL/AFE_INTG
add wave -noupdate /tf_AFE_ADS/uut/AFE_CTL/AFE_SHS
add wave -noupdate /tf_AFE_ADS/uut/AFE_CTL/AFE_STI
add wave -noupdate /tf_AFE_ADS/uut/AFE_CTL/AFE_CLK
add wave -noupdate /tf_AFE_ADS/uut/AFE_CTL/AFE_DF_SM
add wave -noupdate -divider 2
add wave -noupdate -radix unsigned /tf_AFE_ADS/uut/AFE_CTL/time_cnt
add wave -noupdate -radix unsigned /tf_AFE_ADS/uut/AFE_CTL/clk_cnt
add wave -noupdate /tf_AFE_ADS/uut/AFE_CTL/current_state
add wave -noupdate /tf_AFE_ADS/uut/AFE_CTL/sjump
add wave -noupdate -divider ADS
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/ADS_CLK
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/ADS_CONVST
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/ADS_CS_N
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/ADS_RD
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/ADS_SDI
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/ADS_M
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/ADS_INIT_OK
add wave -noupdate -divider {New Divider}
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/current_state
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/time_cnt
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/cmd_cnt
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/clk_cnt
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/sdi_cmdr
add wave -noupdate -divider data
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/ADS_SDOA
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/ADS_SDOB
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/ADS_ADATA
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/ADS_AVLAID
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/ADS_BDATA
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/ADS_BVLAID
add wave -noupdate /tf_AFE_ADS/sdo_data
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/sdoa
add wave -noupdate /tf_AFE_ADS/uut/ADS_CTL/sdoa_cnt
add wave -noupdate /tf_AFE_ADS/data_valid
add wave -noupdate /tf_AFE_ADS/sdo_cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11100000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 275
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {3119531 ps} {39516300 ps}
