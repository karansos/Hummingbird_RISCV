 /*                                                                      
 Copyright 2019 Blue Liang, liangkangnan@163.com
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
 Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */

`include "defines.v"

// 
module regs(

    input wire clk,
    input wire rst,

    // from ex
    input wire we_i,                      // 
    input wire[`RegAddrBus] waddr_i,      // 
    input wire[`RegBus] wdata_i,          // 

    // from jtag
    input wire jtag_we_i,                 // 
    input wire[`RegAddrBus] jtag_addr_i,  //
    input wire[`RegBus] jtag_data_i,      // 

    // from id
    input wire[`RegAddrBus] raddr1_i,     // 

    // to id
    output reg[`RegBus] rdata1_o,         // 

    // from id
    input wire[`RegAddrBus] raddr2_i,     // 

    // to id
    output reg[`RegBus] rdata2_o,         // 

    // to jtag
    output reg[`RegBus] jtag_data_o       // 

    );

    reg[`RegBus] regs[0:`RegNum - 1];

    // 
    always @ (posedge clk) begin
        if (rst == `RstDisable) begin
            // 
            if ((we_i == `WriteEnable) && (waddr_i != `ZeroReg)) begin
                regs[waddr_i] <= wdata_i;
            end else if ((jtag_we_i == `WriteEnable) && (jtag_addr_i != `ZeroReg)) begin
                regs[jtag_addr_i] <= jtag_data_i;
            end
        end
    end

    // 
    always @ (*) begin
        if (raddr1_i == `ZeroReg) begin
            rdata1_o = `ZeroWord;
        // 
        end else if (raddr1_i == waddr_i && we_i == `WriteEnable) begin
            rdata1_o = wdata_i;
        end else begin
            rdata1_o = regs[raddr1_i];
        end
    end

    // 
    always @ (*) begin
        if (raddr2_i == `ZeroReg) begin
            rdata2_o = `ZeroWord;
        // ，
        end else if (raddr2_i == waddr_i && we_i == `WriteEnable) begin
            rdata2_o = wdata_i;
        end else begin
            rdata2_o = regs[raddr2_i];
        end
    end

    // 
    always @ (*) begin
        if (jtag_addr_i == `ZeroReg) begin
            jtag_data_o = `ZeroWord;
        end else begin
            jtag_data_o = regs[jtag_addr_i];
        end
    end

endmodule
