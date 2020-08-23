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
module sw_to_angle(
    input i_Clk, //clock
			 //manual, //true or false 
			 i_Switch_1, //switches for testing
			 i_Switch_2,
			 i_Switch_3,
			 i_Switch_4,
	 input x_target, //automated target x-axis val
	 input y_target, //automated target y-axis val
	// input x_pos,
	// input y_pos,
	 output reg [3:0] x_angle, //angle value for PWM
	 output reg [3:0] y_angle, //angle value for PWM
	 output reg [3:0] a_xangle, //angle value for PWM
	 output reg [3:0] a_yangle, //angle value for PWM
	 output reg [3:0] fire_angle, //angle value for PWM
	 output reg o_LED_1, //LEDS for testing
	 output reg o_LED_2,
	 output reg o_LED_3,
	 output reg o_LED_4
    );
    
//manual states
localparam idle1 = 5'b00001;
localparam idle2 = 5'b00010;
localparam m_left = 5'b00011;
localparam m_right = 5'b00100;
localparam m_up = 5'b00101;
localparam m_down = 5'b00110;
//localparam start1 = 5'b00111;
//localparam start2 = 5'b01000;
localparam m_left_release = 5'b01001;
localparam m_right_release = 5'b01010;
localparam m_up_release = 5'b01011;
localparam m_down_release = 5'b01100;

//automatic states
localparam idle3 = 5'b10100;
localparam idle4 = 5'b10101;
localparam a_left = 5'b01101;
localparam a_right = 5'b01110;
localparam a_up = 5'b01111;
localparam a_down = 5'b10000;

//fire
localparam notFire = 5'b10001;
localparam fire = 5'b10010;
localparam recoil = 5'b10011;


//reg[30:0] cnt = 0; //cnt for set up
//reg[30:0] fireCnt = 0;
//reg[30:0] recoilCnt = 0;

//where it currently is on x_axis and y_axis
reg[24:0] x_axis = 0;
reg[24:0] y_axis = 0;

//offset for bounds
//reg[24:0] x_offset = 0;
//reg[24:0] y_offset = 0;

//next and current states
reg[4:0] present_state1, next_state1;
reg[4:0] present_state2, next_state2;
reg[4:0] present_state3, next_state3;
reg[4:0] present_state4, next_state4;
reg[4:0] present_state5, next_state5;

//manual left/right
//output logic
always @(present_state1)
begin
	case (present_state1)		
		//wait
		idle1:
			begin
			x_angle = 9'd0; //move 0 deg
			o_LED_1 <= 1'b0;//LED for testing purposes (to check if button pressed)
			o_LED_2 <= 1'b0;
			end
			
		//left
		m_left:
			begin
			//move to the left
			x_angle = 9'd1; 
			o_LED_1 <= 1'b1;
			end
			
		//right
		m_right:
			begin
			//move to the right
			x_angle = 9'd2; 
			o_LED_2 <= 1'b1;		
			end
		
		//left button released
		m_left_release:
			begin
			//no movement for transition
			x_angle = 9'd5; 
			o_LED_1 <= 1'b0;
			o_LED_2 <= 1'b0; 
			end
	
		//right button released
		m_right_release:
			begin
			//no movement for transition
			x_angle = 9'd5; 
			o_LED_1 <= 1'b0;
			o_LED_2 <= 1'b0; 
			end
		
		//default
		default:
			begin
			x_angle = 9'd5; //move 0 deg
			o_LED_1 <= 1'b0;
			o_LED_2 <= 1'b0;
			end
			
	endcase
          
end

//state logic
always @(posedge i_Clk)
begin
	//**NOTE** !manual for testing with switch purposes, may want to switch to manual for ease of reading later
	case (present_state1)
		//wait
		idle1:
		begin
			if (/*!manual &&*/ i_Switch_1 && !i_Switch_2)
				next_state1 = m_left;
			else if (/*!manual &&*/!i_Switch_1 && i_Switch_2)// && x_axis < 22727272)
				next_state1 = m_right;
			else
				next_state1 = idle1;
		end	
		
		//left
		m_left:
		begin
			if (/*!manual &&*/ i_Switch_1 && !i_Switch_2)
				next_state1 = m_left;
			else
				next_state1 = m_left_release;
			end	
			
		//right
		m_right:
		begin
			if (/*!manual &&*/ i_Switch_2 && !i_Switch_1)// && x_axis < 22727272)
				next_state1 = m_right;
			else 
				next_state1 = m_right_release;
			end	
		
		//left button release
		m_left_release:
		begin
				next_state1 = idle1;
		end
		
		//right button release
		m_right_release:
		begin
				next_state1 = idle1;
		end
		
		default:
			next_state1 = idle1;
	endcase
	
end

//manual up/down
//output logic
always @(present_state2)
begin
	case (present_state2)
		//wait
		idle2:
			begin
			y_angle = 9'd0; //move 0 deg
			o_LED_3 <= 1'b0;
			o_LED_4 <= 1'b0;
			end
			
		//up
		m_up:
			begin
			//move upwards 
			y_angle = 9'd1; 
			o_LED_3 <= 1'b1;
			end
			
		//down
		m_down:
			begin
			//move downwards
			y_angle = 9'd2; 
			o_LED_4 <= 1'b1;		
			end
		
		//up button released
		m_up_release:
			begin
			//no movement for transition
			y_angle = 9'd5; 
			o_LED_4 <= 1'b0;
			o_LED_3 <= 1'b0; 
			end
	
		//down button released
		m_down_release:
			begin
			//no movement for transition
			y_angle = 9'd5; 
			o_LED_3 <= 1'b0;
			o_LED_4 <= 1'b0; 
			end
		
			
		//default
		default:
			begin
			y_angle = 9'd0; //move 0 deg
			o_LED_3 <= 1'b0;
			o_LED_4 <= 1'b0;
			end
			
	endcase
          
end

//state logic
always @(posedge i_Clk)
begin
	//**NOTE** !manual for testing with switch purposes, may want to switch to manual for ease of reading later
	case (present_state2)
		//wait
		idle2:
		begin
			if (/*!manual &&*/ i_Switch_3 && !i_Switch_4) 
				next_state2 = m_up;
			else if (/*!manual &&*/ i_Switch_4 && !i_Switch_3)// && y_axis < 22727272)
				next_state2 = m_down;
			else
				next_state2 = idle2;
		end	
				
		//up
		m_up:
		begin
			if (/*!manual &&*/ i_Switch_3 && !i_Switch_4)
				next_state2 = m_up;
			else
				next_state2 = m_up_release;
		end	
			
		//down
		m_down:
		begin
			if (/*!manual &&*/ i_Switch_4 && !i_Switch_3)// && y_axis < 22727272)
				next_state2 = m_down;
			else
				next_state2 = m_down_release;
		end	

		//up button released
		m_up_release:
		begin
			next_state2 = idle2;
		end
		
		//down button released
		m_down_release:
		begin
			next_state2 = idle2;
		end

		default:
			next_state2 = idle2;
	endcase
	
end

//*** Automic and fire states currently commented out for testing bounds on FPGA solely ***//
/* 
//automatic left/right
//output logic
always @(present_state3)
begin
	case (present_state3)		
		//wait
		idle3:
			begin
			a_xangle = 9'd0; //move 0 deg
			end
			
		//left
		a_left:
			begin
			//move left
			a_xangle = 9'd1; 
			end
			
		//right
		a_right:
			begin
			//move to the right
			a_xangle = 9'd2;
			end
			
		//default
		default:
			begin
			a_xangle = 9'd0; //move 0 deg
			end
			
	endcase
          
end

//state logic
always @(posedge i_Clk)
begin
	//**NOTE** !manual for testing with switch purposes, may want to switch to manual for ease of reading later
	case (present_state3)
		
		//wait
		idle3:
		begin
			if (manual && x_axis > 200000000)//x_target) 
				next_state3 = a_left;
			else if (manual && x_axis < 200000000)//x_target) 
				next_state3 = a_right;
			else
				next_state3 = idle3;
		end	
		
		//left
		a_left:
		begin
			if (manual && x_axis > 200000000)//x_target) 
				next_state3 = a_left;
			else if (manual && x_axis < 200000000)//x_target) 
				next_state3 = a_right;
			else
				next_state3 = idle3;
		end	
			
		//right
		a_right:
		begin
			if (manual && x_axis > 200000000)//x_target) 
				next_state3 = a_left;
			else if (manual && x_axis < 200000000)//x_target) 
				next_state3 = a_right;
			else
				next_state3 = idle3;
		end	
		
		default:
			next_state3 = idle3;
	endcase
	
end

//automatic up/down
//output logic
always @(present_state4)
begin
	case (present_state4)
		//wait
		idle4:
			begin
			a_yangle = 9'd0; //move 0 deg
			end
			
		//up
		a_up:
			begin
			//move upward
			a_yangle = 9'd1;
			end
			
		//down
		a_down:
			begin
			//move downward
			a_yangle = 9'd2; 
			end
			
		//default
		default:
			begin
			a_yangle = 9'd0; //move 0 deg
			end
			
	endcase
          
end

//state logic
always @(posedge i_Clk)
begin
	//**NOTE** !manual for testing with switch purposes, may want to switch to manual for ease of reading later
	case (present_state4)
		//wait
		idle4:
		begin
			if (manual && y_axis < 200000000)//0) 
				next_state4 = a_up;
			else if (manual && y_axis > 200000000)//y_target) 
				next_state4 = a_down;
			else
				next_state4 = idle4;
		end	
		
		//up
		a_up:
		begin
			if (manual && y_axis < 200000000)//y_target) 
				next_state4 = a_up;
			else if (manual && y_axis > 200000000)//y_target) 
				next_state4 = a_down;
			else
				next_state4 = idle4;
		end	
			
		//down
		a_down:
		begin
			if (manual && y_axis < 200000000) 
				next_state4 = a_up;
			else if (manual && y_axis > 200000000) 
				next_state4 = a_down;
			else
				next_state4 = idle4;
		end	

		default:
			next_state4 = idle4;
	endcase
	
end

//fire
//output logic
always @(present_state5)
begin
	case (present_state5)
		//wait
		notFire:
			begin
				fire_angle = 9'd0; //do nothing
			end
			
		//fire
		fire:
			begin
				fire_angle = 9'd1; 
			end
			
		//recoil
		recoil:
			begin
				fire_angle = 9'd2; //reset
			end
			
		//default
		default:
			begin
				fire_angle = 9'd0;
			end
			
	endcase
          
end

//state logic
always @(posedge i_Clk)
begin
	case (present_state5)
		//wait
		notFire:
		begin
			if(manual && x_axis == 200000000)begin//x_target)begin
				next_state5 = fire;
			end
			else if (!manual && i_Switch_4)begin
				next_state5 = fire;
			end
			else begin
				next_state5 = notFire;
			end
		end	
		
		//fire
		fire:
		begin
			if(fireCnt < 250000000)begin //update with angle needed to fire
				next_state5 = fire;
			end
			else
				next_state5 = recoil;
		end	
			
		//recoil
		recoil:
		begin
			if(recoilCnt < 100000000)begin //update with angle for servo at rest
				next_state5 = recoil;
			end
			else
				next_state5 = notFire;
		end	

		default:
		begin
			next_state5 = recoil;
		end
	endcase
	
end
*/


//state register
always @ (posedge i_Clk)
begin
		
/*	//check if manual reached bounds
	//left/right bounds
	if (present_state1 == m_left && x_axis > 0)begin
		x_axis <= x_axis - 1;
	end
	else if (present_state1 == m_right && x_axis < 22727272)begin//250000000) begin
		x_axis <= x_axis + 1;
	end
	
	//up/down bounds
	if (present_state2 == m_up && y_axis > 0)begin
		y_axis <= y_axis - 1;
	end
	else if (present_state2 == m_down && y_axis < 22727272)begin//250000000) begin
		y_axis <= y_axis + 1;
	end	*/
	
/*	//automatic check if reached target /////////////////////////////////////
	if (x_axis != 200000000)begin //replace 200000000 with x_target
		if (present_state3 == a_left && x_axis > 0) begin
			x_axis <= x_axis - 3'b1;
		end
		else if (present_state3 == a_right && x_axis < 250000000) begin
			x_axis <= x_axis + 3'b1;
		end
	end
	if (y_axis != 200000000) begin //replace 200000000 with y_target
		if (present_state4 == a_down && y_axis > 0) begin
			y_axis <= y_axis - 3'b1;
		end
		else if (present_state4 == a_up && y_axis < 250000000) begin
			y_axis <= y_axis + 3'b1;
		end
	end
	
	//fire check 
	if(present_state5 == fire && fireCnt < 250000000)begin
		fireCnt <= fireCnt + 1'b1;
	end
	else if (present_state5 == recoil && recoilCnt < 100000000)begin
		recoilCnt <= recoilCnt + 1'b1;
	end
	else if (present_state5 == notFire)begin
		fireCnt <= 0;
		recoilCnt <= 0;
	end	*/////////////////////////////////////////
		
	//state change
	present_state1 = next_state1;
	present_state2 = next_state2;
	//present_state3 = next_state3;
	//present_state4 = next_state4;
	//present_state5 = next_state5;
	
	
end

endmodule
