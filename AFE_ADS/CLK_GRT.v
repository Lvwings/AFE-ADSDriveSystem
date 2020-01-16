`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:07:54 01/09/2020 
// Design Name: 
// Module Name:    CLK_GRT 
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
module CLK_GRT(
//--- GLOBAL ---
    input sys_rst_n,	//reset input, low is valid
    input sys_clk,		//system clock	
	
//--- output ---
	output CLK_100M,
	output CLK_ADS,
	output CLK_RST		//reset hign valid 
    );
wire clk_100m_r,clk_ads_r,LOCKED;
wire sys_rst_r;
wire clk_clk;

assign CLK_100M = clk_100m_r & LOCKED;
assign CLK_ADS 	= clk_ads_r  & LOCKED;
assign CLK_RST = ~sys_rst_r;
//---------------------------------------
IBUFG rst_IBUFG
(
.I(sys_rst_n),               //FPGA引脚输入复位信号
.O(sys_rst_r)
);

BUFG clk_IBUFG
(
.I(sys_clk),
.O(clk_clk)
);
//---------------------------------------
  INTER_CLK_GTR INTER_CLK_GTR
   (// Clock in ports
    .SYS_CLK		(clk_clk),      // IN
    // Clock out ports
    .CLK_ADS		(clk_ads_r),    // OUT
    .CLK_100M		(clk_100m_r),   // OUT
    // Status and control signals
    .RESET			(~sys_rst_r),	// IN
    .LOCKED			(LOCKED));      // OUT
endmodule
