`timescale 1ns / 1ps

//This script is responsible for generating the x position for the cactus and floor movement

module scroll(
    input clk,halt,reset,
    output reg [10:0] pos
    );
    
    //Initialize counters
    reg [17:0] millisecond,increment;
    
    //Initialize values
    initial begin
        millisecond <= 0;
        pos <= 0;
        increment <= 18'd251250; //Starting increment of 251250 clock pulses
    end
    
    //Main block, slowly increases horizontal speed over time
    always@(posedge clk)begin
        if(reset == 1)begin
            pos <= 0;
            millisecond <= 0;
            increment <= 18'd251250;
        end
        if(halt == 0)begin
            millisecond <= millisecond + 1;
            if(millisecond == increment)begin
                millisecond <= 0;
                increment <= increment - 4;
                pos <= pos + 2;
            end
        end
    end //End of main block
    
endmodule
