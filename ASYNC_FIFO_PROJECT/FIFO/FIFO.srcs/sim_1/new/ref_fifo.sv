`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 14:17:42
// Design Name: 
// Module Name: ref_fifo
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

module ref_fifo;

    byte fifo_q[$];

    task write(input byte data);
    begin
        fifo_q.push_back(data);
    end
    endtask

    task read(output byte data);
    begin
        if(fifo_q.size() > 0)
            data = fifo_q.pop_front();
    end
    endtask

endmodule