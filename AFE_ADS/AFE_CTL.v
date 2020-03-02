`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:08:09 01/09/2020 
// Design Name: 
// Module Name:    AFE_CTL 
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
module AFE_CTL(
//--- GLOBAL ---
    input CLK_RST,		//reset input, high is valid
    input CLK_100M,		//system clock
	input ADS_INIT_OK,	
	
//--- AFE PORTS ---
	//-- control ports --
	output AFE_CLK,		//0.769 MHz  outputs the analog voltage from each integrator channel on each rising edge
	output AFE_INTG,	//integrate pixel signal when high
	output AFE_IRST,	//Resets the AFE on rising edge
	output AFE_SHS,		//samples signal on rising edge
    output AFE_SHR,		//samples ‘reset’ level of integrator on rising edge  
    output AFE_PDZ,		//power down set
    output AFE_NAPZ,	//sleep mode set
    output AFE_ENTRI,	//High on this pin enables tri-state of analog output drivers after shift out of data for all 64 channels 
	output AFE_STI,
	input  AFE_STO,

	//-- mode ports --
	output AFE_SMT_MD,	// read mode set
	output AFE_INPUTZ,
	//-- compensation set --
    output AFE_DF_SM,	//Digital control to dump compensation charge on integrator capacitor,
	//-- PGA set --	
	output [2:0] AFE_PGA
    );
	
//---output registers-------------------------------------------------
(* KEEP = "TRUE" *)reg	o_clk	=	1'b0,
	o_intg	=	1'b0,
	o_shr	=	1'b0,
	o_irst	=	1'b0,
	o_shs	=	1'b0,
	o_sti	=	1'b0,
	o_dfsm	=	1'b1;
//--output assignment---	
assign	AFE_PDZ		=	1'b1;
assign	AFE_NAPZ	=	1'b1;
assign	AFE_ENTRI	=	1'b1;
assign	AFE_SMT_MD	=	1'b1;
assign	AFE_INPUTZ	=	1'b1;
assign	AFE_PGA		=	3'b111;

assign	AFE_CLK 	=	o_clk;
assign	AFE_INTG	=	o_intg;
assign	AFE_SHR		=	o_shr;	
assign	AFE_IRST	=	o_irst;	
assign	AFE_SHS		=	o_shs;	
assign	AFE_STI		=	o_sti;
assign	AFE_DF_SM	=	1'b1;	// o_dfsm
//---state parameters---
parameter	IDLE		=	4'd0,
			IRST_STI	=	4'd1,
			CLK			=	4'd2,
			SHR			=	4'd3,
			INTG		=	4'd4,
			SHS			=	4'd5;
reg [3:0]	current_state = 0,
			next_state	=	0;			
//---time parameters---
parameter	T_SXX		=	12'd50,			// 	50 ns		//  5
			T_IRST		=	12'd100,		// 	100 ns		//	10
			T_HALF_CLK	=	12'd65,		//	650 ns	AFE_CLK = 0.769MHz -> 1300 ns
			T_WAIT_INTG	=	12'd100,		//	100 ns  wait for INTG	// 10
			T_TFT		=	12'd1400,	//  14	us  TFT_ON to set AFE_DF_SM
			T_INTG		=	12'd1450,	//	14.5 us	14us TFT_ON + 0.5us delay
			T_WAIT_SHS	=	12'd500,	//  5 us 	wait for SHS
			T_END		=	12'd10;		//	100 ns	rising SHS to next rising IRST 
reg [11:0] time_cnt		=	0;			
//---other registers---
parameter	HALF_CLK_NUM	=	67;		// 65
reg [7:0] 	clk_cnt	=	0;	// cnt for CLK_AFE
reg			sjump	=	1'b0;

//---state jump-----------------------------------------------------------------
always @(posedge CLK_100M or posedge CLK_RST) begin
	if (CLK_RST)
		current_state <= IDLE;
	else
		current_state <= next_state;
end
//---State execution---
always @(posedge CLK_100M or posedge CLK_RST) begin
	if (CLK_RST) begin
		time_cnt 	<=	0;
		clk_cnt		<=	0;
		sjump		<=	0;
	end
	else begin
			
		case (next_state)
			//---ST0---
			IDLE : begin
				o_clk	<=	1'b0;
				o_intg	<=	1'b0;
				o_shr	<=	1'b0;
				o_irst	<=	1'b0;
				o_shs	<=	1'b0;
				o_sti	<=	1'b0;
				o_dfsm	<=	1'b1;
				time_cnt<=	0;
				clk_cnt	<=	0;
				sjump	<=	0;				
			end
			//---ST1---
			IRST_STI : begin 
				if (time_cnt < T_IRST) begin
					time_cnt <= time_cnt + 1;
					sjump	 <= 0;
				end
				else begin
					time_cnt <= 0;
					sjump	 <= 1;
				end
				// STI
				if (time_cnt < T_SXX) 
					o_sti <= 1;
				else
					o_sti <= 0;
				// IRST
				if (time_cnt < T_IRST) 
					o_irst <= 1;
				else
					o_irst <= 0;				
			end
			//---ST2---
			CLK : begin
				if (time_cnt < T_HALF_CLK - 1) begin
					time_cnt <= time_cnt + 1;					
					if (clk_cnt < HALF_CLK_NUM) begin						
						sjump <= 0;
						clk_cnt	 <= clk_cnt;
					end
					else begin
						sjump <= 1;
						clk_cnt	 <= 0;						
					end
				end
				else begin
					time_cnt <= 0;
					clk_cnt	 <= clk_cnt + 1;
				end
				// CLK
				if (time_cnt == 0)
					o_clk	 <= ~o_clk;
				else
					o_clk	 <= o_clk;
			end
			//---ST3---
			SHR : begin
				if (time_cnt < T_WAIT_INTG) begin
					time_cnt <= time_cnt + 1;
					sjump	 <= 0;
				end
				else begin
					time_cnt <= 0;
					sjump	 <= 1;
				end
				// SHR
				if (time_cnt < T_SXX) 		// T_SXX	test
					o_shr <= 1;
				else
					o_shr <= 0;				
			end
			//---ST4---
			INTG : begin
				if (time_cnt < T_INTG + T_WAIT_SHS) begin
					time_cnt <= time_cnt + 1;
					sjump	 <= 0;								
				end
				else begin
					time_cnt <= 0;
					sjump	 <= 1;
				end
				// INTG
				if (time_cnt < T_INTG) 
					o_intg	 <= 1;
				else
					o_intg 	 <= 0;
				// DF_SM
				if (time_cnt < T_TFT) 
					o_dfsm	 <= 0;
				else
					o_dfsm 	 <= 1;				
			end
			//---ST5---
			SHS : begin
				if (time_cnt < T_SXX + T_END) begin
					time_cnt <= time_cnt + 1;
					sjump	 <= 0;
				end
				else begin
					time_cnt <= 0;
					sjump	 <= 1;
				end	
				// SHS
				if (time_cnt < T_SXX) 
					o_shs	 <= 1;
				else
					o_shs 	 <= 0;					
			end	
			//---default---
			default : begin
				o_clk	<=	1'b0;
				o_intg	<=	1'b0;
				o_shr	<=	1'b0;
				o_irst	<=	1'b0;
				o_shs	<=	1'b0;
				o_sti	<=	1'b0;
				o_dfsm	<=	1'b1;
				time_cnt<=	0;
				clk_cnt	<=	0;
				sjump	<=	0;					
			end
		endcase
	end
end
//---State declaration---
always @(*) begin
	if (CLK_RST)
		next_state = IDLE;
	else begin
		case (current_state)
			//---ST0---
			IDLE : begin
				if (ADS_INIT_OK)
					next_state = IRST_STI;
				else
					next_state = IDLE;
			end
			//---ST1---
			IRST_STI : begin
				if (sjump)
					next_state = CLK;
				else
					next_state = IRST_STI;			
			end
			//---ST2---
			CLK : begin
				if (sjump)
					next_state = SHR;
				else
					next_state = CLK;			
			end
			//---ST3---
			SHR : begin
				if (sjump)
					next_state = INTG;
				else
					next_state = SHR;			
			end
			//---ST4---
			INTG : begin
				if (sjump)
					next_state = SHS;
				else
					next_state = INTG;			
			end
			//---ST5---
			SHS : begin
				if (sjump)
					next_state = IRST_STI;
				else
					next_state = SHS;			
			end	
			//---default---
			default : begin
				next_state = IDLE;
			end
		endcase
	end
end
endmodule
