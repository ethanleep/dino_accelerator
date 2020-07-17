`timescale 1ns / 1ps

module rng(
    input clk,button,
    output reg [4:0] random1
    );
    
    
    initial begin
        random1 <= 5'b1;
    end
    
    always@(posedge clk)begin
        if(button)begin
            random1[0] <= random1[1]^random1[4];
            random1[1] <= random1[0];
            random1[2] <= random1[1];
            random1[3] <= random1[2];
            random1[4] <= random1[3];
        end
    end
endmodule