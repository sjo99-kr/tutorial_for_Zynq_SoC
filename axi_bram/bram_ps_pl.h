/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/
/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

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
    xil_printf("\r\n error_count : %d .. \r\n", error_cnt);
    while(1);


    cleanup_platform();
    return 0;
}
