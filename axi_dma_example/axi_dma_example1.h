/******************************************************************************

Tutorial Materials for Embedded Software using Vitis IDE

Using Acumulator Custom Ip, Do AXI-DMA process

made by Seongwon Jo,


*******************************************************************************/

// Library Linking
#include <stdio.h>
#include <xstatus.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_cache.h"
#include "xparameters.h"
#include "xaxidma.h"
#include "xil_types.h"
#include "sleep.h"

// Set DMA controller BASEADDR
#define DMA_DEVICE_ID XPAR_AXI_DMA_0_BASEADDR
#define DMA_TRANSFER_SIZE 16 // 16 means the number of data for each transfer

// Define DMA Configurations
static XAxiDma dma_ctl;
static XAxiDma_Config *dma_cfg;

int main()
{
    u32 status;
    u32 data_dma_to_device[DMA_TRANSFER_SIZE]; // DMA-read moves this data buffer to AXI-stream FIFO in PL fabric
    u32 data_device_to_dma[DMA_TRANSFER_SIZE]; // DMA-write moves data from AXI-stream FIFO in PL fabric to this data buffer

    init_platform();
    xil_printf("AXI_DMA EXAMPLE_1\n");

    // Disable cache to prevent cache search forcing external memroy access in this demonstration
    Xil_DCacheDisable();


    //-------------------------------------- Initialize AXI DAM Driver--------------------------------------//
    dma_cfg = XAxiDma_LookupConfig(DMA_DEVICE_ID);
    if(dma_cfg ==NULL){
        xil_printf("DMA Configuration FAiled \n");
        return XST_FAILURE;
    }
    status = XAxiDma_CfgInitialize(&dma_ctl, dma_cfg);
    if(status!= XST_SUCCESS){
        xil_printf("DMA Configure Initialization FAiled \n");
        return XST_FAILURE;
    }
    //------------------------------------------------------------------------------------------------------//

    //-------------------------------------- Initialize DMA-READ data buffer setting-------------------------------------//
    for(u32 i =0; i<DMA_TRANSFER_SIZE; i++){ 
        data_dma_to_device[i] = i;
    }
    //------------------------------------------------------------------------------------------------------//

    //-------------------------------------- Submit DMA-READ data to AXI4-stream FIFO in PL fabric-------------------------------------//
    status = XAxiDma_SimpleTransfer(&dma_ctl, data_dma_to_device, DMA_TRANSFER_SIZE * 4,
    XAXIDMA_DMA_TO_DEVICE);
    // xaxidma_simpletransfer(&xaxi_dma, data address in DDR, size of datas (byte), direction)
    
    if(status != XST_SUCCESS){
        xil_printf("TRANSFER FAILED (DMA -> DEVICE) 1\n");
        return XST_FAILURE;
    }
    usleep(1);
    /*
    if(XAxiDma_Busy(&dma_ctl, XAXIDMA_DMA_TO_DEVICE));{
        xil_printf("TRANSFER FAILED (DMA -> DEVICE) 2\n");
        return XST_FAILURE;
    }
    */

    //-------------------------------------- Submit DMA-WRITE data to DDR FROM  AXI-STREAM FIFO in PL fabric-------------------------------------//
    status = XAxiDma_SimpleTransfer(&dma_ctl, data_device_to_dma, DMA_TRANSFER_SIZE * 4,
     XAXIDMA_DEVICE_TO_DMA);
    // xaxidma_simpletransfer(&xaxi_dma, data address in DDR, size of datas (byte), direction)

    if(status != XST_SUCCESS){
        xil_printf("TRANSFER FAILED (DEVICE -> DMA) \n");
        return XST_FAILURE;
    }
    usleep(1);


    // varify data exchange between AXI-STREAM FIFO AND DRAM
    xil_printf("Verify the DRAM DATA in data_device_to_dma");
    for(u32 i=0; i<DMA_TRANSFER_SIZE; i++){
        xil_printf("Received DATA: (index: %d ) data: %u\n", i, data_device_to_dma[i]);
    }

    xil_printf("Successfully ran DMA EXAMPLE_1");
    cleanup_platform();
    return 0;
}
