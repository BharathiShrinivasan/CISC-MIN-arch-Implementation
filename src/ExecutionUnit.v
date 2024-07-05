`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2023 11:14:00
// Design Name: 
// Module Name: ExecutionUnit
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


module ExecutionUnit(
    input [3:0] ClockSource,
    input [25:0] DecodedControlWord,
    input [2:0] RxSel,
    input [2:0] RySel,
    input [2:0] ExtOpCode,
    output [15:0] MEM_AddressLine,
    input [15:0] MEM_ReadLine,
    output [15:0] MEM_WriteLine,
    output MEM_WriteSignal,
    output [3:0] ALUFlag,
    output [15:0] IRE_Read
    );
    
    reg[15:0] BusA, BusB;
    
    // segregate wires    
    wire bit_IreIrf,bit_WriteDO,bit_IntExtOp,bit_flagUpdate,bit_T1Update,bit_EnableALU;
    wire[1:0] bit_SrcAO, bit_DesEdb,bit_SrcRx,bit_SrcRy,bit_SrcT2,bit_SrcPC,bit_2ndOperand;
    wire[2:0] bit_SrcABus,bit_SrcBBus;
    
    assign  bit_IreIrf=DecodedControlWord[25],
            bit_SrcAO=DecodedControlWord[24:23],
            bit_WriteDO=DecodedControlWord[22],
            bit_DesEdb=DecodedControlWord[21:20],
            bit_SrcABus=DecodedControlWord[19:17],
            bit_SrcBBus=DecodedControlWord[16:14],
            bit_SrcRx=DecodedControlWord[13:12],
            bit_SrcRy=DecodedControlWord[11:10],
            bit_SrcT2=DecodedControlWord[9:8],
            bit_SrcPC=DecodedControlWord[7:6],
            bit_2ndOperand=DecodedControlWord[5:4],
            bit_IntExtOp=DecodedControlWord[3],
            bit_flagUpdate=DecodedControlWord[2],
            bit_T1Update=DecodedControlWord[1],
            bit_EnableALU=DecodedControlWord[0];
            
    wire [15:0] T1_Read;
    ALU ALUUnit(.ClockInput(ClockSource[0]),.Enable(bit_EnableALU),.ExtOpCode(ExtOpCode),.OperandSelect(bit_2ndOperand),.IsExtOperation(bit_IntExtOp),.UpdateFlag(bit_flagUpdate),.UpdateResult(bit_T1Update),.Bus_A(BusA),.Bus_B(BusB),.Read_T1(T1_Read),.Read_Flag(ALUFlag));/*input ClockInput,input Enable,input [2:0] ExtOpCode,input [1:0] OperandSelect,input IsExtOperation,input UpdateFlag,input UpdateResult,input [15:0] Bus_A,input [15:0] Bus_B,output reg [15:0] Read_T1,output reg [3:0] Read_Flag */
    
    wire[15:0] Rx_Read,Ry_Read;
    reg[15:0] Rx_Write,Ry_Write;
    reg Rx_WriteEnable,Ry_WriteEnable;
    RegisterBank ProgRegister(.ClockInput(ClockSource[0]),.RxSel(RxSel),.RySel(RySel),.Read_Rx(Rx_Read),.WriteData_Rx(Rx_Write),.Read_Ry(Ry_Read),.WriteData_Ry(Ry_Write),.WriteRx(Rx_WriteEnable),.WriteRy(Ry_WriteEnable)); /*input ClockInput,input [2:0] RxSel,input [2:0] RySel,output [15:0] Read_Rx,input [15:0] WriteData_Rx,output [15:0] Read_Ry,input [15:0] WriteData_Ry,input WriteRx,input WriteRy*/
    
    wire[15:0] T2_Read;reg[15:0] T2_Write; reg T2_WriteEnable;
    SimpleRegister T2(.ClockInput(ClockSource[0]),.WriteData(T2_Write),.WriteReg(T2_WriteEnable),.ReadData(T2_Read)); /*input [15:0] WriteData,input WriteReg,input ClockInput,output reg [15:0] ReadData*/
    wire[15:0] PC_Read;reg[15:0] PC_Write; reg PC_WriteEnable;
    SimpleRegister PC(.ClockInput(ClockSource[0]),.WriteData(PC_Write),.WriteReg(PC_WriteEnable),.ReadData(PC_Read));
    reg[15:0] AO_Write; reg AO_WriteEnable; 
    SimpleRegister AO(.ClockInput(ClockSource[0]),.WriteData(AO_Write),.WriteReg(AO_WriteEnable),.ReadData(MEM_AddressLine)); 
    //reg[15:0] DO_Write;
    SimpleRegister DO(.ClockInput(ClockSource[0]),.WriteData(BusA),.WriteReg(MEM_WriteSignal),.ReadData(MEM_WriteLine)); 
           
    wire[15:0] DI_Read; reg DI_WriteEnable;
    SimpleRegister DI(.ClockInput(ClockSource[1]),.WriteData(MEM_ReadLine),.WriteReg(DI_WriteEnable),.ReadData(DI_Read));

    wire[15:0] IRF_Read; reg IRF_WriteEnable;
    SimpleRegister IRF(.ClockInput(ClockSource[1]),.WriteData(MEM_ReadLine),.WriteReg(IRF_WriteEnable),.ReadData(IRF_Read));
    
    SimpleRegister IRE(.ClockInput(ClockSource[0]),.WriteData(IRF_Read),.WriteReg(bit_IreIrf),.ReadData(IRE_Read));
            
    // PHASE 0 : Src->A bus, Src->B bus
    
    always @(*)//bit_SrcABus)
    begin
        case(bit_SrcABus)
            1:BusA=Rx_Read;
            2:BusA=Ry_Read;
            3:BusA=T1_Read;
            4:BusA=T2_Read;
            5:BusA=PC_Read;
            default:BusA=16'bZ;
        endcase
    end     
        always @(*)//bit_SrcBBus)
    begin
        case(bit_SrcBBus)
            1:BusB=Rx_Read;
            2:BusB=Ry_Read;
            3:BusB=T1_Read;
            4:BusB=T2_Read;
            5:BusB=PC_Read;
            6:BusB=DI_Read;
            default:BusB=16'bZ;
        endcase
    end   
    
    // PHASE 1 : Bus destination, ALU operation, MEM_AddressPlace
	always @(*)//bit_SrcRx)
	begin
		case (bit_SrcRx)
			1:begin Rx_Write=BusA;Rx_WriteEnable=1; end
			2:begin Rx_Write=BusB;Rx_WriteEnable=1; end
			default: begin Rx_Write=BusA; Rx_WriteEnable=0; end
		endcase
	end
    
                                       
	always @(*)//bit_SrcRy)
	begin
		case (bit_SrcRy)
			1:begin Ry_Write=BusA;Ry_WriteEnable=1; end
			2:begin Ry_Write=BusB;Ry_WriteEnable=1; end
			default: begin Ry_Write=BusA; Ry_WriteEnable=0; end
		endcase
	end									
										

	always @(*)//bit_SrcT2)
	begin
		case (bit_SrcT2)
			1:begin T2_Write=BusA;T2_WriteEnable=1; end
			2:begin T2_Write=BusB;T2_WriteEnable=1; end
			default: begin T2_Write=BusA; T2_WriteEnable=0; end
		endcase
	end		
	
	always @(*)//bit_SrcPC)
	begin
		case (bit_SrcPC)
			1:begin PC_Write=BusA;PC_WriteEnable=1; end
			2:begin PC_Write=BusB;PC_WriteEnable=1; end
			default: begin PC_Write=BusA;PC_WriteEnable=0;end
		endcase
	end		
							
	always @(*)//bit_SrcAO)
	begin
		case (bit_SrcAO)
			1:begin AO_Write=BusA;AO_WriteEnable=1; end
			2:begin AO_Write=BusB;AO_WriteEnable=1; end
			default: begin AO_Write=BusA; AO_WriteEnable=0; end
		endcase
	end		     
	
    // PHASE 2 : MEM_Read, MEM_Write operation
    
    assign MEM_WriteSignal=(bit_WriteDO==1)?1:0;
    
    always @(*)//bit_DesEdb)
    begin
        DI_WriteEnable=(bit_DesEdb==1);
        IRF_WriteEnable=(bit_DesEdb==2);
    end
    
        
endmodule
