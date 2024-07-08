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
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xbram.h"
#include <xbram_hw.h>

#define BRAM_CTRL_0_BASE XPAR_XBRAM_0_BASEADDR
#define BRAM_CTRL_1_BASE XPAR_XBRAM_1_BASEADDR

int main()
{
    u32 wdata32, rdata32;
    u32 i;

    init_platform();

    xil_printf("Hello World\n\r");
    xil_printf("AXI_DOUBLE_BRAM ACCESS TEST!! \r\n");
    // bram 0 write process
    wdata32 = 0;
    for(i=0; i<100; i++){
        XBram_WriteReg(BRAM_CTRL_0_BASE, i*4, wdata32);
        wdata32 = wdata32 +2;
    }
    xil_printf("BRAM 0 WRITING PROCESS DONE \r\n");
    // bram 1 write process
    wdata32 = 100;
    for(i=0; i<100; i++){
        XBram_WriteReg(BRAM_CTRL_1_BASE, i*4, wdata32);
        wdata32 = wdata32 +1;

    }
    xil_printf("BRAM 1 WRITTING PROCESS DONE \r\n");

    xil_printf("\n\n BRAM 0 READING PROCESS START \r\n");
    // bram 0 read process
    rdata32 = 0;
    for(i=0; i<100; i++){
        rdata32 = XBram_ReadReg(BRAM_CTRL_0_BASE, i*4);
        if(i<10){
            xil_printf("READ VALUE FROM BRAM 0 : %d \n", rdata32);
        }
    }
    xil_printf("BRAM 0 READING PROCESS DONE \r\n");


    xil_printf("\n\n BRAM 1 READING PROCESS START \r\n");
    // bram 1 read process
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
