/******************************************************************************

Tutorial Materials for Embedded Software using Vitis IDE

Using Acumulator Custom Ip, Do AXI-DMA process

made by Seongwon Jo,


*******************************************************************************/

// Library Linking
#include "xaxidma.h"
#include "xparameters.h"
#include "sleep.h"
#include "xil_cache.h"
#include <xstatus.h>

u32 checkHalted(u32 baseAddress,u32 offset);

int main(){

	u32 a[] = {1,2,3,4,5,6,7,8};
	u32 b[8];
    u32 status;

	XAxiDma_Config *myDmaConfig;
	XAxiDma myDma;

    // Searching for DMA Controller configure
	myDmaConfig = XAxiDma_LookupConfig(XPAR_AXI_DMA_0_BASEADDR);

    // DMA controller configure initialization
	status = XAxiDma_CfgInitialize(&myDma, myDmaConfig);
	if(status != XST_SUCCESS){
		print("DMA initialization failed\n");
		return XST_FAILURE;
	}
	print("DMA initialization success..\n");

    // check process if DMA is busy
	status = checkHalted(XPAR_AXI_DMA_0_BASEADDR,0x4);
	xil_printf("Status before data transfer %0x\n",status);

	Xil_DCacheFlushRange((u32)a,8*sizeof(u32)); // Dirty Data management in Data Cache
	status = XAxiDma_SimpleTransfer(&myDma, (u32)b, 8*sizeof(u32),XAXIDMA_DEVICE_TO_DMA);
	status = XAxiDma_SimpleTransfer(&myDma, (u32)a, 8*sizeof(u32),XAXIDMA_DMA_TO_DEVICE);//typecasting in C/C++
// XAXIDMA_SIMPLETRANSFER CAN NOT SEND DATA IN SG(Scatter - Gatter) DMA ENGINE!!!

// THE DATA TRANSFER IS NOT SEQUENTIAL in Scatter Gatter Mode, but when we use Xaxidma_simple transfer, we send the parameters for one base addr and data size.
	

// Using this form for check DMA State Register
/*
	if(status != XST_SUCCESS){
		print("DMA initialization failed\n");
		return -1;
	}
    status = checkHalted(XPAR_AXI_DMA_0_BASEADDR,0x4);
    while(status != 1){
    	status = checkHalted(XPAR_AXI_DMA_0_BASEADDR,0x4);
    }

    status = checkHalted(XPAR_AXI_DMA_0_BASEADDR,0x34);
    while(status != 1){
    	status = checkHalted(XPAR_AXI_DMA_0_BASEADDR,0x34);
    }
*/
	print("DMA transfer success..\n");
	for(int i=0;i<8;i++)
		xil_printf("%0x\n",b[i]);
}


u32 checkHalted(u32 baseAddress,u32 offset){
	u32 status;
	status = (XAxiDma_ReadReg(baseAddress,offset))&XAXIDMA_HALTED_MASK;
	// XAXIDMA_HALTED_MASK -> DMA Channel is Halt
	// if halt, status is set 0
	return status;
}
