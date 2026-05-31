`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 14:24:17
// Design Name: 
// Module Name: sync_wr2rd
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

module sync_wr2rd
#(
    parameter ADDRSIZE = 4
)
(
    input wire clk,
    input wire rst_n,

    input wire [ADDRSIZE:0] wr_ptr_gray,

    output wire [ADDRSIZE:0] wr_ptr_gray_sync
);

reg [ADDRSIZE:0] sync_ff1;
reg [ADDRSIZE:0] sync_ff2;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        sync_ff1 <= 0;
        sync_ff2 <= 0;
    end
    else
    begin
        sync_ff1 <= wr_ptr_gray;
        sync_ff2 <= sync_ff1;
    end
end

assign wr_ptr_gray_sync = sync_ff2;

endmodule