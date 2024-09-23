/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/
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
#include <xstatus.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_cache.h"
#include "xparameters.h" 
#include "xil_types.h" 
#include "sleep.h"
#include <xil_exception.h>
#include <xparameters_ps.h> 
#include "xscugic.h" // Library for Interrupt Handling
#include "xbram.h"
#include <xbram_hw.h>

#define BRAM_CTRL_0_BASE XPAR_XBRAM_0_BASEADDR

int done =1;
XScuGic IntcInstance;

void Intr_handler(void* CallBackRef){
    XScuGic_Disable(&IntcInstance, 61); // Disables the interrupt source provided as the argument Interrupt ID
    xil_printf("\t\t All Data transferd\t\t\n");
    xil_printf("\t\t All Data transferd\\t\t\n");
    xil_printf("\t\t All Data transferd\\t\t\n");
    /// bram data read position ///
    u32 rdata32 = 0;
    for(int i=0; i<64; i++){
        rdata32 = XBram_ReadReg(BRAM_CTRL_0_BASE, i*4);
        //xbram_readreg(base addr, offset)
        // we set our bram data width 32-bit
        if(i<64){
            xil_printf("READ VALUE FROM BRAM 0 : %d \n", rdata32);
        }
    }
    done = 0;
}


int main()
{
    init_platform();

    u32 status;
    //Interrupt Controller setting
    XScuGic_Config* IntcConfig;
    xil_printf("BRAM INTERFACE WITH INTERRUPT SIGNAL\n");
    IntcConfig = XScuGic_LookupConfig(XPAR_SCUGIC_SINGLE_DEVICE_ID);
    // looks up the device configuration based on the unique device ID
    status = XScuGic_CfgInitialize(&IntcInstance, IntcConfig, 
    IntcConfig->CpuBaseAddress);
    if(status !=XST_SUCCESS){
        printf("INTERRUPT CONTROLLER SETTING FAILED \r\n");
        return XST_FAILURE;
    }
    

    // interrupt handler 
    XScuGic_SetPriorityTriggerType(&IntcInstance, 61, 0xA0, 3); // trigger setting for interrup signal
    // Set the interrupt priority and trigger type for the specified IRQ source
    
    // connect interrupt handler
    status =XScuGic_Connect(&IntcInstance, 61, (Xil_InterruptHandler) 
    Intr_handler, (void*) NULL);   // Interrupt Handler connect with interrupt Instance
    // Makes the connection between the Interrupt ID of the interrupt source and the associated handler that 
    // is to run when the interrupt is recongnized
    if(status !=XST_SUCCESS){
        xil_printf("connect interrupt handler failed \n\r");
        return XST_FAILURE;
    }
    XScuGic_Enable(&IntcInstance, 61); // Enables the interrupt source provided as the argument Intrrupt ID.
    Xil_ExceptionInit(); // Initialize the exception table
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler) Intr_handler, (void*)&IntcInstance);
    // Register the interrupt controller handler with the exception table
    Xil_ExceptionEnable(); // enable exceptions
while(done){

}



    xil_printf("finished BRAM Interface with interrupt signal \n");
    cleanup_platform();
    return 0;
}
