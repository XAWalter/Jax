module uart_reciever #(parameter CLKS_PER_BIT = 127)
	(
		input i_clk,
		input i_data,
		output o_done,
		output [7:0] o_data
	);

	// States
	parameter WAIT = 3'b000;
	parameter START_BIT_CHECK = 3'b001;
	parameter GET_DATA = 3'b010; 
	parameter LAST_BIT_CHECK = 3'b011;
	parameter RESET = 3'b100;

	// regs
	reg [2:0] state = 0;
	reg [2:0] bit_count = 0;
	reg [7:0] count = 0;
	reg [7:0] data = 0;
	reg done;

	assign o_data = data;
	assign o_done = done;

	always @(posedge i_clk) begin

		// transitions
		case (state)

			// Wait for Start bit
			WAIT: begin
				if (i_data == 0) begin
					state = START_BIT_CHECK;
				end
				else begin
					state = WAIT;
				end
			end

			// Make sure that is true start bit
			START_BIT_CHECK: begin
				if(count >= (CLKS_PER_BIT-1)/2) begin
					count = 0;
					if(i_data == 1'b0) begin
						state = GET_DATA;
					end
					else begin
						state = WAIT;
					end
				end
				else begin
					state = START_BIT_CHECK;
				end
			end
	
			// Recive and Store data	
			GET_DATA: begin
				if(bit_count < 7) begin
					state = GET_DATA;
				end
				else begin
					bit_count = 0;
					state = LAST_BIT_CHECK;
				end
			end

			// Check for stop bit
			LAST_BIT_CHECK: begin
				if(count >= (CLKS_PER_BIT-1)) begin
					done = 1'b1;
					count = 0;
					state = RESET;
				end
				else begin
					state = LAST_BIT_CHECK;
				end
			end

			// Reset to initial conditions
			RESET: begin
				state = WAIT;
			end
		endcase
		
		// actions
		case (state)
			
			WAIT: begin
			end

			START_BIT_CHECK: begin
				count = count + 1;
			end

			GET_DATA: begin
				if(count >= CLKS_PER_BIT-1) begin
					count = 0;
					data[bit_count] = i_data;
					bit_count = bit_count + 1;
				end
				else  begin
					count = count + 1;
				end
			end

			LAST_BIT_CHECK: begin
				count = count + 1;
			end

			RESET: begin
				count = 0;
				done = 1'b0;
			end

		endcase
	end

endmodule

