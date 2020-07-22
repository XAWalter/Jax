`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Kaitlyn Franz
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
	output reg io_PMOD_1//PWM
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
endmodule