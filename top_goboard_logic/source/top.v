module top(
	input i_Clk,
	input i_UART_RX,
	output io_PMOD_1,
	output io_PMOD_2,
	output io_PMOD_3
);

	wire w_left;
	wire w_right;
	wire w_up;
	wire w_down;
	wire w_trigger;

	uart_mods um01(
		.i_Clk(i_Clk),
		.i_UART_RX(i_UART_RX),
		.o_LED_1(w_left),
		.o_LED_2(w_right),
		.o_LED_3(w_up),
		.o_LED_4(w_down),
		.o_Segment1_A(w_trigger)
	);

	Servo_interface si01(
		.i_Switch_1(w_left),
		.i_Switch_2(w_right),
		.i_Switch_3(w_up),
		.i_Switch_4(w_down),
		.trigger(w_trigger),
		.i_Clk(i_Clk),
		.io_PMOD_1(io_PMOD_1),
		.io_PMOD_2(io_PMOD_2),
		.io_PMOD_3(io_PMOD_3)
	);

endmodule



