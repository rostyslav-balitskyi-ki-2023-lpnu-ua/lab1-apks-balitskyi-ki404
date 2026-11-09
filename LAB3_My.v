`timescale 1ns / 1ps

module LAB3_My (
    input wire clk,
    input wire rst,
    input wire start_cmd,
    input wire [7:0] target_addr,
    input wire [7:0] tx_data,
    input wire sda_in,
    output reg sda_out,
    output reg sda_en,
    output reg scl
);

    parameter IDLE          = 3'd0;
    parameter START         = 3'd1;
    parameter SEND_ADDR     = 3'd2;
    parameter WAIT_ACK_ADDR = 3'd3;
    parameter SEND_DATA     = 3'd4;
    parameter WAIT_ACK_DATA = 3'd5;
    parameter STOP          = 3'd6;

    reg [2:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg [7:0] clk_div;
    
    wire tick = (clk_div == 8'd100);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            sda_out <= 1'b1;
            sda_en <= 1'b1;
            scl <= 1'b1;
            bit_count <= 3'd7;
            clk_div <= 8'd0;
        end else begin
            clk_div <= clk_div + 1;
            
            if (tick) begin
                clk_div <= 8'd0;
                
                case (state)
                    IDLE: begin
                        sda_out <= 1'b1;
                        sda_en <= 1'b1;
                        scl <= 1'b1;
                        
                        if (start_cmd) begin
                            state <= START;
                            shift_reg <= target_addr;
                        end
                    end
                    
                    START: begin
                        sda_out <= 1'b0;
                        scl <= 1'b1;
                        state <= SEND_ADDR;
                        bit_count <= 3'd7;
                    end
                    
                    SEND_ADDR: begin
                        scl <= ~scl;
                        if (!scl) begin
                            sda_out <= shift_reg[bit_count];
                            if (bit_count == 0) begin
                                state <= WAIT_ACK_ADDR;
                            end else begin
                                bit_count <= bit_count - 1;
                            end
                        end
                    end
                    
                    WAIT_ACK_ADDR: begin
                        scl <= ~scl;
                        if (!scl) begin
                            sda_en <= 1'b0;
                        end else begin
                            if (sda_in == 1'b0) begin
                                state <= SEND_DATA;
                                shift_reg <= tx_data;
                                bit_count <= 3'd7;
                            end else begin
                                state <= STOP;
                            end
                            sda_en <= 1'b1;
                        end
                    end
                    
                    SEND_DATA: begin
                        scl <= ~scl;
                        if (!scl) begin
                            sda_out <= shift_reg[bit_count];
                            if (bit_count == 0) begin
                                state <= WAIT_ACK_DATA;
                            end else begin
                                bit_count <= bit_count - 1;
                            end
                        end
                    end
                    
                    WAIT_ACK_DATA: begin
                        scl <= ~scl;
                        if (!scl) begin
                            sda_en <= 1'b0;
                        end else begin
                            state <= STOP;
                            sda_en <= 1'b1;
                        end
                    end
                    
                    STOP: begin
                        if (!scl) begin
                            scl <= 1'b1;
                            sda_out <= 1'b0;
                        end else begin
                            sda_out <= 1'b1;
                            state <= IDLE;
                        end
                    end
                    
                    default: state <= IDLE;
                endcase
            end
        end
    end
endmodule