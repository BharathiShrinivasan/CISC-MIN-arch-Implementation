`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2023 23:00:50
// Design Name: 
// Module Name: NextStateLogicUnit
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


module NextStateLogicUnit(
    input [5:0] InstBranch,
    input [5:0] SeqBranch,
    input [5:0] DirectBranch,
    input [1:0] NextSelType,
    input [3:0] ConditionFlag,
    output reg [5:0] NextControlStoreAddress=0
    );
    
    parameter TY_InstructionBranch=0,TY_SequenceBranch=1,TY_BranchControl=2,TY_DirectBranch=3;
    parameter ControlAddBranchTruee=12,ControlAddBranchFalse=13;

    always @(*)
    begin
        case(NextSelType)
            TY_InstructionBranch:NextControlStoreAddress<=InstBranch;
            TY_SequenceBranch:NextControlStoreAddress<=SeqBranch;
            TY_BranchControl:NextControlStoreAddress<=ConditionFlag?ControlAddBranchTruee:ControlAddBranchFalse;
            TY_DirectBranch:NextControlStoreAddress<=DirectBranch;
            default:NextControlStoreAddress<=DirectBranch;
        endcase 
    end
        
endmodule
