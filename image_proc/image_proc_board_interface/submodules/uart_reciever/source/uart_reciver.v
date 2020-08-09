module uart_reciever #(parameter CLKS_PER_BIT = 217)
	(
		input i_clk,
		input i_data,
		output o_done,
		output [7:0] o_data
	);

	// States
	parameter INIT = 3'b000;
	parameter WAIT = 3'b001;
	parameter START_BIT_CHECK = 3'b010;
	parameter GET_DATA = 3'b011; 
	parameter LAST_BIT_CHECK = 3'b100;
	parameter RESET = 3'b101;

	// regs
	reg [2:0] state = WAIT;
	reg [2:0] bit_count = 0;
	reg [7:0] count = 0;
	reg [7:0] data = 0;
	reg done = 0;


	always @(posedge i_clk) begin

		// transitions
		case (state)

			INIT: begin
				done <= 1'b0;
				data <= 8'h00;
				count <= 0;
				bit_count <= 0;
				state <= WAIT;


			end

			// Wait for Start bit
			WAIT: begin

				if (i_data == 1'b0) begin
					state <= START_BIT_CHECK;
				end
				else begin
					state <= WAIT;
				end
			end

			// Make sure that is true start bit
			START_BIT_CHECK: begin
				if(count == (CLKS_PER_BIT-1)/2) begin
					if(i_data == 1'b0) begin
						state <= GET_DATA;
					end
					else begin
						state <= WAIT;
					end
				end
				else begin
					state <= START_BIT_CHECK;
				end
			end
	
			// Recive and Store data	
			GET_DATA: begin
				if(count < CLKS_PER_BIT - 1) begin
					state <= GET_DATA;
				end
				else begin

					if(bit_count < 7) begin
						state <= GET_DATA;
					end
					else begin
						state <= LAST_BIT_CHECK;
					end
				end
			end

			// Check for stop bit
			LAST_BIT_CHECK: begin
				if(count < (CLKS_PER_BIT - 1)) begin
					state <= LAST_BIT_CHECK;
				end
				else begin
					state <= RESET;
				end
			end

			// Reset to initial conditions
			RESET: begin
				state <= WAIT;
			end

			default:
				state <= WAIT;

		endcase


		// Actions
		case (state)
			INIT: begin
				
			end

			WAIT: begin
				done <= 1'b0;
				count <= 0;
				bit_count <= 0;
				
			end

			START_BIT_CHECK: begin
				if(count == (CLKS_PER_BIT-1)/2) begin
					count <= 0;
				end
				else begin	
					count  <= count + 1;
				end

			end

			GET_DATA: begin
				if(count < CLKS_PER_BIT - 1) begin
					count <= count + 1;
				end
				else begin
					count <= 0;
					data[bit_count] <= i_data;
					if(bit_count < 7) begin
						bit_count <= bit_count + 1;
					end
					else begin
						bit_count <= 0;
					end
				end
			end

			LAST_BIT_CHECK: begin
				if(count < (CLKS_PER_BIT - 1)) begin
					count <= count + 1;
				end
				else begin
					done <= 1'b1;
					count <= 0;
				end
			end

			RESET: begin
				done <= 1'b0;
			end
		endcase

	end

	assign o_data = data;
	assign o_done = done;

endmodule
