`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:07:59 01/01/2017 
// Design Name: 
// Module Name:    menu_ps2_keyboard 
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
module menu_ps2_keyboard(
	input clk, // 100Mʱ���ź�
	input rst_n, // ��λ�ź�
	input ps2_clk, // PS2�ӿ�ʱ���ź�
	input ps2_dat, // PS2�ӿ������ź�
	output reg w_press,
	output reg s_press,
	output reg enter_press
    );
	reg [3:0] cnt;
	reg key_release;
	reg [7:0] ps2_byte_buf; // �ɼ������ֽڵĻ���
		always @(negedge ps2_clk or negedge rst_n )
		begin//always begin
			if (!rst_n)
			begin
				cnt = 0;
				w_press = 0; 
				s_press = 0; 
				enter_press = 0;
			end
			else
			begin//�ǳ�ʼ�� begin
					case (cnt)
						4'h1 : ps2_byte_buf[0] = ps2_dat; // bit0
						4'h2 : ps2_byte_buf[1] = ps2_dat; // bit1
						4'h3 : ps2_byte_buf[2] = ps2_dat; // bit2
						4'h4 : ps2_byte_buf[3] = ps2_dat; // bit3
						4'h5 : ps2_byte_buf[4] = ps2_dat; // bit4
						4'h6 : ps2_byte_buf[5] = ps2_dat; // bit5
						4'h7 : ps2_byte_buf[6] = ps2_dat; // bit6
						4'h8 : ps2_byte_buf[7] = ps2_dat; // bit7
						default : ;
					endcase
					cnt = cnt + 1'b1;
					
					if (cnt == 4'hB)
					begin//���� begin
						cnt = 4'h0;
						if (ps2_byte_buf == 8'hF0)
						begin
							key_release = 1;
						end
						else 
						begin//�Ƕ��� begin
							if (!key_release)
							begin
								case (ps2_byte_buf)
									8'h1D : w_press = 1'b1; 
									8'h1B : s_press = 1'b1;
									8'h5A : enter_press = 1'b1;
								endcase
							end
							else
							begin
								case (ps2_byte_buf)
									8'h1D : w_press = 1'b0; 
									8'h1B : s_press = 1'b0;
									8'h5A : enter_press = 1'b0;
								endcase
								key_release = 1'b0;
							end
						end//�Ƕ��� end
						
					end//���� end
			
			
			end//�ǳ�ʼ�� end
		end//always end
endmodule
