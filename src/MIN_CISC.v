`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.07.2023 21:04:34
// Design Name: 
// Module Name: MIN_CISC
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


module MIN_CISC( input PLClock);//, output [7:0] LED );

// Clock Generator
wire [3:0] ClockSource; // 4-phase clock
ClockGeneratorUnit ClockGenModule(.ClockSource(ClockSource));//,.PLClock(PLClock));

// Control Plane (Control Unit)
    wire [5:0] IB_Address;
    wire [5:0] SB_Address;
    wire [2:0] ExtOpCode;
    wire [2:0] RxSelected;
    wire [2:0] RySelected;
    wire [5:0] ControlAddress;
    wire [25:0] DecodedControlWord;
    wire [1:0] SelectionTypeTY;
    wire [5:0] NextAddressNA;
    wire [3:0] ConditionFlag;
    wire [15:0] IRE_OpCode;
    
    InstructionDecoderUnit InstDecodedModule(ClockSource[0],IRE_OpCode,IB_Address,SB_Address,ExtOpCode,RxSelected,RySelected); 
    NextStateLogicUnit NextStateLogicModule(IB_Address,SB_Address,NextAddressNA,SelectionTypeTY,ConditionFlag,ControlAddress);
    ControlStoreUnit ControlStoreModule(ClockSource[1],ControlAddress,DecodedControlWord,SelectionTypeTY,NextAddressNA);

// Data Plane (EU unit)
    wire [3:0] EUClockSource; assign EUClockSource[0]=ClockSource[2],EUClockSource[1]=ClockSource[0],EUClockSource[2]=0,EUClockSource[3]=0;
    wire [15:0] MEM_AddressLine;
    wire [15:0] MEM_ReadLine;
    wire [15:0] MEM_WriteLine;
    wire MEM_WriteSignal;
    
    ExecutionUnit EUModule(EUClockSource,DecodedControlWord,RxSelected,RySelected,ExtOpCode,MEM_AddressLine,MEM_ReadLine,MEM_WriteLine,MEM_WriteSignal,ConditionFlag,IRE_OpCode);
    MemoryUnit MEMModule(MEM_ReadLine,MEM_WriteLine,MEM_AddressLine,MEM_WriteSignal,ClockSource[0]);

// GPIO Unit
    //assign LED=EUModule.ProgRegister.ProgRegister[2];
    

endmodule
