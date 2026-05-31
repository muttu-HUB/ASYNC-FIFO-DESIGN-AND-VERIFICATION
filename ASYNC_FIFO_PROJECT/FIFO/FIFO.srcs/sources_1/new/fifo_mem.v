//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 14:20:48
// Design Name: 
// Module Name: fifo_mem
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

`timescale 1ns / 1ps

module fifo_mem
#(
    parameter DATASIZE = 8,
    parameter ADDRSIZE = 4
)
(
    input wire wr_clk,
    input wire wr_en,

    input wire [ADDRSIZE-1:0] wr_addr,
    input wire [ADDRSIZE-1:0] rd_addr,

    input wire [DATASIZE-1:0] wr_data,

    output wire [DATASIZE-1:0] rd_data
);

localparam DEPTH = (1 << ADDRSIZE);

reg [DATASIZE-1:0] mem [0:DEPTH-1];

always @(posedge wr_clk)
begin
    if(wr_en)
        mem[wr_addr] <= wr_data;
end

assign rd_data = mem[rd_addr];

endmodule