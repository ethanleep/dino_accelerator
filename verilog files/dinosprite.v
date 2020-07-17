`timescale 1ns / 1ps

module dinosprite(
    input clk,
    output reg sprite
    );
    
    //Initialize counter
    reg [23:0] runner;
    
    //Initialize values
    initial begin
        runner <= 24'b0;
        sprite <= 1'b0;
    end

    //Main block, alternates the runner boolean value approximately every 230 milliseconds
    always@(posedge clk)begin
        runner <= runner + 1;
        if(runner == 3000000)begin
            sprite <= !sprite;
            runner <= 25'b0;
        end
    end //End block
    
    
endmodule
