`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 14:25:01
// Design Name: 
// Module Name: reset_sync
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


module reset_sync
(
    input  wire clk,
    input  wire rst_n,
    output wire sync_rst_n
);

reg rst_ff1;
reg rst_ff2;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        rst_ff1 <= 1'b0;
        rst_ff2 <= 1'b0;
    end
    else
    begin
        rst_ff1 <= 1'b1;
        rst_ff2 <= rst_ff1;
    end
end

assign sync_rst_n = rst_ff2;

endmodule
