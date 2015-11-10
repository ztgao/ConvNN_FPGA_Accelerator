onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_conv_layer_input_interface/clk
add wave -noupdate /tb_conv_layer_input_interface/rst_n
add wave -noupdate /tb_conv_layer_input_interface/enable
add wave -noupdate /tb_conv_layer_input_interface/idle
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/data
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/out_kernel_port_0_0
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/out_kernel_port_0_1
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/out_kernel_port_0_2
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/out_kernel_port_0_3
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/out_kernel_port_0_4
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/out_kernel_port_0_5
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/clk
add wave -noupdate /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/rst_n
add wave -noupdate /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/enable
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/pixel_in
add wave -noupdate /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/out_kernel_port
add wave -noupdate /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/out_kernel_port_reg
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/rom_addr
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/current_state
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/next_state
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/last_state
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/read_index
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/shift_idx
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/preload_cycle
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/weight_set_counter
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_0_0
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_0_1
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_0_2
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_0_3
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_0_4
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_0_5
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_0_6
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_0_7
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_1_0
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_1_1
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_1_2
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_1_3
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_1_4
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_1_5
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_1_6
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_1_7
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_2_0
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_2_1
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_2_2
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_2_3
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_2_4
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_2_5
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_2_6
add wave -noupdate -radix unsigned /tb_conv_layer_input_interface/U_conv_layer_input_interface_1/cache_array_2_7
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {632249 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {404881 ps} {945631 ps}
