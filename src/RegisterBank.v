`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2023 15:59:57
// Design Name: 
// Module Name: RegisterBank
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


module RegisterBank(
    input ClockInput,
    input [2:0] RxSel,
    input [2:0] RySel,
    output [15:0] Read_Rx,
    input [15:0] WriteData_Rx,
    output [15:0] Read_Ry,
    input [15:0] WriteData_Ry,
    input WriteRx,
    input WriteRy
    );
    
    reg [15:0] ProgRegister[7:0]; // R0-R7 16bit size
    
    assign Read_Rx=ProgRegister[RxSel];    
    assign Read_Ry=ProgRegister[RySel];
    
    integer i; reg[7:0] CEPin; reg[15:0] DataPin[7:0];
    
    always @(*)//RxSel,WriteRx,RySel,WriteRy)
    begin
        for(i=0;i<8;i=i+1)
        begin
            CEPin[i]=(RxSel==i & WriteRx)|(RySel==i & WriteRy);
            DataPin[i]=(RxSel==i & WriteRx)?WriteData_Rx:WriteData_Ry;
            //if((RxSel==i & WriteRx)|(RySel==i & WriteRy)) ProgRegister[i]<=(RxSel==i & WriteRx)?WriteData_Rx:WriteData_Ry;
        end
    end
    
    integer j=0;
    always @(posedge ClockInput)
    begin
        for(j=0;j<8;j=j+1)
        begin
            if(CEPin[j])ProgRegister[j]<=DataPin[j];
        end
    end
    
    initial begin
        ProgRegister[0]=0;
        ProgRegister[1]=1;
        ProgRegister[2]=1;
        ProgRegister[3]=1;
        ProgRegister[4]=11;
        ProgRegister[5]=1;
        ProgRegister[6]=0;
        ProgRegister[7]=233;
         
        /*ProgRegister[0]=0;
        ProgRegister[1]=11;
        ProgRegister[2]=22;
        ProgRegister[3]=33;
        ProgRegister[4]=44;
        ProgRegister[5]=55;
        ProgRegister[6]=66;
        ProgRegister[7]=200; // Data Segment pointer*/
    end
   
endmodule
