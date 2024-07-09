/******************************************************************************

Tutorial Materials for Embedded Software using Vitis IDE

Using Custom Interrupt Port, WRITE DATA AND READ DATA FROM BRAM 

made by Seongwon Jo,


*******************************************************************************/

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xscugic.h"
#include "xparameters.h"
#include "xstatus.h"
#include "xil_exception.h"
#include "sleep.h"

// #define INTC_INTERRUPT_ID 61 , which can be found in xparameters.h

XScuGic InterruptController;
static XScuGic_Config *GicConfig;

// handler setting
void ExtIrq_Handler(void *InstancePtr)
{
  xil_printf("ExtIrq_Handler\r\n");
}

int SetUpInterruptSystem(XScuGic *XScuGicInstancePtr)
{
  Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler) XScuGic_InterruptHandler, XScuGicInstancePtr);
  Xil_ExceptionEnable();
  xil_printf("setup inerrupt seystem \r\n");
  return XST_SUCCESS;
}

int main()
{
    init_platform();
    int Status;
    xil_printf("Interrupt _example start - \r\n");
    // Initializae the interrupt controller driver
    GicConfig = XScuGic_LookupConfig(XPAR_SCUGIC_SINGLE_DEVICE_ID);
    if (NULL == GicConfig) {
      xil_printf("failed for searching Interrupt controller Configure \r\n");
        return XST_FAILURE;
    }

      Status = XScuGic_CfgInitialize(&InterruptController, GicConfig, GicConfig->CpuBaseAddress);
    if (Status != XST_SUCCESS) {
      xil_printf("failed for initializationing Interrupt Controller Configure \r\n");

        return XST_FAILURE;
    }

    // Interrupt setting
    Status = SetUpInterruptSystem(&InterruptController);
    if (Status != XST_SUCCESS) {
      xil_printf("failed for setting up Interrupt System \r\n");

        return XST_FAILURE;
    }
    
    Status = XScuGic_Connect(&InterruptController, 61, (Xil_ExceptionHandler) ExtIrq_Handler,
     (void*)NULL);
    if(Status!=     XST_SUCCESS){
      xil_printf("failed for connecting Interrupt Handler on Interrupt System \r\n");
        return XST_FAILURE;
    }
    XScuGic_Enable(&InterruptController, 61);
    while(1){
        usleep(100000);
      xil_printf("No Interrupt occured\r\n");
    }

      print("Successfully ran Interrupt Example!! \r\n");
    cleanup_platform();
    return 0;
}
