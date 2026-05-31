`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 14:21:31
// Design Name: 
// Module Name: fifo_full
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


module fifo_full
#(
    parameter ADDRSIZE = 4
)
(
    input  wire clk,
    input  wire rst_n,
    input  wire wr_en,

    input  wire [ADDRSIZE:0] rd_ptr_gray_sync,

    output reg  full,

    output wire [ADDRSIZE-1:0] wr_addr,
    output wire [ADDRSIZE:0] wr_ptr_gray
);

reg [ADDRSIZE:0] wr_bin;
reg [ADDRSIZE:0] wr_gray;

wire [ADDRSIZE:0] wr_bin_next;
wire [ADDRSIZE:0] wr_gray_next;

assign wr_bin_next =
    wr_bin + ((wr_en && !full) ? 1'b1 : 1'b0);

assign wr_gray_next =
    (wr_bin_next >> 1) ^ wr_bin_next;

assign wr_addr = wr_bin[ADDRSIZE-1:0];

assign wr_ptr_gray = wr_gray;

wire full_next;

assign full_next =
(
    wr_gray_next ==
    {
        ~rd_ptr_gray_sync[ADDRSIZE:ADDRSIZE-1],
         rd_ptr_gray_sync[ADDRSIZE-2:0]
    }
);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        wr_bin  <= 0;
        wr_gray <= 0;
        full    <= 1'b0;
    end
    else
    begin
        wr_bin  <= wr_bin_next;
        wr_gray <= wr_gray_next;
        full    <= full_next;
    end
end

endmodule