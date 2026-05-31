`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 14:22:17
// Design Name: 
// Module Name: fifo_empty
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

module fifo_empty
#(
    parameter ADDRSIZE = 4
)
(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire                 rd_en,

    input  wire [ADDRSIZE:0]    wr_ptr_gray_sync,

    output reg                  empty,

    output wire [ADDRSIZE-1:0]  rd_addr,
    output wire [ADDRSIZE:0]    rd_ptr_gray
);

reg  [ADDRSIZE:0] rd_bin;
reg  [ADDRSIZE:0] rd_gray;

wire [ADDRSIZE:0] rd_bin_next;
wire [ADDRSIZE:0] rd_gray_next;

wire empty_next;

assign rd_bin_next =
        rd_bin + ((rd_en && !empty) ? 1'b1 : 1'b0);

assign rd_gray_next =
        (rd_bin_next >> 1) ^ rd_bin_next;

assign empty_next =
        (rd_gray_next == wr_ptr_gray_sync);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        rd_bin  <= 0;
        rd_gray <= 0;
        empty   <= 1'b1;
    end
    else
    begin
        rd_bin  <= rd_bin_next;
        rd_gray <= rd_gray_next;
        empty   <= empty_next;
    end
end

assign rd_addr     = rd_bin[ADDRSIZE-1:0];
assign rd_ptr_gray = rd_gray;

endmodule