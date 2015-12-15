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
virtual function -install /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/U_conv_layer_controller_0 -env /tb_mnist_top/U_mnist_top/U_network_manager_0 { (FSM_TYPE)/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/U_conv_layer_controller_0/current_state} ctrl_cstate
virtual function -install /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/U_conv_layer_input_interface_0 -env /tb_mnist_top/U_mnist_top/U_network_manager_0 { (FSM_TYPE)/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/U_conv_layer_input_interface_0/current_state} intf_cstate
virtual function -install /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/U_conv_layer_controller_0 -env /tb_mnist_top/U_mnist_top/U_network_manager_0 { (ACK_TYPE)/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/U_conv_layer_controller_0/input_interface_ack} intf_ack
virtual function -install /tb_mnist_top/U_mnist_top/U_conv_layer_top_0/U_conv_layer_controller_0 -env /tb_mnist_top/U_mnist_top/U_network_manager_0 { (CMD_TYPE)/tb_mnist_top/U_mnist_top/U_conv_layer_top_0/U_conv_layer_controller_0/input_interface_cmd} intf_cmd
