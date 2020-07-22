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
    input [8:0] angle,
    output reg [19:0] value
    );
    
    // Run when angle changes
    always @ (angle)
    begin
        // The angle gets converted to the 
        // constant value. This equation
        // depends on the servo motor used 
        value = (10'd944)*(angle)+ 16'd60000;
    end
endmodule
