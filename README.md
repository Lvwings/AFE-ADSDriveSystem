# DRIVE SYSTEM OF AFE AND ADS
## Background
We try to detect some weak charge from front end chip.  
In order to reduce the cost of hardware, an AFE cascaded with ADC design is chosen in our project.

## Conditions
* Target chip 		       :	AFE0064 ADS8363  
* MCU 				: 	Xilinx FPGA(XC6)  
* Software platform 	: 	ISE  
* Language 			: 	Verilog  

## Goals
--------------------------v1.0--------------------------------  
This version is mainly bulid for function verification.  

* Enable the channel switches of the AFE0064.  
* Enable AD sample of the ADS8363 according to the AFE states.  

--------------------------v2.0--------------------------------  

This version is mainly bulid for performance optimization.  

- Find maximum stable operating frequency of AFE0064 and ADS8363 .
- Detail the document.

