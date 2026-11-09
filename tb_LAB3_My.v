`timescale 1ns / 1ps

module tb_LAB3_My;
    reg clk;
    reg rst;
    reg start_cmd;
    reg [7:0] target_addr;
    reg [7:0] tx_data;
    reg sda_in;

    wire sda_out;
    wire sda_en;
    wire scl;

    LAB3_My uut (
        .clk(clk),
        .rst(rst),
        .start_cmd(start_cmd),
        .target_addr(target_addr),
        .tx_data(tx_data),
        .sda_in(sda_in),
        .sda_out(sda_out),
        .sda_en(sda_en),
        .scl(scl)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start_cmd = 0;
        target_addr = 8'hA0;
        tx_data = 8'h35;
        sda_in = 0;

        #40;
        rst = 0;
        #40;
        start_cmd = 1;
        #200;
        start_cmd = 0;

        #200000;
        $finish;
    end
endmodule