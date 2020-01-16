`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:41:14 01/09/2020 
// Design Name: 
// Module Name:    AFE_ADS_TOP 
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
module AFE_ADS_TOP(
//--- GLOBAL ---
    input sys_rst_n,	//reset input, low is valid
    input sys_clk,		//system clock
	
//--- AFE PORTS ---
	//-- control ports --
	output AFE_CLK,		//outputs the analog voltage from each integrator channel on each rising edge
	output AFE_INTG,	//integrate pixel signal when high
	output AFE_IRST,	//Resets the AFE on rising edge
	output AFE_SHS,		//samples signal on rising edge
    output AFE_SHR,		//samples ‘reset’ level of integrator on rising edge  
    output AFE_PDZ,		//power down set
    output AFE_NAPZ,	//sleep mode set
    output AFE_ENTRI,	//High on this pin enables tri-state of analog output drivers after shift out of data for all 64 channels 
	input  AFE_STO,
	input  AFE_EOC,
	//-- mode ports --
	output AFE_SMT_MD,	// read mode set
	output AFE_INPUTZ,
	//-- compensation set --
    output AFE_DF_SM,	//Digital control to dump compensation charge on integrator capacitor,
	//-- PGA set --	
	output [2:0] AFE_PGA,	
	
//--- ADS PORTS ---
	output ADS_CLK,
	output ADS_CS_N,
	input  ADS_BUSY,
	output ADS_RD,
	output ADS_SDI,
	input  ADS_SDOA,
	input  ADS_SDOB,
	output [1:0] ADS_M,
	output ADS_CONVST
    );

wire CLK_100M,CLK_RST,CLK_ADS;
wire ADS_INIT_OK;
wire CLK_AFE;
wire [15:0]	ADS_ADATA,ADS_BDATA;
wire ADS_AVLAID,ADS_BVLAID;

assign AFE_CLK = CLK_AFE;

CLK_GRT CLK_GRT (
    .sys_rst_n(sys_rst_n), 
    .sys_clk(sys_clk), 
    .CLK_100M(CLK_100M), 
    .CLK_ADS(CLK_ADS), 
    .CLK_RST(CLK_RST)
    );

AFE_CTL AFE_CTL (
    .CLK_RST(CLK_RST), 
    .CLK_100M(CLK_100M), 
    .ADS_INIT_OK(ADS_INIT_OK), 
    .AFE_CLK(CLK_AFE), 
    .AFE_INTG(AFE_INTG), 
    .AFE_IRST(AFE_IRST), 
    .AFE_SHS(AFE_SHS), 
    .AFE_SHR(AFE_SHR), 
    .AFE_PDZ(AFE_PDZ), 
    .AFE_NAPZ(AFE_NAPZ), 
    .AFE_ENTRI(AFE_ENTRI), 
    .AFE_STI(AFE_STI), 
    .AFE_STO(AFE_STO), 
    .AFE_EOC(AFE_EOC), 
    .AFE_SMT_MD(AFE_SMT_MD), 
    .AFE_INPUTZ(AFE_INPUTZ), 
    .AFE_DF_SM(AFE_DF_SM), 
    .AFE_PGA(AFE_PGA)
    );	

ADS_CTL ADS_CTL (
    .CLK_RST(CLK_RST), 
    .CLK_ADS(CLK_ADS), 
    .CLK_AFE(CLK_AFE),
	.CLK_100M(CLK_100M), 	
    .ADS_CLK(ADS_CLK), 
    .ADS_CS_N(ADS_CS_N), 
    .ADS_BUSY(ADS_BUSY), 
    .ADS_RD(ADS_RD), 
    .ADS_SDI(ADS_SDI), 
    .ADS_SDOA(ADS_SDOA), 
    .ADS_SDOB(ADS_SDOB), 
    .ADS_M(ADS_M), 
    .ADS_CONVST(ADS_CONVST), 
	.ADS_ADATA	   ( ADS_ADATA	),
	.ADS_AVLAID    ( ADS_AVLAID ),
	.ADS_BDATA     ( ADS_BDATA  ),
	.ADS_BVLAID    ( ADS_BVLAID ),
    .ADS_INIT_OK(ADS_INIT_OK)
    );
endmodule
