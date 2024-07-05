`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.07.2023 13:24:49
// Design Name: 
// Module Name: ClockGeneratorUnit
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


module ClockGeneratorUnit(
    //input PLClock,
    output reg [3:0] ClockSource=0
    );
    
    reg PLClock=0;
    always begin
        #2
        PLClock=~PLClock;
    end
    
    parameter msb=0; // deducedClockSource = 100Mhz/2^31 = 
    
    reg[msb:0] tick=0;
    always @(posedge PLClock)
    begin
        tick<=tick+1;
    end
    
    reg[2:0] i=4'b0;
    
    always@(posedge tick[msb])
    begin
        case(i)
            0: begin ClockSource<=4'b0; i=i+1; end
            1: begin ClockSource[0]<=1'b1; i=i+1; end
            2: begin ClockSource[1]<=1'b1;i=i+1; end
            3: begin ClockSource[2]<=1'b1; i=i+1; end
            4: begin ClockSource[3]<=1; i=0; end
        endcase 
    end
            
    
endmodule
