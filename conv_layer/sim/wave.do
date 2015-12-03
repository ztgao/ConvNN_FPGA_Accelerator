onerror {resume}
virtual type { IDLE PRELOAD SHIFT LOAD} TOP_FSM_TYPE
virtual type { \
INIT\
PRELOAD\
SHIFT\
{0x5 BIAS}\
{0x6 LOAD}\
{0x7 IDLE}\
} FSM_TYPE
virtual type { IDLE PRELOAD_FIN SHIFT_FIN LOAD_FIN} ACK_TYPE
virtual type { IDLE PRELOAD SHIFT LOAD} CMD_TYPE
quietly virtual function -install /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0 -env /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0 { (FSM_TYPE)/U_conv_layer_top_0/U_conv_layer_controller_0/current_state} ctrl_cstate
quietly virtual function -install /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0 -env /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0 { (FSM_TYPE)/U_conv_layer_top_0/U_conv_layer_input_interface_0/current_state} intf_cstate
quietly virtual function -install /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0 -env /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0 { (ACK_TYPE)/U_conv_layer_top_0/U_conv_layer_controller_0/input_interface_ack} intf_ack
quietly virtual function -install /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0 -env /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0 { (CMD_TYPE)/U_conv_layer_top_0/U_conv_layer_controller_0/input_interface_cmd} intf_cmd
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider top
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/clk
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/rst_n
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/enable
add wave -noupdate -radix unsigned /tb_conv_layer_top/feature_idx
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/feature_row
add wave -noupdate -divider type_cast
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/o_pixel_bus_observe_0
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/o_pixel_bus_observe_1
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/o_pixel_bus_observe_2
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/o_pixel_bus_observe_3
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/o_pixel_bus_observe_4
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/o_pixel_bus_observe_5
add wave -noupdate -divider <NULL>
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/i_weight_observe
add wave -noupdate -divider <NULL>
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/feature_observe_0
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/feature_observe_1
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/feature_observe_2
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/feature_observe_3
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/feature_observe_4
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/feature_observe_5
add wave -noupdate -divider Controller
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/kernel_calc_fin
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/kernel_array_clear
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/input_interface_ack
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/input_interface_cmd
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/weight_cycle
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/shift_cycle
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/current_state
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/next_state
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/ctrl_cstate
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/intf_ack
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/intf_cmd
add wave -noupdate -divider interface
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/clk
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cmd
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/current_state
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/intf_cstate
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/next_state
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/shift_idx
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_row_index
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_col_index
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/ext_rom_addr
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/preload_cycle
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/ack
add wave -noupdate -divider pooling
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {502 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 190
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ns} {2640 ns}
