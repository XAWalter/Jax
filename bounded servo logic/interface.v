`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: Servo_interface
// Description: 
//      This module creates the PWM signal needed to drive
//      one servo using the PmodCON3. To use the other 3 servo connectors,
//      you can instantiate this module 4 times, or send the same PWM sigal to 
//      four Pmod connector pins. This depends on whether you want the same servo signal, 
//      or different servo signals. 
// 
//////////////////////////////////////////////////////////////////////////////////
module Servo_interface (
    input i_Switch_1, //sw1
    input i_Switch_2, //sw2
	 input i_Switch_3, //sw3
	 input i_Switch_4, //sw4
	 input clr, 
    input i_Clk,//clk,
	 //LEDS on Go Board for check during testing
    output o_LED_1, //LED1
	 output o_LED_2, //LED2
	 output o_LED_3, //LED3
	 output o_LED_4, //LED4
	 //PWM for servo
	 output io_PMOD_1,
	 output io_PMOD_2, 
	 output io_PMOD_3
    );
    
    wire [19:0] A_net;
    wire [19:0] x_value_net;
    wire [19:0] y_value_net;
	 wire [19:0] fire_value;
    wire [3:0] x_angle;
	 wire [3:0] y_angle;
	 wire [3:0] a_xangle;
	 wire [3:0] a_yangle;
	 wire [3:0] fire_angle;
	 
	 //for testing purposes
	 reg[30:0] x_target = 250000000;
	 reg[30:0] y_target = 250000000;
//	 reg[30:0] x_pos = 0;
//	 reg[30:0] y_pos = 0;
    
    // Convert the incoming switch value
    // to an angle.
    sw_to_angle converter(
        .i_Clk(i_Clk), //clock
		  //.manual(i_Switch_3), //manual *Change input to manual/automitic input for device when able to
		  //switches for testing, replace with manual direction inputs from device
		  .i_Switch_1(i_Switch_1), //left
		  .i_Switch_2(i_Switch_2), //right
		  .i_Switch_3(i_Switch_3), //up
		  .i_Switch_4(i_Switch_4), //down
		  .x_target(x_target), // automatic target value for x-axis, currently hard coded need to adjust later
		  .y_target(y_target),// automatic target value for y-axis, currently hard coded need to adjust later
//		  .x_pos(x_pos),// current x position
//		  .y_pos(y_pos),// current y position
			//angles value for PWM
		  .x_angle(x_angle), //manual x axis
		  .y_angle(y_angle), //manual y axis
		  .a_xangle(a_xangle), //automatic x axis
		  .a_yangle(a_yangle), //automatic y axis
		  .fire_angle(fire_angle), //fire servo
		  //LEDS for testing may want to remove later
		  .o_LED_1(o_LED_1), 
		  .o_LED_2(o_LED_2),
		  .o_LED_3(o_LED_3),
		  .o_LED_4(o_LED_4)
        );
		  
    // Convert the angle value to 
    // the constant value needed for the PWM.
    angle_decoder decode(
        //input angle values
		  .x_angle(x_angle),
        .y_angle(y_angle),
		  .a_xangle(a_xangle),
		  .a_yangle(a_yangle),
		  .fire_angle(fire_angle),
		  //output PWM constant
        .x_value(x_value_net),
        .y_value(y_value_net),
		  .fire_value(fire_value)
        );
    
    // Compare the count value from the
    // counter, with the constant value set by
    // the switches.
    comparator compare(
        .A(A_net),
        .B(x_value_net),
		  .C(y_value_net),
		  .D(fire_value),
		  //output to PMOD for servo movement
        .io_PMOD_1(io_PMOD_1),
		  .io_PMOD_2(io_PMOD_2),
		  .io_PMOD_3(io_PMOD_3)
        );
      
    // Counts up to a certain value and then resets.
    // This module creates the refresh rate of 20ms.   
    counter count(
        .clr(clr),
        .i_Clk(i_Clk),
        .count(A_net)
        );
        
endmodule
