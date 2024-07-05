`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2023 22:51:18
// Design Name: 
// Module Name: SimpleRegister
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


module SimpleRegister(
    input [15:0] WriteData,
    input WriteReg,
    input ClockInput,
    output reg [15:0] ReadData=0
    );
    
    always @(posedge ClockInput)
    begin
        if(WriteReg)ReadData<=WriteData;
    end
    
endmodule
