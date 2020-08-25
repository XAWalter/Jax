module uart_mods(
	input wire i_Clk,
	input wire i_UART_RX,
	output wire o_LED_1,
	output wire o_LED_2,
	output wire o_LED_3,
	output wire o_LED_4,
	output wire o_Segment1_A
);

	wire w_done;
	wire [7:0] w_data;

	

	uart_reciever ur01(
		.i_clk(i_Clk),
		.i_data(i_UART_RX),
		.o_done(w_done),
		.o_data(w_data)
	);


	uart_decode ud01(
		.i_clk(i_Clk),
		.i_done(w_done),
		.i_data(w_data),
		.o_right(o_LED_1),
		.o_left(o_LED_2),
		.o_up(o_LED_3),
		.o_down(o_LED_4),
		.o_trigger(o_Segment1_A)
	);

endmodule

