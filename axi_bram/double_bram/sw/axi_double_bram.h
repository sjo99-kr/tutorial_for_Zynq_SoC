/******************************************************************************

Tutorial Materials for Embedded Software using Vitis IDE

Using AXI_Bram controller Ip, WRITE DATA AND READ DATA FROM BRAM 

made by Seongwon Jo,


*******************************************************************************/

// Library Linking
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xbram.h"
#include <xbram_hw.h>

// Set base addr of BRAMs (we set Two brams in PL)
#define BRAM_CTRL_0_BASE XPAR_XBRAM_0_BASEADDR
#define BRAM_CTRL_1_BASE XPAR_XBRAM_1_BASEADDR

int main()
{
    // u32 means unsigned 32 bits 
    u32 wdata32, rdata32;
    u32 i;

    // initialize our platform , I use Zynq 7020 
    init_platform();

    xil_printf("AXI_DOUBLE_BRAM ACCESS TEST!! \r\n");
    
    // for bram 0, write data process
    wdata32 = 0;
    for(i=0; i<100; i++){
        XBram_WriteReg(BRAM_CTRL_0_BASE, i*4, wdata32);
        // xbram_writereg(base addr, offset, data)
        wdata32 = wdata32 +2;
    }
    xil_printf("BRAM 0 WRITING PROCESS DONE \r\n");
    
    // for bram 0, write data process
    wdata32 = 100;
    for(i=0; i<100; i++){
        XBram_WriteReg(BRAM_CTRL_1_BASE, i*4, wdata32);
        wdata32 = wdata32 +1;
    }
    
    xil_printf("BRAM 1 WRITTING PROCESS DONE \r\n");

    xil_printf("\n\n BRAM 0 READING PROCESS START \r\n");
    
    // for bram 0, read data process
    rdata32 = 0;
    for(i=0; i<100; i++){
        rdata32 = XBram_ReadReg(BRAM_CTRL_0_BASE, i*4);
        //xbram_readreg(base addr, offset)
        // we set our bram data width 32-bit
        if(i<10){
            xil_printf("READ VALUE FROM BRAM 0 : %d \n", rdata32);
        }
    }
    xil_printf("BRAM 0 READING PROCESS DONE \r\n");


    xil_printf("\n\n BRAM 1 READING PROCESS START \r\n");
    
    // for bram 1, read data process
    rdata32 = 0;
    for(i=0; i<100; i++){
        rdata32 = XBram_ReadReg(BRAM_CTRL_1_BASE, i*4);
        if(i<10){
            xil_printf("READ VALUE FROM BRAM 1 : %d \n", rdata32);
        }
    }
    
    xil_printf("BRAM 1 READING PROCESS DONE \r\n");


    cleanup_platform();
    return 0;
}
