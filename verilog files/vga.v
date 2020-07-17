`timescale 1ns / 1ps

module vga(
    input clk,
    output reg [9:0] vaddress,haddress,
    output reg vsync,hsync
    );
    
    //Initialize values
    initial begin
        vsync <= 1'b1;
        hsync <= 1'b1;
        vaddress <= 9'b0;
        haddress <= 9'b0;
    end
    
    //Main block
    always@(posedge clk)begin
        //Reset hsync and increment horizontal address
        hsync <= 1'b1;
        haddress <= haddress + 1;
        if(haddress >= 656 && haddress < 752)begin //Generate horizontal sync pulse
            hsync <= 1'b0;
        end
        if(haddress == 800)begin //Reset horizontal counter at end of horizontal scan and add to vertical address
            vsync <= 1'b1;
            haddress <= 9'b0;
            vaddress <= vaddress + 1;
            if(vaddress >= 490 && vaddress < 492)begin //Generate vertical sync pulse
                vsync <= 1'b0;
            end
            if(vaddress == 525)begin //Reset vertical counter at end of scan
                vaddress <= 9'b0;
            end
        end
    end //End of main block
endmodule