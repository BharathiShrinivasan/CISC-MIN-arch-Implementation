`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2023 15:59:57
// Design Name: 
// Module Name: ALU
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


module ALU(
    input ClockInput,
    input Enable,
    input [2:0] ExtOpCode,
    input [1:0] OperandSelect,
    input IsExtOperation,
    input UpdateFlag,
    input UpdateResult,
    input [15:0] Bus_A,
    input [15:0] Bus_B,
    output reg [15:0] Read_T1=0,
    output reg [3:0] Read_Flag=0
    );
    
    reg [15:0] SecondOperand;  
    always @(*)//OperandSelect)
    begin
        case (OperandSelect)
            0: SecondOperand<=Bus_B;
            1: SecondOperand<=16'b1;
            2: SecondOperand<=-1;
            3: SecondOperand<=16'b0;
        default: SecondOperand<=Bus_B;
        endcase
    end
    
    parameter ADD=3'b000, SUB=3'b001, AND=3'b100, OR=3'b101, XOR=3'b110;
    wire [2:0] OperationToPerform;
    assign OperationToPerform=IsExtOperation?ExtOpCode:ADD;
    
    reg [15:0] ALUResult;
    always @(*)//OperationToPerform or SecondOperand or Bus_A)
    begin
        case(OperationToPerform)
            ADD : ALUResult=Bus_A + SecondOperand;
            SUB : ALUResult=Bus_A - SecondOperand;
            AND : ALUResult=Bus_A & SecondOperand;
            OR  : ALUResult=Bus_A | SecondOperand;
            XOR : ALUResult=Bus_A ^ SecondOperand;
            default : ALUResult=Bus_A + SecondOperand;
        endcase         
    end
    
    
    always @(posedge ClockInput)
    begin
        if(UpdateFlag & Enable) Read_Flag=(ALUResult==0)?4'b1:0;
        if(UpdateResult & Enable) Read_T1<=ALUResult;
    end
    
    
    
    
endmodule
