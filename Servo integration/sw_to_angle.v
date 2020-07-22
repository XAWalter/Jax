`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: sw_to_angle
// Description: 
//      This module takes the switch values as an input
//      and converts them to a degree value. 
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Convert from switch value to angle
// Each switch provides a different angle in degrees, starting
// at 0, incrementing by 90 degrees each switch. 
module sw_to_angle(
    input i_Switch_1,
	 input i_Switch_2,
	 input i_Switch_3,
	 input i_Switch_4,
	 output reg [8:0] angle,
	 output reg o_LED_1,
	 output reg o_LED_2,
	 output reg o_LED_3,
	 output reg o_LED_4
    );
    
    // Run when the value of the switches
    // changes
    always @*
    begin
        if(i_Switch_1) //if sw1
			begin
				angle = 9'd90; //move 90 deg
				o_LED_1 <= 1'b1; 
				o_LED_2 <= 1'b0;
				o_LED_3 <= 1'b0;
				o_LED_4 <= 1'b0;
			end
		  
		  else if(i_Switch_2) //if sw2
			begin
			  angle = 9'd180;//move 180 deg
			  o_LED_1 <= 1'b0;
			  o_LED_2 <= 1'b1;
			  o_LED_3 <= 1'b0;
			  o_LED_4 <= 1'b0;
			end
		  
		  else if(i_Switch_3) //if sw3
			begin
			  angle = 9'd270;//move 270 deg
			  o_LED_1 <= 1'b0;
			  o_LED_2 <= 1'b0;
			  o_LED_3 <= 1'b1;
			  o_LED_4 <= 1'b0;
			end
		  
		  else if(i_Switch_4) //if sw4
			begin
				angle = 9'd360; //move 360 deg
				o_LED_1 <= 1'b0;
				o_LED_2 <= 1'b0;
				o_LED_3 <= 1'b0;
				o_LED_4 <= 1'b1;
			end
			
		  else
			begin
			  angle = 9'd0; //move 0 deg
			  o_LED_1 <= 1'b0;
			  o_LED_2 <= 1'b0;
			  o_LED_3 <= 1'b0;
			  o_LED_4 <= 1'b0;
			end
    end
endmodule
