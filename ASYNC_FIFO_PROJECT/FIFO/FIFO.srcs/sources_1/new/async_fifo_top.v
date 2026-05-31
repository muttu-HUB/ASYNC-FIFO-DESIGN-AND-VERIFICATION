`timescale 1ns / 1ps

module async_fifo_top
#(
    parameter DATASIZE = 8,
    parameter ADDRSIZE = 4
)
(
    input wire i_wr_clk,
    input wire i_rd_clk,

    input wire i_wr_rst_n,
    input wire i_rd_rst_n,

    input wire i_wr_en,
    input wire i_rd_en,

    input wire [DATASIZE-1:0] i_wr_data,

    output wire [DATASIZE-1:0] o_rd_data,

    output wire o_full,
    output wire o_empty
);

wire wr_rst_sync_n;
wire rd_rst_sync_n;

wire [ADDRSIZE:0] wr_ptr_gray;
wire [ADDRSIZE:0] rd_ptr_gray;

wire [ADDRSIZE:0] wr_ptr_gray_sync;
wire [ADDRSIZE:0] rd_ptr_gray_sync;

wire [ADDRSIZE-1:0] wr_addr;
wire [ADDRSIZE-1:0] rd_addr;

//--------------------------------------------------
// Reset Synchronizers
//--------------------------------------------------

reset_sync u_wr_reset_sync
(
    .clk(i_wr_clk),
    .rst_n(i_wr_rst_n),
    .sync_rst_n(wr_rst_sync_n)
);

reset_sync u_rd_reset_sync
(
    .clk(i_rd_clk),
    .rst_n(i_rd_rst_n),
    .sync_rst_n(rd_rst_sync_n)
);

//--------------------------------------------------
// Pointer Synchronizers
//--------------------------------------------------

sync_rd2wr #(
    .ADDRSIZE(ADDRSIZE)
)
u_sync_rd2wr
(
    .clk(i_wr_clk),
    .rst_n(wr_rst_sync_n),

    .rd_ptr_gray(rd_ptr_gray),

    .rd_ptr_gray_sync(rd_ptr_gray_sync)
);

sync_wr2rd #(
    .ADDRSIZE(ADDRSIZE)
)
u_sync_wr2rd
(
    .clk(i_rd_clk),
    .rst_n(rd_rst_sync_n),

    .wr_ptr_gray(wr_ptr_gray),

    .wr_ptr_gray_sync(wr_ptr_gray_sync)
);

//--------------------------------------------------
// Full Logic
//--------------------------------------------------

fifo_full #(
    .ADDRSIZE(ADDRSIZE)
)
u_fifo_full
(
    .clk(i_wr_clk),
    .rst_n(wr_rst_sync_n),

    .wr_en(i_wr_en),

    .rd_ptr_gray_sync(rd_ptr_gray_sync),

    .full(o_full),

    .wr_addr(wr_addr),

    .wr_ptr_gray(wr_ptr_gray)
);

//--------------------------------------------------
// Empty Logic
//--------------------------------------------------

fifo_empty #(
    .ADDRSIZE(ADDRSIZE)
)
u_fifo_empty
(
    .clk(i_rd_clk),
    .rst_n(rd_rst_sync_n),

    .rd_en(i_rd_en),

    .wr_ptr_gray_sync(wr_ptr_gray_sync),

    .empty(o_empty),

    .rd_addr(rd_addr),

    .rd_ptr_gray(rd_ptr_gray)
);

//--------------------------------------------------
// FIFO MEMORY
//--------------------------------------------------

fifo_mem #(
    .DATASIZE(DATASIZE),
    .ADDRSIZE(ADDRSIZE)
)
u_fifo_mem
(
    .wr_clk(i_wr_clk),
    .wr_en(i_wr_en && !o_full),

    .wr_addr(wr_addr),
    .rd_addr(rd_addr),

    .wr_data(i_wr_data),

    .rd_data(o_rd_data)
);

endmodule