`timescale 1ns / 1ps

module top(
    input clk,button,debug,
    output hsync,vsync,
    output [3:0] red,green,blue
    );
    
    //Initializing internal wires
    wire [10:0] scrolladdr;
    wire [9:0] vaddress,haddress;
    wire [6:0] jaddr;
    wire [4:0] random1;
    wire [3:0] color;
    wire runner,reset;
    
    //Initializing internal regs for sprites
    reg [22:0] run1 [46:0];
    reg [22:0] run2 [46:0];
    reg [22:0] death [46:0];
    reg [255:0] floor [5:0];
    reg [26:0] cactus1 [46:0];
    reg [26:0] cactus2 [46:0];
    reg [12:0] cactus3 [48:0];
    reg [2:0] select,type;
    reg collide;
    
    //Initializing pixel layers data reg
    reg [4:0] layer;
    
    //Assigning outputs
    assign red = color;
    assign green = color;
    assign blue = color;
    assign color = {4{layer[0]|layer[1]|layer[2]|layer[3]|layer[4]}};
    assign reset = collide&button;
    
    //Initializing sprite memory from files
    initial begin //TODO: Fix this idiot
    $readmemb("dino.mem", run1);
    $readmemb("dino2work.mem", run2);
    $readmemb("death.mem",death);
    $readmemb("floor.mem", floor);
    $readmemb("cactus.mem", cactus1);
    $readmemb("cactus2.mem", cactus2);
    $readmemb("cactus3.mem", cactus3);
    collide <= 1;
    select <= 0;
    type <= 0;
    end
    
    //Initializing all submodules
    jumping jumping_inst(
    .clk(clk),
    .button(button),
    .jumpaddr(jaddr),
    .halt(collide),
    .reset(reset)
    );
    dinosprite dinosprite_inst(
    .clk(clk),
    .sprite(runner)
    );
    scroll scroll_inst(
    .clk(clk),
    .pos(scrolladdr[10:0]),
    .halt(collide),
    .reset(reset)
    );
    vga vga_inst(
    .clk(clk),
    .vaddress(vaddress),
    .haddress(haddress),
    .hsync(hsync),
    .vsync(vsync)
    );
    rng rng_inst(
    .clk(clk),
    .button(button),
    .random1(random1)
    );
    
    //Main block
    always@(posedge clk)begin
        collide <= (layer[0]&(layer[1]|layer[3]|layer[4]))|(collide&~button); //TODO:Test outside of always block
        if(debug == 1)begin //Collision debug code TODO:remove in final
            collide <= 0;
        end
        layer <= 5'b0; //Set all pixel layers to 0
        if(vaddress < 480 && haddress < 640)begin //Check if video address is within scan area
            if(haddress > 100 && haddress < 123 && (vaddress + jaddr) > 200 && (vaddress + jaddr) < 247)begin //Check x and y position for printing dinosaur sprite
                //Alternate between running types or death character
                if(collide)begin
                    layer[0] <= death[vaddress-200+jaddr][haddress-100];
                end
                else begin
                    if(runner)begin
                        layer[0] <= run1[vaddress-200+jaddr][haddress-100];
                    end
                    else begin
                        layer[0] <= run2[vaddress-200+jaddr][haddress-100];
                    end
                end
            end
            if(vaddress > 244 && vaddress < 251) begin //Check the y address for printing floor/ground
                layer[2] <= floor[vaddress-245][(haddress)+scrolladdr[7:0]];
            end
            if (vaddress > 203 && vaddress < 250)begin
                if(select[0])begin
                    if(type[0])begin
                        if((haddress + scrolladdr[9:0]) > 640 && (haddress + scrolladdr[9:0]) < 667)begin //Cactus test
                            layer[1] <= cactus1[vaddress-203][haddress-640+scrolladdr[9:0]];
                        end
                    end
                    else begin
                        if((haddress + scrolladdr[9:0]) > 640 && (haddress + scrolladdr[9:0]) < 667)begin //Cactus test
                            layer[1] <= cactus2[vaddress-203][haddress-640+scrolladdr[9:0]];
                        end
                    end
                end
                if(select[1])begin
                    if(type[1])begin
                        if((haddress + scrolladdr[9:0]-250) > 640 && (haddress + scrolladdr[9:0]-250) < 667)begin //Cactus test
                            layer[3] <= cactus2[vaddress-203][haddress-640+scrolladdr[9:0]-250];
                        end
                    end
                end
                if(select[2])begin
                    if(type[2])begin
                        if((haddress + scrolladdr[10:0]-450) > 640 && (haddress + scrolladdr[10:0]-450) < 667)begin //Cactus test
                            layer[4] <= cactus1[vaddress-203][haddress-640+scrolladdr[10:0]-450];
                        end
                    end
                    else begin
                        if((haddress + scrolladdr[10:0]-450) > 640 && (haddress + scrolladdr[10:0]-450) < 667)begin //Cactus test
                            layer[4] <= cactus3[vaddress-203][haddress-640+scrolladdr[10:0]-450];
                        end
                    end
                end
            end
            if(scrolladdr[9:0]==0)begin
                select[0] <= 1;
            end
            if(scrolladdr[9:0]==250)begin
                select[1] <= 1;
            end
            if(scrolladdr[9:0]==450)begin
                select[2] <= 1;
            end
            if(scrolladdr[9:0] > 667)begin
                select[0] <= 0;
            end
            if(scrolladdr[9:0] > 917)begin
                select[1] <= 0;
            end
            if(scrolladdr[10:0] > 1117)begin
                select[2] <= 0;
            end
        end //End of valid scan area
    end //End of main block
    
    always@(posedge select[0])begin
        type[0] <= random1[2];
    end
    always@(posedge select[1])begin
        type[1] <= random1[3];
    end
    always@(posedge select[2])begin
        type[2] <= random1[4];
    end
    
endmodule