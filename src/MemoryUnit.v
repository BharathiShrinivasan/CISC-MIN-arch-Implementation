`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2023 23:03:00
// Design Name: 
// Module Name: MemoryUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MemoryUnit(
    output [15:0] MEMReadBus,
    input [15:0] MEMWriteBus,
    input [15:0] AddressLine,
    input WriteMEM,
    input ClockInput
    );
    
    reg[15:0] MemoryBank[1023:0];
    
    wire[15:0] ReadData;
    
    assign MEMReadBus=MemoryBank[AddressLine];

    always @(posedge ClockInput)
    begin
        if(WriteMEM)MemoryBank[AddressLine]<=MEMWriteBus;
    end
    
    initial begin
        // Code Segment memory
        MemoryBank[0]=16'h0000;
        MemoryBank[1]=16'h5006;
        MemoryBank[2]=16'h5016;
        MemoryBank[3]=16'h1026;
        MemoryBank[4]=16'h6076;
        MemoryBank[5]=16'h4004;
        MemoryBank[6]=16'h1001;
        MemoryBank[7]=16'h1012;
        MemoryBank[8]=16'h6066;
        MemoryBank[9]=16'h4003;
        MemoryBank[10]=16'h0000;
        MemoryBank[11]=16'h1015;
        MemoryBank[12]=16'h6000;
        MemoryBank[13]=16'h4003;
        // Data Segment memory
        MemoryBank[200]=10;
        MemoryBank[201]=11;
        MemoryBank[210]=57;       
        
    end
    
endmodule
