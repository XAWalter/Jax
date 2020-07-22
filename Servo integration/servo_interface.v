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
	 output io_PMOD_1//PWM
    );
    
    wire [19:0] A_net;
    wire [19:0] value_net;
    wire [8:0] angle_net;
    
    // Convert the incoming switch value
    // to an angle.
    sw_to_angle converter(
        //.sw(sw),
        .i_Switch_1(i_Switch_1),
        .i_Switch_2(i_Switch_2),
        .i_Switch_3(i_Switch_3),
        .i_Switch_4(i_Switch_4),
		  .angle(angle_net),
		  .o_LED_1(o_LED_1),
		  .o_LED_2(o_LED_2),
		  .o_LED_3(o_LED_3),
		  .o_LED_4(o_LED_4)
        );
    
    // Convert the angle value to 
    // the constant value needed for the PWM.
    angle_decoder decode(
        .angle(angle_net),
        .value(value_net)
        );
    
    // Compare the count value from the
    // counter, with the constant value set by
    // the switches.
    comparator compare(
        .A(A_net),
        .B(value_net),
        .io_PMOD_1(io_PMOD_1)
        );
      
    // Counts up to a certain value and then resets.
    // This module creates the refresh rate of 20ms.   
    counter count(
        .clr(clr),
        .i_Clk(i_Clk),
        .count(A_net)
        );
        
endmodule
