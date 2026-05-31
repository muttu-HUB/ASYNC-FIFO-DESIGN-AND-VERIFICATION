`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 14:18:30
// Design Name: 
// Module Name: scoreboard
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

module scoreboard;

integer pass_count;
integer fail_count;

initial begin
    pass_count = 0;
    fail_count = 0;
end

task compare(
    input [7:0] dut_data,
    input [7:0] ref_data
);
begin
    if(dut_data == ref_data)
    begin
        pass_count = pass_count + 1;
        $display("PASS DUT=%h REF=%h", dut_data, ref_data);
    end
    else
    begin
        fail_count = fail_count + 1;
        $display("FAIL DUT=%h REF=%h", dut_data, ref_data);
    end
end
endtask

endmodule