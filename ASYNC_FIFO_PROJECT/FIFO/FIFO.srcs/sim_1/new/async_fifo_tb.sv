 `timescale 1ns/1ps

module async_fifo_tb;

parameter DATASIZE = 8;
parameter ADDRSIZE = 4;

reg wr_clk;
reg rd_clk;

reg wr_rst_n;
reg rd_rst_n;

reg wr_en;
reg rd_en;

reg [7:0] wr_data;
wire [7:0] rd_data;

wire full;
wire empty;

byte ref_data;
integer i;

reg [7:0] pattern [0:15];

reg [7:0] write_history [0:15];
reg [7:0] read_history  [0:15];

async_fifo_top DUT
(
    .i_wr_clk(wr_clk),
    .i_rd_clk(rd_clk),

    .i_wr_rst_n(wr_rst_n),
    .i_rd_rst_n(rd_rst_n),

    .i_wr_en(wr_en),
    .i_rd_en(rd_en),

    .i_wr_data(wr_data),

    .o_rd_data(rd_data),

    .o_full(full),
    .o_empty(empty)
);

ref_fifo REF();
scoreboard SB();

initial wr_clk = 0;
always #5 wr_clk = ~wr_clk;

initial rd_clk = 0;
always #8 rd_clk = ~rd_clk;

initial begin

    pattern[0]  = 8'h24;
    pattern[1]  = 8'h81;
    pattern[2]  = 8'h09;
    pattern[3]  = 8'h63;
    pattern[4]  = 8'h0D;
    pattern[5]  = 8'h8D;
    pattern[6]  = 8'h65;
    pattern[7]  = 8'h12;
    pattern[8]  = 8'h01;
    pattern[9]  = 8'h0D;
    pattern[10] = 8'h76;
    pattern[11] = 8'h3D;
    pattern[12] = 8'hED;
    pattern[13] = 8'h8C;
    pattern[14] = 8'hF9;
    pattern[15] = 8'hC6;

end

initial begin

    wr_rst_n = 0;
    rd_rst_n = 0;

    wr_en = 0;
    rd_en = 0;

    wr_data = 0;

    #50;

    wr_rst_n = 1;
    rd_rst_n = 1;

end

// WRITE

initial begin

    wait(wr_rst_n);

    #20;

    for(i=0;i<16;i=i+1)
    begin

        @(posedge wr_clk);

        if(!full)
        begin

            wr_en   = 1'b1;
            wr_data = pattern[i];

            write_history[i] = pattern[i];

            REF.write(pattern[i]);

        end

    end

    @(posedge wr_clk);

    wr_en = 0;

end

// READ

initial begin

    wait(full);

    #20;

    for(i=0;i<16;i=i+1)
    begin

        @(posedge rd_clk);

        if(!empty)
        begin

            rd_en = 1'b1;

            REF.read(ref_data);

            @(posedge rd_clk);

            read_history[i] = rd_data;

            SB.compare(
                rd_data,
                ref_data
            );

        end

    end

    @(posedge rd_clk);

    rd_en = 0;

    #100;

    $display("PASS COUNT = %0d",SB.pass_count);
    $display("FAIL COUNT = %0d",SB.fail_count);

    $finish;

end

endmodule