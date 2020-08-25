`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: comparator
// Description: 
//      This module compares two contant values, A and B. 
//      If B is bigger than A then the PWM output will be 1,
//      otherwise it will be zero. This creates the waveform
//      that drives the servos.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module comparator (
	input [19:0] A,
	input [19:0] B,
	input [19:0] C,
	input [19:0] D,
	output reg io_PMOD_1,//Servo 1 (left/right)
	output reg io_PMOD_2,//Servo 2 (up/down)
	output reg io_PMOD_3 //Servo 3 (fire)
);

    // Run when A or B change
	always @ (A,B)
	begin
	// If A is less than B
	// output is 1.
	if (A < B)
		begin
		io_PMOD_1 <= 1'b1;//PWM <= 1'b1;
		end
	// If A is greater than B
	// output is 0.
	else 
		begin
		io_PMOD_1 <= 1'b0;//PWM <= 1'b0;
		end
	end
	
	// Run when A or C change
	always @ (A,C)
	begin
	// If A is less than C
	// output is 1.
	if (A < C)
		begin
		io_PMOD_2 <= 1'b1;//PWM <= 1'b1;
		end
	// If A is greater than C
	// output is 0.
	else 
		begin
		io_PMOD_2 <= 1'b0;//PWM <= 1'b0;
		end
	end
	
	// Run when A or D change
	always @ (A,D)
	begin
	// If A is less than D
	// output is 1.
	if (A < D)
		begin
		io_PMOD_3 <= 1'b1;//PWM <= 1'b1;
		end
	// If A is greater than D
	// output is 0.
	else 
		begin
		io_PMOD_3 <= 1'b0;//PWM <= 1'b0;
		end
	end
endmodule
