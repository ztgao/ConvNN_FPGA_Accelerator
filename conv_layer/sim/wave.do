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
quietly virtual function -install /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0 -env /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0 { (FSM_TYPE)/U_conv_layer_top_0/U_conv_layer_controller_0/current_state} ctrl_cstate
quietly virtual function -install /tb_top/U_conv_layer_top_0/U_conv_layer_input_interface_0 -env /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0 { (FSM_TYPE)/U_conv_layer_top_0/U_conv_layer_input_interface_0/current_state} intf_cstate
quietly virtual function -install /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0 -env /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0 { (ACK_TYPE)/U_conv_layer_top_0/U_conv_layer_controller_0/input_interface_ack} intf_ack
quietly virtual function -install /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0 -env /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0 { (CMD_TYPE)/U_conv_layer_top_0/U_conv_layer_controller_0/input_interface_cmd} intf_cmd
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb_top/U_image_manager/clk
add wave -noupdate /tb_top/U_image_manager/rst_n
add wave -noupdate /tb_top/U_image_manager/enable
add wave -noupdate /tb_top/U_image_manager/layer_0_calc_fin
add wave -noupdate /tb_top/U_image_manager/data_out
add wave -noupdate -radix unsigned /tb_top/U_image_manager/input_image_idx
add wave -noupdate -divider top
add wave -noupdate /tb_top/U_conv_layer_top_0/clk
add wave -noupdate /tb_top/U_conv_layer_top_0/rst_n
add wave -noupdate /tb_top/U_conv_layer_top_0/enable
add wave -noupdate -radix unsigned /tb_top/feature_idx
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0/feature_row
add wave -noupdate -divider type_cast
add wave -noupdate /tb_top/U_conv_layer_top_0/o_pixel_bus_observe_0
add wave -noupdate /tb_top/U_conv_layer_top_0/o_pixel_bus_observe_1
add wave -noupdate /tb_top/U_conv_layer_top_0/o_pixel_bus_observe_2
add wave -noupdate /tb_top/U_conv_layer_top_0/o_pixel_bus_observe_3
add wave -noupdate /tb_top/U_conv_layer_top_0/o_pixel_bus_observe_4
add wave -noupdate /tb_top/U_conv_layer_top_0/o_pixel_bus_observe_5
add wave -noupdate -divider <NULL>
add wave -noupdate /tb_top/U_conv_layer_top_0/i_weight_observe
add wave -noupdate -divider <NULL>
add wave -noupdate /tb_top/U_conv_layer_top_0/feature_observe_0
add wave -noupdate /tb_top/U_conv_layer_top_0/feature_observe_1
add wave -noupdate /tb_top/U_conv_layer_top_0/feature_observe_2
add wave -noupdate /tb_top/U_conv_layer_top_0/feature_observe_3
add wave -noupdate /tb_top/U_conv_layer_top_0/feature_observe_4
add wave -noupdate /tb_top/U_conv_layer_top_0/feature_observe_5
add wave -noupdate -divider Controller
add wave -noupdate /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0/kernel_calc_fin
add wave -noupdate /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0/kernel_array_clear
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0/input_interface_ack
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0/input_interface_cmd
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0/weight_cycle
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0/shift_cycle
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0/current_state
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0/next_state
add wave -noupdate /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0/ctrl_cstate
add wave -noupdate /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0/intf_ack
add wave -noupdate /tb_top/U_conv_layer_top_0/U_conv_layer_controller_0/intf_cmd
add wave -noupdate -divider interface
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/clk
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cmd
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/current_state
add wave -noupdate /tb_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/intf_cstate
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/next_state
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/shift_idx
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_row_index
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_col_index
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/ext_rom_addr
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/preload_cycle
add wave -noupdate -radix unsigned /tb_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/ack
add wave -noupdate -divider {pooling top}
add wave -noupdate /tb_top/U_pooling_layer_top_0/clk
add wave -noupdate /tb_top/U_pooling_layer_top_0/rst_n
add wave -noupdate /tb_top/U_pooling_layer_top_0/kernel_calc_fin
add wave -noupdate -radix unsigned /tb_top/U_pooling_layer_top_0/feature_idx
add wave -noupdate -radix unsigned /tb_top/U_pooling_layer_top_0/block_idx
add wave -noupdate -radix unsigned /tb_top/U_pooling_layer_top_0/feature_row
add wave -noupdate /tb_top/U_pooling_layer_top_0/data_in
add wave -noupdate /tb_top/U_pooling_layer_top_0/data_from_cache_0
add wave -noupdate /tb_top/U_pooling_layer_top_0/data_from_array_0
add wave -noupdate /tb_top/U_pooling_layer_top_0/valid
add wave -noupdate /tb_top/U_pooling_layer_top_0/kernel_calc_fin_delay_0
add wave -noupdate /tb_top/U_pooling_layer_top_0/kernel_calc_fin_delay_1
add wave -noupdate /tb_top/U_pooling_layer_top_0/kernel_calc_fin_delay_2
add wave -noupdate /tb_top/U_pooling_layer_top_0/data_from_output_interface_0
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_layer_input_buffer_0/clk
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_layer_input_buffer_0/rst_n
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_layer_input_buffer_0/kernel_calc_fin
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_layer_input_buffer_0/data_in
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_layer_input_buffer_0/data_out
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_layer_input_buffer_0/buffer
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_layer_input_buffer_0/buffer_ob
add wave -noupdate -divider {pooling buffer}
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_layer_input_buffer_0/kernel_calc_fin
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_layer_input_buffer_0/data_in
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_layer_input_buffer_0/data_out
add wave -noupdate {/tb_top/U_pooling_layer_top_0/U_pooling_layer_input_buffer_0/buffer_ob[0]}
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider {pooling array}
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_array_0/clk
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_array_0/rst_n
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_array_0/clear
add wave -noupdate -radix unsigned /tb_top/U_pooling_layer_top_0/U_pooling_array_0/feature_idx
add wave -noupdate -radix unsigned /tb_top/U_pooling_layer_top_0/U_pooling_array_0/feature_row
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_array_0/kernel_calc_fin
add wave -noupdate -radix unsigned /tb_top/U_pooling_layer_top_0/U_pooling_array_0/current_state
add wave -noupdate -radix unsigned /tb_top/U_pooling_layer_top_0/U_pooling_array_0/cmp_idx
add wave -noupdate -radix unsigned /tb_top/U_pooling_layer_top_0/U_pooling_array_0/data_in
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_array_0/data_in_reg_ob
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_array_0/clear_prev_result
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_array_0/prev_result_ob
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_array_0/result_ob
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_array_0/valid
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_array_0/data_out_ob
add wave -noupdate -divider pooling_out_itf
add wave -noupdate -radix unsigned /tb_top/U_pooling_layer_top_0/U_pooling_output_interface_0/feature_idx
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_output_interface_0/valid
add wave -noupdate -radix unsigned /tb_top/U_pooling_layer_top_0/U_pooling_output_interface_0/data_in
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_output_interface_0/buffer_ob
add wave -noupdate /tb_top/U_pooling_layer_top_0/U_pooling_output_interface_0/data_out_ob
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1095 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 51
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
WaveRestoreZoom {633 ns} {1621 ns}
