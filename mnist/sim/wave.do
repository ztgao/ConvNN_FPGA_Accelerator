onerror {resume}
virtual type { IDLE PRELOAD SHIFT LOAD} CMD_TYPE
virtual type { IDLE PRELOAD_FIN SHIFT_FIN LOAD_FIN} ACK_TYPE
virtual type { \
INIT\
PRELOAD\
SHIFT\
{0x5 BIAS}\
{0x6 LOAD}\
{0x7 IDLE}\
} FSM_TYPE
virtual type { IDLE PRELOAD SHIFT LOAD} TOP_FSM_TYPE
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider conv_top
add wave -noupdate -group conv_top -radix unsigned /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/clk
add wave -noupdate -group conv_top -radix unsigned /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/rst_n
add wave -noupdate -group conv_top -radix unsigned /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/enable
add wave -noupdate -group conv_top -radix unsigned /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/ext_rom_addr
add wave -noupdate -group conv_top -radix unsigned /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/image_calc_fin
add wave -noupdate -group conv_top -radix unsigned /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_idx
add wave -noupdate -group conv_top -radix unsigned /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_row
add wave -noupdate -group conv_top -radix unsigned /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/valid
add wave -noupdate -group conv_top -radix unsigned /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/input_interface_cmd
add wave -noupdate -group conv_top -radix unsigned /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/input_interface_ack
add wave -noupdate -group conv_top -radix unsigned -childformat {{{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[0]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[1]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[2]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[3]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[4]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[5]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[6]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[7]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[8]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[9]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[10]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[11]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[12]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[13]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[14]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[15]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[16]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[17]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[18]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[19]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[20]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[21]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[22]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[23]} -radix unsigned}} -subitemconfig {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[0]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[1]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[2]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[3]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[4]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[5]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[6]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[7]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[8]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[9]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[10]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[11]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[12]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[13]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[14]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[15]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[16]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[17]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[18]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[19]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[20]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[21]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[22]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob[23]} {-height 15 -radix unsigned}} /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/o_pixel_bus_ob
add wave -noupdate -group conv_top -radix unsigned /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/i_weight_observe
add wave -noupdate -group conv_top -radix unsigned -childformat {{{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[0]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[1]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[2]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[3]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[4]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[5]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[6]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[7]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[8]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[9]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[10]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[11]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[12]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[13]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[14]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[15]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[16]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[17]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[18]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[19]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[20]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[21]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[22]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[23]} -radix unsigned}} -subitemconfig {{/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[0]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[1]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[2]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[3]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[4]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[5]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[6]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[7]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[8]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[9]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[10]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[11]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[12]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[13]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[14]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[15]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[16]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[17]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[18]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[19]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[20]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[21]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[22]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob[23]} {-height 15 -radix unsigned}} /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/feature_ob
add wave -noupdate -divider pool_top
add wave -noupdate -expand -group pool_top -radix unsigned /tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/input_valid
add wave -noupdate -expand -group pool_top -radix unsigned /tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/feature_idx
add wave -noupdate -expand -group pool_top -radix unsigned /tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/feature_row
add wave -noupdate -expand -group pool_top -radix unsigned /tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/feature_idx_delay_0
add wave -noupdate -expand -group pool_top -radix unsigned /tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/feature_row_delay_0
add wave -noupdate -expand -group pool_top -radix unsigned -childformat {{{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[0]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[1]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[2]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[3]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[4]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[5]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[6]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[7]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[8]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[9]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[10]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[11]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[12]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[13]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[14]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[15]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[16]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[17]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[18]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[19]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[20]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[21]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[22]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[23]} -radix unsigned}} -subitemconfig {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[0]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[1]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[2]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[3]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[4]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[5]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[6]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[7]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[8]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[9]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[10]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[11]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[12]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[13]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[14]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[15]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[16]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[17]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[18]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[19]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[20]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[21]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[22]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob[23]} {-height 15 -radix unsigned}} /tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_in_ob
add wave -noupdate -expand -group pool_top /tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/output_valid
add wave -noupdate -expand -group pool_top -radix unsigned -childformat {{{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[0]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[1]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[2]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[3]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[4]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[5]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[6]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[7]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[8]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[9]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[10]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[11]} -radix unsigned}} -expand -subitemconfig {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[0]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[1]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[2]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[3]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[4]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[5]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[6]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[7]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[8]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[9]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[10]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob[11]} {-height 15 -radix unsigned}} /tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/data_out_ob
add wave -noupdate -divider pool_ch05
add wave -noupdate -group pool_ch05 -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/feature_idx}
add wave -noupdate -group pool_ch05 -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/feature_row}
add wave -noupdate -group pool_ch05 -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/input_valid}
add wave -noupdate -group pool_ch05 -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/output_valid}
add wave -noupdate -group pool_ch05 -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/feature_idx_delay_0}
add wave -noupdate -group pool_ch05 -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/feature_row_delay_0}
add wave -noupdate -divider pool_ch05_kernel
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/input_valid}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/output_valid}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/clrPrevResult}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/cmp_idx}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/current_state}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/next_state}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/lastCmp}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/lastFeature}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/rowValid}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/gt}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/feature_idx}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/feature_row}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/rowOutputFlag}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/data_in_ob[0]}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/data_in_ob[1]}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/data_in_buf_ob[0]}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/data_in_buf_ob[1]}
add wave -noupdate -group pool_ch05_kernel -radix unsigned -childformat {{{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[0]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[1]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[2]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[3]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[4]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[5]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[6]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[7]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[8]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[9]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[10]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[11]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[12]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[13]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[14]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[15]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[16]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[17]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[18]} -radix unsigned} {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[19]} -radix unsigned}} -subitemconfig {{/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[0]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[1]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[2]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[3]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[4]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[5]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[6]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[7]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[8]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[9]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[10]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[11]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[12]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[13]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[14]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[15]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[16]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[17]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[18]} {-height 15 -radix unsigned} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob[19]} {-height 15 -radix unsigned}} {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/prev_result_ob}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/data_in_reg_ob}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/result_ob}
add wave -noupdate -group pool_ch05_kernel -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_kernel/data_out_ob}
add wave -noupdate -divider pool_ch05_outbuf
add wave -noupdate -group pool_ch05_outbuf -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_output_interface/feature_idx}
add wave -noupdate -group pool_ch05_outbuf -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_output_interface/feature_row}
add wave -noupdate -group pool_ch05_outbuf -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_output_interface/input_valid}
add wave -noupdate -group pool_ch05_outbuf -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_output_interface/rowValid}
add wave -noupdate -group pool_ch05_outbuf -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_output_interface/rowOutputFlag}
add wave -noupdate -group pool_ch05_outbuf -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_output_interface/input_valid_delay_0}
add wave -noupdate -group pool_ch05_outbuf -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_output_interface/data_in_ob}
add wave -noupdate -group pool_ch05_outbuf -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_output_interface/buffer_ob}
add wave -noupdate -group pool_ch05_outbuf -radix unsigned {/tb_mnist_top/U_mnist_top/U_pooling_layer_top_0/genPoolCh[5]/U_pooling_channel/U_pooling_output_interface/data_out_ob}
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb_mnist_top/U_mnist_top/U_interlayer_buffer_0/clk
add wave -noupdate /tb_mnist_top/U_mnist_top/U_interlayer_buffer_0/rst_n
add wave -noupdate /tb_mnist_top/U_mnist_top/U_interlayer_buffer_0/valid_i
add wave -noupdate -radix unsigned /tb_mnist_top/U_mnist_top/U_interlayer_buffer_0/feature_idx
add wave -noupdate -radix unsigned /tb_mnist_top/U_mnist_top/U_interlayer_buffer_0/feature_row
add wave -noupdate -radix unsigned /tb_mnist_top/U_mnist_top/U_interlayer_buffer_0/cState
add wave -noupdate -radix unsigned /tb_mnist_top/U_mnist_top/U_interlayer_buffer_0/addr_wr
add wave -noupdate -radix unsigned /tb_mnist_top/U_mnist_top/U_interlayer_buffer_0/addr_col
add wave -noupdate -radix unsigned /tb_mnist_top/U_mnist_top/U_interlayer_buffer_0/addr_row_bias
add wave -noupdate -radix unsigned /tb_mnist_top/U_mnist_top/U_interlayer_buffer_0/addr_ch_bias
add wave -noupdate -radix unsigned /tb_mnist_top/U_mnist_top/U_interlayer_buffer_0/addr_row
add wave -noupdate -radix unsigned /tb_mnist_top/U_mnist_top/U_interlayer_buffer_0/lastFeature
add wave -noupdate -radix unsigned /tb_mnist_top/U_mnist_top/U_interlayer_buffer_0/lastCol
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {43983 ns} 0} {{Cursor 2} {293427 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 131
configure wave -valuecolwidth 49
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
WaveRestoreZoom {292841 ns} {293853 ns}