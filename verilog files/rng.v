`timescale 1ns / 1ps

//This script is responsible for generating a pseudo-random output for cacti generation

module rng(
    input clk,button,
    output reg [4:0] random1
    );
    
    //Set initial values
    initial begin
        random1 <= 5'b1;
    end
    
    //Main block, generates a pseudo-random output
    always@(posedge clk)begin
        if(button)begin //If the jump button is pressed then increment this pseudo-random counter
            random1[0] <= random1[1]^random1[4];
            random1[1] <= random1[0];
            random1[2] <= random1[1];
            random1[3] <= random1[2];
            random1[4] <= random1[3];
        end
    end
endmodule