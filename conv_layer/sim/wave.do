onerror {resume}
virtual type { IDLE PRELOAD SHIFT LOAD} TOP_FSM_TYPE
quietly virtual function -install /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0 -env /tb_conv_layer_top/#INITIAL#33 { (TOP_FSM_TYPE)/U_conv_layer_top_0/U_conv_layer_controller_0/current_state} CState
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/clk
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/rst_n
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/enable
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/pixel_in
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/out_kernel_port
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/out_kernel_port_reg
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/rom_addr
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/current_state
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/next_state
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/last_state
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/read_index
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/shift_idx
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/preload_cycle
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cmd
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/ack
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_kernel_array_0/clear_delay_2
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/feature_observe_0
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/feature_observe_1
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/feature_observe_2
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/feature_observe_3
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/feature_observe_4
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/feature_observe_5
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/i_weight_observe
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/o_pixel_bus_observe_0
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/o_pixel_bus_observe_1
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/o_pixel_bus_observe_2
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/o_pixel_bus_observe_3
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/o_pixel_bus_observe_4
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/o_pixel_bus_observe_5
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/clk
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/rst_n
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/enable
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/input_interface_ack
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/input_interface_cmd
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/weight_num
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/current_state
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/CState
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_controller_0/next_state
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_0_0
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_0_1
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_0_2
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_0_3
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_0_4
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_0_5
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_0_6
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_0_7
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_1_0
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_1_1
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_1_2
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_1_3
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_1_4
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_1_5
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_1_6
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_1_7
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_2_0
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_2_1
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_2_2
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_2_3
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_2_4
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_2_5
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_2_6
add wave -noupdate -radix unsigned /tb_conv_layer_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/cache_array_2_7
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_kernel_array_0/U_conv_kernel_0_0/clk
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_kernel_array_0/U_conv_kernel_0_0/rst_n
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_kernel_array_0/U_conv_kernel_0_0/i_pixel
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_kernel_array_0/U_conv_kernel_0_0/i_weight
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_kernel_array_0/U_conv_kernel_0_0/o_pixel
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_kernel_array_0/U_conv_kernel_0_0/mult_a
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_kernel_array_0/U_conv_kernel_0_0/mult_b
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_kernel_array_0/U_conv_kernel_0_0/product
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_kernel_array_0/U_conv_kernel_0_0/add_a
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_kernel_array_0/U_conv_kernel_0_0/add_b
add wave -noupdate /tb_conv_layer_top/U_conv_layer_top_0/U_conv_kernel_array_0/U_conv_kernel_0_0/sum
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {571682 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 191
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
WaveRestoreZoom {322508 ps} {651618 ps}
