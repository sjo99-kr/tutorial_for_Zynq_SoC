


// Library Linking
#include <stdio.h>
#include <xaxidma_hw.h>
#include <xil_exception.h>
#include <xparameters_ps.h> 
#include <xstatus.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_cache.h"
#include "xparameters.h" 
#include "xaxidma.h" // Library for AXI-DMA
#include "xil_types.h" 
#include "sleep.h"
#include "xscugic.h" // Library for Interrupt Handling

#define DMA_DEVICE_ID XPAR_AXI_DMA_0_BASEADDR

static XAxiDma dma_ctl;
static XAxiDma_Config *dma_cfg;

XScuGic IntcInstance;

int done =1;

void recevied_handler(void* CallBackRef){
    xil_printf("\t\trecevied Ocucured \t\t\n");
    xil_printf("\t\trecevied Ocucured \t\t\n");
    xil_printf("\t\trecevied Ocucured \t\t\n");
    done = 0;

}

void Intr_handler(void* CallBackRef){
    xil_printf("\t\t All Data transferd\t\t\n");
    xil_printf("\t\t All Data transferd\\t\t\n");
    xil_printf("\t\t All Data transferd\\t\t\n");
}




int main()
{
    init_platform();

    // DMA CONTROLLER INITIALIZATION
    dma_cfg = XAxiDma_LookupConfig(DMA_DEVICE_ID);
    if(dma_cfg == NULL){
        xil_printf("Can't find DMA CONFIGURATION \r\n");
        return XST_FAILURE;
    }
    // DMA CONFIGURATION INITIALIZATION
    status = XAxiDma_CfgInitialize(&dma_ctl, dma_cfg);
    if(status != XST_SUCCESS){
        xil_printf("DMA INITIALIZATION FAILED");
        return XST_FAILURE;
    }
    XAxiDma_IntrEnable(&dma_ctl, XAXIDMA_IRQ_IOC_MASK, XAXIDMA_DEVICE_TO_DMA);


    //Interrupt Controller setting
    XScuGic_Config* IntcConfig;
    IntcConfig = XScuGic_LookupConfig(XPAR_SCUGIC_SINGLE_DEVICE_ID);
    status = XScuGic_CfgInitialize(&IntcInstance, IntcConfig, 
    IntcConfig->CpuBaseAddress);
    if(status !=XST_SUCCESS){
        printf("INTERRUPT CONTROLLER SETTING FAILED \r\n");
        return XST_FAILURE;
    }
    // interrupt handler 
    XScuGic_SetPriorityTriggerType(&IntcInstance, 61, 0xA0, 3);
    // connect interrupt handler
    status =XScuGic_Connect(&IntcInstance, 61, (Xil_InterruptHandler) 
    Intr_handler, (void*) &dma_ctl);
    if(status !=XST_SUCCESS){
        xil_printf("connect interrupt handler failed \n\r");
        return XST_FAILURE;
    }


    // interrupt handler 
    XScuGic_SetPriorityTriggerType(&IntcInstance, 62, 0xA1, 3);
    // connect interrupt handler
    status =XScuGic_Connect(&IntcInstance, 62, (Xil_InterruptHandler) 
    recevied_handler, (void*) &dma_ctl);
    if(status !=XST_SUCCESS){
        xil_printf("connect interrupt handler failed \n\r");
        return XST_FAILURE;
    }
    // Enable Interrupt from 61 (Interrupt ID)
    // Enable Interrupt from 62 (Interrupt ID)
    XScuGic_Enable(&IntcInstance, 61);
    XScuGic_Enable(&IntcInstance, 62);

    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler) XScuGic_InterruptHandler, (void*)&IntcInstance);
    Xil_ExceptionEnable();


  
    // set up for transfer Matrix Data 
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
    u32 all[80] = {1,1,1,1,0,0,0,0,0,0,
                0,2,2,2,2,0,0,0,0,0,
                0,0,3,3,3,3,0,0,0,0,
                0,0,0,4,4,4,4,0,0,0,
                4,3,2,1,0,0,0,0,0,0,
                0,4,3,2,1,0,0,0,0,0,
                0,0,4,3,2,1,0,0,0,0,
                0,0,0,4,3,2,1,0,0,0};

    Xil_DCacheFlushRange((u32)all, 80*sizeof(u32));

    XAxiDma_SimpleTransfer(&dma_ctl, (u32)all, 80*4, XAXIDMA_DMA_TO_DEVICE);
    
    u32 received[16];
    XAxiDma_SimpleTransfer(&dma_ctl, received, 16*4, XAXIDMA_DEVICE_TO_DMA);

    for(u32 p=0 ;p<16; p++){
        xil_printf("\n\n received data : %d \n", received[p]);
    }

    while(done){
        
    }


    print("Hello World\n\r");
    print("Successfully ran Hello World application");
    cleanup_platform();
    return 0;
}
