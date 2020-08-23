`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:55:01 07/23/2020 
// Design Name: 
// Module Name:    manual_logic 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module automatic_logic(
    );
	 
input clk, //clock
		manual, //true or false
		i_Switch_1, //switches for testing
		i_Switch_2;
	
output x_position; //current position on x-axis

//add equation or number for movement
reg movement = 0;//distance to move for each button press 
		
//states
localparam idle = 2'b00;
localparam left = 2'b01;
localparam right = 2'b10;

//next and current states
reg[1:0] present_state, next_state;

//output logic
always @(present_state)
begin
	case (present_state)
		//wait
		idle:
			x_position = x_position;
			
		//left
		left:
			x_postion = x_position - movement; //move 3cm to the right
		
		//right
		right:
			x_postion = x_position + movement; //move 3cm to the right
		
		//default
		default:
			x_postion = x_position;
		
	endcase
          
end

//state logic
always @(posedge clk)
begin
	case (present_state)
		//wait
		idle:
		begin
			if (manual && i_Switch_1 && !i_Switch_2)
				next_state = left;
			else if (manual && i_Switch_2 && !i_Switch_1)
				next_state = right;
			else
				next_state = idle;
		end	
		
		//left
		left:
		begin
			if (manual && i_Switch_1 && !i_Switch_2)
				next_state = left;
			else if (manual && i_Switch_2 && !i_Switch_1)
				next_state = right;
			else
				next_state = idle;
		end	
			
		//right
		right:
		begin
			if (manual && i_Switch_1 && !i_Switch_2)
				next_state = left;
			else if (manual && i_Switch_2 && !i_Switch_1)
				next_state = right;
			else
				next_state = idle;
		end	
			
		//default
		default:
			next_state = idle;
	endcase
	
end

//state register
always @ (posedge clk)
begin
	present_state = next_state;
end


endmodule
