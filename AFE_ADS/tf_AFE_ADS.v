`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:33:45 01/09/2020
// Design Name:   AFE_ADS_TOP
// Module Name:   E:/WORK/AFE/AFE/AFE_ADS/tf_AFE_ADS.v
// Project Name:  AFE_ADS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: AFE_ADS_TOP
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tf_AFE_ADS;

	// Inputs
	reg sys_rst_n;
	reg sys_clk;
	reg AFE_STO;
	reg AFE_EOC;
	reg ADS_BUSY;
	reg ADS_SDOA;
	reg ADS_SDOB;

	// Outputs
	wire AFE_CLK;
	wire AFE_INTG;
	wire AFE_IRST;
	wire AFE_SHS;
	wire AFE_SHR;
	wire AFE_PDZ;
	wire AFE_NAPZ;
	wire AFE_ENTRI;
	wire AFE_SMT_MD;
	wire AFE_INPUTZ;
	wire AFE_DF_SM;
	wire [2:0] AFE_PGA;
	wire ADS_CLK;
	wire ADS_CS_N;
	wire ADS_RD;
	wire ADS_SDI;
	wire [1:0] ADS_M;
	wire ADS_CONVST;

	// Instantiate the Unit Under Test (UUT)
	AFE_ADS_TOP uut (
		.sys_rst_n(sys_rst_n), 
		.sys_clk(sys_clk), 
		.AFE_CLK(AFE_CLK), 
		.AFE_INTG(AFE_INTG), 
		.AFE_IRST(AFE_IRST), 
		.AFE_SHS(AFE_SHS), 
		.AFE_SHR(AFE_SHR), 
		.AFE_PDZ(AFE_PDZ), 
		.AFE_NAPZ(AFE_NAPZ), 
		.AFE_ENTRI(AFE_ENTRI), 
		.AFE_STO(AFE_STO), 
		.AFE_EOC(AFE_EOC), 
		.AFE_SMT_MD(AFE_SMT_MD), 
		.AFE_INPUTZ(AFE_INPUTZ), 
		.AFE_DF_SM(AFE_DF_SM), 
		.AFE_PGA(AFE_PGA), 
		.ADS_CLK(ADS_CLK), 
		.ADS_CS_N(ADS_CS_N), 
		.ADS_BUSY(ADS_BUSY), 
		.ADS_RD(ADS_RD), 
		.ADS_SDI(ADS_SDI), 
		.ADS_SDOA(ADS_SDOA), 
		.ADS_SDOB(ADS_SDOB), 
		.ADS_M(ADS_M), 
		.ADS_CONVST(ADS_CONVST)
	);

	initial begin
		// Initialize Inputs
		sys_rst_n = 0;
		sys_clk = 0;
		AFE_STO = 0;
		AFE_EOC = 0;
		ADS_BUSY = 0;
		ADS_SDOA = 0;
		ADS_SDOB = 0;

		// Wait 100 ns for global reset to finish
		#100;
        sys_rst_n = 1;
		// Add stimulus here

	end
always # 10 sys_clk = ~sys_clk;
reg ADS_RD_D	 = 0,
	ADS_CS_D	 = 0,
	ADS_CLK_D	 = 0,
	data_valid	 =	0;
reg [1:0]	sdo_cnt = 0;
reg [17:0]	sdo_data	=	0;
reg [15:0]	data	=	1;
	
always @(posedge sys_clk) begin
	ADS_RD_D <= ADS_RD;
	ADS_CS_D <= ADS_CS_N;
	ADS_CLK_D<= ADS_CLK;
	
	if (!ADS_RD_D && ADS_RD) begin
		data_valid <= 1;
		sdo_cnt	<= sdo_cnt + 1;
		data	<=	data + 1;
		sdo_data <= {sdo_cnt,data};		
	end
	else if (!ADS_CS_D && ADS_CS_N) begin
		data_valid <= 0;
		sdo_cnt	<= sdo_cnt;
	end
	else begin
		data_valid <= data_valid;
		sdo_cnt	<= sdo_cnt;
	end
		
	if (data_valid) begin
		if (!ADS_CLK_D && ADS_CLK) begin			
			ADS_SDOA	<= sdo_data[17];
			ADS_SDOB	<= sdo_data[17];
			sdo_data	<= sdo_data << 1;
		end
		else begin
			ADS_SDOA	<=	ADS_SDOA;
			ADS_SDOB	<=	ADS_SDOB;
			sdo_data	<=	sdo_data;
		end
	end
	else begin
		ADS_SDOA	<=	ADS_SDOA;
		ADS_SDOB	<=	ADS_SDOB;
	end
		
	
end
      
endmodule

