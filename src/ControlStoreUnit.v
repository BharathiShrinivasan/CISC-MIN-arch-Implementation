`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2023 18:18:12
// Design Name: 
// Module Name: ControlStoreUnit
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


module ControlStoreUnit(
    input ClockInput,
    input [5:0] ControlAddress,
    output [25:0] DecodedControlWord,
    output [1:0] SelectionTypeTY,
    output [5:0] NextAddressNA
    );
    
    reg[33:0] ControlStoreMEM [35:0]; // 35 StateIDs stored, each has a data of 34-bit containing <DecodedControlWord | TY | NextAddress>
    reg[35:0] ControlWord=0;
    
    always@(posedge ClockInput)
    begin
        ControlWord<=ControlStoreMEM[ControlAddress];
    end    
    
    assign DecodedControlWord=ControlWord[33:8];
    assign SelectionTypeTY=ControlWord[7:6];
    assign NextAddressNA=ControlWord[5:0];
    
    initial begin
        ControlStoreMEM[0]=34'b0000000000000000000000000011001101;
        ControlStoreMEM[1]=34'b0010011010000000000001001111000010;
        ControlStoreMEM[2]=34'b0000000110000000000100000011000011;
        ControlStoreMEM[3]=34'b0000000101100000000000001111000100;
        ControlStoreMEM[4]=34'b0010010110000000010000000001000000;
        ControlStoreMEM[5]=34'b0100010000100000100000000001000000;
        ControlStoreMEM[6]=34'b0010101011101000100001001111000111;
        ControlStoreMEM[7]=34'b1000001000110000001011010100000000;
        ControlStoreMEM[8]=34'b0101000011000000000011010111001001;
        ControlStoreMEM[9]=34'b0010101010000000000001001111001010;
        ControlStoreMEM[10]=34'b1000000000110000001000000000000000;
        ControlStoreMEM[11]=34'b0010100100000000000001001110001101;
        ControlStoreMEM[12]=34'b1000000000110000001000000000000000;
        ControlStoreMEM[13]=34'b0010101010000000000001001111001110;
        ControlStoreMEM[14]=34'b1000000000110000001000000000000000;
        ControlStoreMEM[15]=34'b0010101010101000100001001111010000;
        ControlStoreMEM[16]=34'b1000001000110000001011010100000000;
        ControlStoreMEM[17]=34'b0010101010010010100001001111010010;
        ControlStoreMEM[18]=34'b1000001000110000001011010100000000;
        ControlStoreMEM[19]=34'b0010101011100000100001001111010100;
        ControlStoreMEM[20]=34'b1000001000110000001011010100000000;
        ControlStoreMEM[21]=34'b0000000011100000000000111111010110;
        ControlStoreMEM[22]=34'b0101000111000000000000000011010111;
        ControlStoreMEM[23]=34'b0010101010000000000001001111011000;
        ControlStoreMEM[24]=34'b1000000000110000001000000000000000;
        ControlStoreMEM[25]=34'b0000000010100000000000111111011010;
        ControlStoreMEM[26]=34'b0010101010110010000001001111011011;
        ControlStoreMEM[27]=34'b1000000000110000001000000000000000;
        ControlStoreMEM[28]=34'b0010010100000000000001001111011101;
        ControlStoreMEM[29]=34'b0000000111101001000000000011011110;
        ControlStoreMEM[30]=34'b0010101010000000000001001111011111;
        ControlStoreMEM[31]=34'b1000000000110000001000000000000000;
        ControlStoreMEM[32]=34'b0000000100000000000010001111100001;
        ControlStoreMEM[33]=34'b0101000010110010000000000011100010;
        ControlStoreMEM[34]=34'b0010101010000000000001001111100011;
        ControlStoreMEM[35]=34'b1000000000110000001000000000000000;
    end
    
endmodule
