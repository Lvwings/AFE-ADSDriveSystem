`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:09 03/03/2020 
// Design Name: 
// Module Name:    CLK_SAMPLE_EN 
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
module CLK_SAMPLE_EN(
	input CLK_100M,
	input CLK_RST,
	output SAMPLE_EN
    );

reg [15:0] clk_cnt = 0;
reg sample_enr = 0;
assign SAMPLE_EN = sample_enr;

always @(posedge CLK_100M or posedge CLK_RST) begin
	if (CLK_RST) begin
		clk_cnt <= 0;
		sample_enr <= 0;
	end
	else begin
		if (clk_cnt == 16'd16000) begin
			clk_cnt <= 0;
			sample_enr <= 1;
		end
		else begin
			clk_cnt <= clk_cnt + 1;
			sample_enr <= 0;
		end
	end
		
end

endmodule
