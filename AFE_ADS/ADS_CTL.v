`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:08:21 01/09/2020 
// Design Name: 
// Module Name:    ADS_CTL 
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
module ADS_CTL(
//--- GLOBAL ---
    input CLK_RST,		//reset input, high is valid
    input CLK_ADS,		//system clock
	input CLK_100M,
//--- AFE PORTS ---	
	input  AFE_EOC,
	input  CLK_AFE,	
//--- ADS PORTS ---
	output ADS_CLK,
	output ADS_CS_N,
	input  ADS_BUSY,
	output ADS_RD,
	output ADS_SDI,
	input  ADS_SDOA,
	input  ADS_SDOB,
	output [1:0] ADS_M,
	output ADS_CONVST,
//--- inter signal ---
	output [15:0] ADS_ADATA,
	output		  ADS_AVLAID,	// high valid
	output [15:0] ADS_BDATA,
	output		  ADS_BVLAID,	// high valid
	output ADS_INIT_OK
    );
	

//---output registers------------------------------------------------------
(* KEEP = "TRUE" *)reg	o_clk	=	1'b0,
	o_csn	=	1'b1,
	o_rd	=	1'b0,
	o_sdi	=	1'b0,
	o_init	=	1'b0,	// initial success flag ： high valid
	o_convst=	1'b0;
	
(* KEEP = "TRUE" *) reg [15:0]	o_sdoa	=	0,
								o_sdob	=	0;
(* KEEP = "TRUE" *) reg			o_sdoa_valid	=	0,
								o_sdob_valid	=	0;	
reg [1:0]   o_m	=	2'b00;	// full-differential full-channel

//--output assignment---
assign	ADS_CLK		=	CLK_ADS;
assign	ADS_CS_N	=	o_csn;
assign	ADS_RD		=	o_rd;
assign	ADS_SDI		=	o_sdi;
assign	ADS_CONVST	=	o_convst;
assign	ADS_M		=	o_m;
assign	ADS_INIT_OK	=	o_init;
assign	ADS_ADATA	=	o_sdoa;
assign	ADS_AVLAID	=	o_sdoa_valid;
assign	ADS_BDATA	=	o_sdob;
assign	ADS_BVLAID	=	o_sdob_valid;
//---state parameters---
parameter	IDLE		=	4'd0,
			CMDS		=	4'd1,
			SDIO		=	4'd2;
reg [3:0]	current_state = 0,
			next_state	=	0;	
//---time parameters---
parameter	T_RD		=	8'd20,		// 	< 50 ns  // 4
			T_CS		=	8'd20;		// 	20 CLK_ADS
reg [7:0] time_cnt		=	0,
		  clk_cnt		=	0,
		  afe_cnt		=	0;
//---sdi cmd registers---
parameter	CMD_SRESET	=	16'h1004,	// 软复位
			CMD_REFV1	=	16'h1002,	// 参考电压1
			CMD_REFV2	=	16'h1005,	 // 参考电压2
			CMD_REFDAC	=	16'h03FF,	//	2.5v 参考电压
			CMD_INIT	=	16'h1000,	// 通道+AD片	4020  内部计数器
			CMD_NORM	=	16'h0000;	// 0000 通道+AD片  0010 内部计数器
reg [15:0]	sdi_cmd		=	0,
			sdi_cmdr	=	0;
parameter	SRESET		=	4'd0,		// 软复位
			REFV1ADD	=	4'd1,		// 设定内部参考电压
			REFV1DAC	=	4'd2,
			REFV2ADD	=	4'd3,		// 设定内部参考电压
			REFV2DAC	=	4'd4,
			INIT		=	4'd5,		// 初始化配置寄存器
			NORM		=	4'd6;		// 正常转换
reg [3:0]	cmd_cnt		=	0;
//---ads output voltage---
reg [17:0]  sdoa	=	0,	//	store ADS_SDOA 
			sdob	=	0;
reg [1:0]	sdoa_cnt=	0,	//	store inter counter
			sdob_cnt= 	0;

//---other registers---
reg	CLK_AFE_D	=	1'b0,
	CLK_ADS_D	=	1'b0,
	o_csn_d		=	1'b0,
	sjump		=	1'b0,	// state jump flag
	sdi_over	=	1'b0;	// sdi transfer over flag
						
//---state jump----------------------------------------------------------
always @(posedge CLK_100M or posedge CLK_RST) begin
	if (CLK_RST)
		current_state <= IDLE;
	else
		current_state <= next_state;
end		
//---State execution---
always @(posedge CLK_100M or posedge CLK_RST) begin
	if (CLK_RST) begin
		o_rd		<=	1'b0;
		o_convst	<=	1'b0;
		time_cnt	<=	0;
		sdi_over	<=	0;
	end
	else begin
		
		CLK_AFE_D	<=	CLK_AFE;
		if (afe_cnt < 34) begin
			if (!CLK_AFE_D && CLK_AFE)
				afe_cnt <= afe_cnt + 1;
			else
				afe_cnt <= afe_cnt;
		end
		else 
			afe_cnt <= 0;
			
		CLK_ADS_D	<=	CLK_ADS;		
		o_csn_d		<=	o_csn;
		case (next_state)
			//---ST0---
			IDLE : begin
				o_rd		<=	1'b0;
				o_convst	<=	1'b0;
				time_cnt	<=	0;
				sdi_over	<=	0;				
			end
			//---ST1---
			CMDS : begin
				time_cnt<= 0;
				if (o_init) 
					cmd_cnt <= NORM;		// normal mode after initial success
				else if (cmd_cnt < NORM)
					cmd_cnt <= cmd_cnt + 1;
				else
					cmd_cnt	<= cmd_cnt;
						
				case (cmd_cnt) 
					SRESET	 : begin sdi_cmd <= CMD_SRESET; end
					REFV1ADD : begin sdi_cmd <= CMD_REFV1;  end						
					REFV1DAC : begin sdi_cmd <= CMD_REFDAC; end						
					REFV2ADD : begin sdi_cmd <= CMD_REFV2;  end						
					REFV2DAC : begin sdi_cmd <= CMD_REFDAC; end						
					INIT	 : begin sdi_cmd <= CMD_INIT; 	end		
					NORM     : begin sdi_cmd <= CMD_NORM; 	end
					default  : begin sdi_cmd <= 0; end				
				endcase
			end
		//---ST2---
			SDIO : begin

				// ADS_CONVST ADS_RD
				if (clk_cnt == 1) begin 
					time_cnt <= time_cnt + 1;
					if (time_cnt >= 1 && time_cnt <= T_RD) begin
						o_convst <= 1;
						o_rd	 <= 1;
					end
					else begin
						o_convst <= 0;
						o_rd	 <= 0;						
					end
				end	
				else begin
					time_cnt <= time_cnt;
					o_convst <= 0;
					o_rd	 <= 0;	
				end
		
				if (!o_csn_d && o_csn)
					sdi_over<=	1;
				else
					sdi_over<=	0;
			end					
			//---default---
			default : begin
				o_rd		<=	1'b0;
				o_convst	<=	1'b0;
				time_cnt	<=	0;
				sdi_over	<=	0;			
			end
		endcase
	end
end
//---------------------- SDO -------------------------------
always @(negedge CLK_ADS or posedge CLK_RST) begin
	if (CLK_RST) begin
		o_sdoa_valid<=	0;
		o_sdoa 		<=  0;
		o_sdob_valid<=	0;
		o_sdob 		<=  0;
		sdoa		<=	0;
		sdob		<=	0;
	end
	else begin
		case (current_state)
			IDLE : begin
					o_sdoa_valid	<=	0;
					o_sdoa <= 0;
					o_sdob_valid	<=	0;
					o_sdob <= 0;				
			end
			SDIO : begin

				// ADS_SDO
				case (clk_cnt)
					8'd00,8'd01 : begin 
									o_sdoa_valid	<=	0;
									o_sdoa <= 0;
									o_sdob_valid	<=	0;
									o_sdob <= 0;					
					end
					8'd02,8'd03,8'd04,8'd05,8'd06,8'd07,8'd08,8'd09,8'd10,
					8'd11,8'd12,8'd13,8'd14,8'd15,8'd16,8'd17,8'd18,8'd19: 
							begin 
								if (o_init && ADS_BUSY) begin
									sdoa[19-clk_cnt] <= ADS_SDOA;
									sdob[19-clk_cnt] <= ADS_SDOB;
								end
								else begin
									sdoa <= sdoa;
									sdob <= sdob;
								end
							end	
					8'd20 : begin 
								if (o_init && (afe_cnt < 34) && (afe_cnt > 1)) begin
									o_sdoa_valid	<=	1;
									o_sdoa <= sdoa[15:0];
									o_sdob_valid	<=	1;
									o_sdob <= sdob[15:0];
								end
								else begin
									o_sdoa_valid	<=	0;
									o_sdoa <= 0;
									o_sdob_valid	<=	0;
									o_sdob <= 0;						
								end				
					end			
					default:begin 
									o_sdoa_valid	<=	0;
									o_sdoa <= 0;
									o_sdob_valid	<=	0;
									o_sdob <= 0;					
					end
				endcase
			end
		endcase
	end
end
//---------------------- SDI -------------------------------
always @(posedge CLK_ADS or posedge CLK_RST) begin
	if (CLK_RST) begin
		o_init	<=	0;
		clk_cnt	<=	0;
		sdi_cmdr<=  0;
	end
	else begin
		case (current_state)
			SDIO : begin
				// ADS_CS_N
				if (clk_cnt < T_CS) begin 		// if (ADS_BUSY)  
					clk_cnt <= clk_cnt + 1;
					o_csn	<=	0;
				end
				else begin
					clk_cnt <=  0;
					o_csn	<= 	1;
					if (cmd_cnt == NORM) 
						o_init	 <= 1;	
					else
						o_init	 <= 0;					
				end
				// ADS_SDI
				case (clk_cnt)
					8'd00 : begin o_sdi <= 0;sdi_cmdr <= sdi_cmd; end
					8'd01,8'd02,8'd03,8'd04,8'd05,8'd06,8'd07,8'd08,
					8'd09,8'd10,8'd11,8'd12,8'd13,8'd14,8'd15,8'd16: 
							begin o_sdi <= sdi_cmdr[16-clk_cnt]; end		// o_sdi <= sdi_cmdr[15]; sdi_cmdr <= sdi_cmdr << 1;
					default:begin o_sdi <= 0;end
				endcase
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
				if (!o_init)
					next_state = CMDS;
				else if (!CLK_AFE_D && CLK_AFE && (afe_cnt < 34) && !AFE_EOC)	// normal mode
					next_state = CMDS;
				else
					next_state = IDLE;
			end
			//---ST1---
			CMDS : begin
					next_state = SDIO;		// 是否带通道信息	2选一	
			end
			//---ST2---
			SDIO : begin
				if (sdi_over && !o_init)
					next_state = CMDS;
				else if (sdi_over && o_init)
					next_state = IDLE;
				else
					next_state = SDIO;			
			end				
			//---default---
			default : begin
				next_state = IDLE;
			end
		endcase
	end
end			
endmodule
