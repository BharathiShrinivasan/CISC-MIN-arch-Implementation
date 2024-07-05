`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2023 15:06:49
// Design Name: 
// Module Name: TestModule
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


module TestModule(
    input [3:0] ClockSource,
    input [25:0] DecodedControlWord,
    input [2:0] RxSel,
    input [2:0] RySel,
    input [2:0] ExtOpCode,
    output [15:0] MEM_AddressLine,
    input [15:0] MEM_ReadLine,
    output [15:0] MEM_WriteLine,
    output MEM_WriteSignal,
    output [3:0] ALUFlag
    );
    
    wire TestUnit_ClockInput,TestUnit_Enable;
    wire[2:0] TestUnit_ExtOpCode;
    wire[15:0] TestUnit_Bus_A;    
    ALU TestUnit(.ClockInput(TestUnit_ClockInput),.Enable(TestUnit_Enable),.ExtOpCode(TestUnit_ExtOpCode),.Bus_A(TestUnit_Bus_A));/*input ClockInput,input Enable,input [2:0] ExtOpCode,input [1:0] OperandSelect,input IsExtOperation,input UpdateFlag,input UpdateResult,input [15:0] Bus_A,input [15:0] Bus_B,output reg [15:0] Read_T1,output reg [3:0] Read_Flag */

    
    assign TestUnit_ClockInput=ClockSource[0];
    assign TestUnit_Enable=DecodedControlWord[0];
    assign TestUnit_ExtOpCode=DecodedControlWord[3:1];
    assign TestUnit_Bus_A= DecodedControlWord[5:4]==0?MEM_AddressLine:16'bZ;
        
endmodule
