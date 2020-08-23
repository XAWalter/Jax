`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: angle_decoder
// Description: 
//      This module takes in an angle value
//      and converts it into the PWM constant 
//      the servo needs to hold that angle.
//
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module angle_decoder(
    input [3:0] x_angle,
	 input [3:0] y_angle,
    input [3:0] a_xangle,
	 input [3:0] a_yangle,
	 input [3:0] fire_angle,
	 output reg [19:0] x_value,
	 output reg [19:0] y_value,
	 output reg [19:0] fire_value
    );
    
    // Run when x angle changes
    always @ (x_angle, a_xangle)
    begin
        // The angle gets converted to the 
        // constant value.  
      
		//x_axis
		  if (x_angle == 1 || a_xangle == 1) //left
				x_value = 16'd60000; //45250 for bounded left side
											//60000 to move left without bound
		  else if (x_angle == 2 || a_xangle == 2)//right
				x_value = 16'd15000; //move right unbounded (unless bound set in angle_convert.v)
		  else if (x_angle == 5 || a_xangle == 5)//released
				x_value = 16'd75000;
		  else 
				x_value = 16'd70000;	//no change	 
    end
	 
	 //run when y angle changes
	 always @ (y_angle, a_yangle)
    begin
       //y_axis
		  if (y_angle == 1 || a_yangle == 1) //up
				y_value = 16'd60000;//45250 for bounded left side
 										  //60000 to move left without bound
		  else if (y_angle == 2 || a_yangle == 2) //down
				y_value = 16'd15000; //move down unbounded (unless set in angle_convert.v)
		  else if (y_angle == 5 || a_yangle == 5)//released
				y_value = 16'd75000;
		  else 
				y_value = 16'd70000; //no change
    end
	 
    always @ (fire_angle)
    begin
        //fire servo
		  if (fire_angle == 1) //fire
				fire_value = 16'd60000; 
		  else if (fire_angle == 2) //recoil
				fire_value = 16'd15000;
		  else 
				fire_value = 16'd0; //no change		 
    end
endmodule
