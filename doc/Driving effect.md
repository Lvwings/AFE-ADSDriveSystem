# Driving effects
This file is built for record the simulation effects and onboard performance.    

**conditions**    

* simulator ： modelsim  
* onboard  ： chipscope  
## Simulation effects   
The main function of this project can be divided into two parts ： initialization and sample mode. The overview of driving time diagram is shown in figure 1.  

![overview](_v_images/20200120093452494_9985.png =1350x)
<center>Figure 1.The overview of driving time diagram</center>  
Figure 1 shows the initialization and one whole AFE driving period （sample mode）time diagram.The signal <ADS_INIT_OK> rising edge indicates the completion of initialization. The initialization cost around 6.25us and one whole AFE driving period cost around  62.1us. The data conversion rate is around 16.1 Mb/s（64 channel with 16 bit data of each channel ). Figure 2 shows the details of initialization.  

![initialization](_v_images/20200120102120883_19011.png =1350x)  
<center>Figure 2.The detail time diagram of initialization</center>  
The initialization is mainly set up by six steps shown in Figure 2. Chip ADS is set to softreset mode after the CS is enable, and then the inter reference voltage is set to 2.5V in the next four steps. The last step completes sample channel chosen and channel data format setting.  

![sample](_v_images/20200120104918258_26669.png =1350x)  
<center>Figure 3.The detail time diagram of one AFE clock</center>    
The Figure 3 indicates how ADS cooperates with AFE in one AFE clock. As the frequency of AFE is set to 0.769MHz, we have around 26 ADS clock ( use max frequenc of 20MHz）to control ADS. <ADS_SDI> is set to 0x0000（without inter counter）for channel iidentificationin here. The limiting ADS control case is using 19 ADS clock to realize sample setting, and the frequency of AFE can be set to 1.05MHz in this case.  
