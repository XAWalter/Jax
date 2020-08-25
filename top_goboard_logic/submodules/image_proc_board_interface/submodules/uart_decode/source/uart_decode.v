module uart_decode
	(
		input i_clk,
		input i_done,
		input [7:0] i_data,
		output o_right,
		output o_left,
		output o_up,
		output o_down,
		output o_trigger
	);

	assign o_right = i_data[0];
	assign o_left = i_data[1];
	assign o_up = i_data[2];
	assign o_down = i_data[3];
	assign o_trigger = ~i_data[4];

endmodule
