onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_conv_layer_pixel_cache_input/clk
add wave -noupdate /tb_conv_layer_pixel_cache_input/rst_n
add wave -noupdate /tb_conv_layer_pixel_cache_input/enable
add wave -noupdate /tb_conv_layer_pixel_cache_input/idle
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/data
add wave -noupdate /tb_conv_layer_pixel_cache_input/out_kernel_port
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/out_kernel_port_0_0
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/out_kernel_port_0_1
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/out_kernel_port_0_2
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/out_kernel_port_0_3
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/out_kernel_port_0_4
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/out_kernel_port_0_5
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb_conv_layer_pixel_cache_input/U_cache_1/clk
add wave -noupdate /tb_conv_layer_pixel_cache_input/U_cache_1/rst_n
add wave -noupdate /tb_conv_layer_pixel_cache_input/U_cache_1/enable
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/next_state
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/bank_idx
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/shift_idx
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/pixel_in
add wave -noupdate /tb_conv_layer_pixel_cache_input/U_cache_1/out_kernel_port
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/rom_addr
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/current_state
add wave -noupdate -divider cache_array_0
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_0_0
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_0_1
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_0_2
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_0_3
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_0_4
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_0_5
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_0_6
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_0_7
add wave -noupdate -divider cache_array_1
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_1_0
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_1_1
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_1_2
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_1_3
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_1_4
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_1_5
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_1_6
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_1_7
add wave -noupdate -divider cache_array_2
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_2_0
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_2_1
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_2_2
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_2_3
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_2_4
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_2_5
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_2_6
add wave -noupdate -radix unsigned /tb_conv_layer_pixel_cache_input/U_cache_1/cache_array_2_7
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {142355 ps} 0}
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
WaveRestoreZoom {0 ps} {540750 ps}
