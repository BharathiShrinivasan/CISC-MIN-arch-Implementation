`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2023 20:19:46
// Design Name: 
// Module Name: InstructionDecoderUnit
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

    /*  Programmer's Instruction format
        15-14	13-10	9-8	    7	     6-4	3	    2-0
        2-bit	4-bit	2-bit	1-bit	3-bit	1-bit	3-bit
        Future	Op Code	Mode	Future	Rx	    Future	Ry */

        
module InstructionDecoderUnit(
    input ClockInput,
    input [15:0] IRE_OpCode,
    output reg [5:0] IB_Address=0,
    output reg [5:0] SB_Address=0,
    output reg [2:0] ExtOpCode=0,
    output reg [2:0] RxSelected=0,
    output reg [2:0] RySelected=0
    );
    
    parameter OpCode_NOP=0,OpCode_LDR=1,OpCode_STR=2,OpCode_TST=3,OpCode_BZ=4,OpCode_ADD=5,OpCode_SUB=6,OpCode_AND=7,OpCode_OR=8,OpCode_XOR=9,OpCode_PUSH=10,OpCode_POP=11;
    parameter DirectAddressing=0,IndirectAddressing=1,IndirectPlusDP=2;
    
    parameter ADD=3'b000, SUB=3'b001, AND=3'b100, OR=3'b101, XOR=3'b110;
    
    wire[3:0] OpCode;
    assign OpCode=IRE_OpCode[15:12];
    wire[1:0] AddressingMode;
    assign AddressingMode=IRE_OpCode[9:8];
    
    
    always @(posedge ClockInput) // Update the IB and SB
    begin
        case(OpCode)
            OpCode_LDR: begin
                            case(AddressingMode)
                                DirectAddressing: begin IB_Address<=15;SB_Address<=15; end
                                IndirectAddressing: begin IB_Address<=5;SB_Address<=6; end
                                IndirectPlusDP: begin IB_Address<=1;SB_Address<=6; end
                                default: begin IB_Address<=15;SB_Address<=15; end
                            endcase 
                        end
            OpCode_STR: begin
                            case(AddressingMode)
                                DirectAddressing: begin IB_Address<=17;SB_Address<=17; end
                                IndirectAddressing: begin IB_Address<=5;SB_Address<=8; end
                                IndirectPlusDP: begin IB_Address<=1;SB_Address<=8; end
                                default: begin IB_Address<=17;SB_Address<=17; end
                            endcase 
                        end
            OpCode_TST: begin
                            case(AddressingMode)
                                DirectAddressing: begin IB_Address<=5;SB_Address<=5; end
                                IndirectAddressing: begin IB_Address<=5;SB_Address<=19; end
                                IndirectPlusDP: begin IB_Address<=1;SB_Address<=19; end
                                default: begin IB_Address<=5;SB_Address<=5; end
                            endcase 
                        end
            OpCode_BZ: begin
                            IB_Address<=11;
                            SB_Address<=11;
                        end
            OpCode_ADD,OpCode_SUB,OpCode_AND,OpCode_OR,OpCode_XOR: begin
                            case(AddressingMode)
                                DirectAddressing: begin IB_Address<=25;SB_Address<=25; end
                                IndirectAddressing: begin IB_Address<=5;SB_Address<=21; end
                                IndirectPlusDP: begin IB_Address<=1;SB_Address<=21; end
                                default: begin IB_Address<=25;SB_Address<=25; end
                            endcase 
                        end
            OpCode_PUSH: begin
                            IB_Address<=32;
                            SB_Address<=32;
                        end
            OpCode_POP: begin
                            IB_Address<=28;
                            SB_Address<=28;
                        end
            default:    begin // NOP instructions
                            IB_Address<=0;
                            SB_Address<=0;
                        end
        endcase 
    end
    
    
    always @(posedge ClockInput) // Update Rx and Ry
    begin
        RxSelected<=IRE_OpCode[6:4];
        RySelected<=IRE_OpCode[2:0];
    end
    
    always @(posedge ClockInput) // Update ALU extOpCode
    begin
        case(OpCode)
            OpCode_ADD:ExtOpCode<=ADD;
            OpCode_SUB:ExtOpCode<=SUB;
            OpCode_AND:ExtOpCode<=AND;
            OpCode_OR:ExtOpCode<=OR;
            OpCode_XOR:ExtOpCode<=XOR;
            default:ExtOpCode<=ADD;
        endcase 
    end
    


    
    

    
    
endmodule
