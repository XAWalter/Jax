module uart_decode
	(
		input i_clk,
		input i_done,
		input [7:0] i_data,
		output o_right,
		output o_left,
		output o_down,
		output o_up,
		output o_trigger
	);

	assign o_right =  (i_data == 8'h02) ? 1 : 0;
	assign o_left = (i_data == 8'h00) ? 1 : 0;
	assign o_down = (i_data == 8'h05) ? 1 : 0;
	assign o_up = (i_data == 8'h03) ? 1 : 0;
	assign o_trigger = (i_data == 8'h06) ? 1 : 0;

endmodule
