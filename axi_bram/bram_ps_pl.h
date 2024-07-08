/******************************************************************************

Tutorial Materials for Embedded Software using Vitis IDE

Using AXI_Bram controller Ip And BRAM Setting by PL, WRITE DATA AND READ DATA FROM BRAM 

made by Seongwon Jo,

BRAM has Single port
*******************************************************************************/



#include <stdio.h>
#include <xbram_hw.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xbram.h"

#define BRAM_CTRL0_BASE XPAR_XBRAM_0_BASEADDR

int main()
{
    u32 wdata32, rdata32;
    u32 i;
    u32 error_cnt = 0;

    init_platform();

    xil_printf("Hello World\n\r");
    xil_printf("BRAM_ACCESS_TEST \r\n");

    // bram write
    xil_printf("bram_write process\r\n");
    wdata32 = 0;
    for(i = 0; i < 2048; i++){
        XBram_WriteReg(BRAM_CTRL0_BASE, i*4, wdata32);
        wdata32 = wdata32 + 1;
    }
    xil_printf("bram_write done");
    
    // bram read
    rdata32 = 0;
    xil_printf("bram_read process \r\n");
    wdata32 = 0;
    for(i=0; i<2048; i++){
        rdata32 = XBram_ReadReg(BRAM_CTRL0_BASE, i*4);
        if(wdata32 != rdata32) error_cnt++;
        if(i<100){
            xil_printf("\r\n i : %d, w: %08x, r: %08x ", i, wdata32, rdata32);
        }
        wdata32 = wdata32 + 1;
    }
    while(1);

    cleanup_platform();
    return 0;
}
