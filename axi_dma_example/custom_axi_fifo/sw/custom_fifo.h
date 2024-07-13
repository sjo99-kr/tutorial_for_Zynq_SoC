/******************************************************************************

Tutorial Materials for Embedded Software using Vitis IDE

Using axi4-stream fifo Custom Ip, Do AXI-DMA process  with Interrupt Signal

made by Seongwon Jo,


*******************************************************************************/

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
    u32 status = XAxiDma_CfgInitialize(&dma_ctl, dma_cfg);
    if(status != XST_SUCCESS){
        xil_printf("DMA INITIALIZATION FAILED");
        return XST_FAILURE;
    }

    // Data transfer to Deivce from dma

    u32 data_in[24] = {
        1,2,3,4,5,6,7,8,9,
        10,11,12,13,14,15,16,17,18,
        19,20,21,22,23,24
    };

    u32 data_in1[24] = {
        25,26,27,28,29,30
        ,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48
    };
    Xil_DCacheFlushRange((u32)data_in, 24* sizeof(u32));

    u32 data_out[24];

    XAxiDma_SimpleTransfer(&dma_ctl, (u32)data_out, 48*4, XAXIDMA_DEVICE_TO_DMA);
    XAxiDma_SimpleTransfer(&dma_ctl, (u32)data_in, 24*4, XAXIDMA_DMA_TO_DEVICE);

    Xil_DCacheFlushRange((u32)data_in1, 24* sizeof(u32));

    XAxiDma_SimpleTransfer(&dma_ctl, (u32)(data_in1), 24*4, XAXIDMA_DMA_TO_DEVICE);

    usleep(500000);

    for(int i= 0; i<48; i++){
        xil_printf("received data from device -> index : %d, data: %d \n", i, data_out[i]);
    }

    xil_printf("Successfully done Custom AXI4-stream buffer\n");





    cleanup_platform();
    return 0;
}
