`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2025 15:00:09
// Design Name: 
// Module Name: Basic_Task_D
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Basic_Task_D(
    input [12:0] pixelIndex,
    input rightPushButton, leftPushButton, upPushButton, downPushButton, clk,
    output reg [15:0] pixelData
    );
    // General Coordinate Calculation
    localparam MAX_X = 95;
    localparam MIN_X = 0;
    localparam MAX_Y = 63;
    localparam MIN_Y = 0;
    wire [7:0] x = pixelIndex % 96;
    wire [7:0] y = pixelIndex / 96;
    
    // Variables for Red/Green squares
    localparam RED_WIDTH = 30;
    localparam RED_X = 66;
    localparam RED_Y = 0;
    
    localparam GREEN_WIDTH = 10;
    reg [7:0] green_x = 0;
    reg [7:0] green_y = 54;
    
    // Generate 25 MHz and 30hz clock
    wire clock25MHz, clock30Hz;
    flexible_clock #( .CLK_DIV(2) ) clk_gen_25MHz (
        .clk_in(clk),
        .clk_out(clock25MHz)
    );
    flexible_clock #( .CLK_DIV(1_666_666) ) clk_gen_30Hz (
        .clk_in(clk),
        .clk_out(clock30Hz)
    );
   
    // Colour code constants
    localparam RED = 16'b11111_000000_00000;
    localparam GREEN = 16'b00000_111111_00000;
    localparam BLACK = 16'b00000_000000_00000;
    
    // Drawing Block
    always @ (posedge clock25MHz)
    begin
        if ((x >= RED_X & x < RED_X + RED_WIDTH) 
            && (y >= RED_Y && y < RED_Y + RED_WIDTH))
            pixelData <= RED;
        else if ((x >= green_x && x < green_x + GREEN_WIDTH)
            && (y >= green_y && y < green_y + GREEN_WIDTH))
            pixelData <= GREEN;
        else
            pixelData <= BLACK;
    end
    
    // Green Square Coordinate Update Block
    reg [2:0] moving = 0; // 0: not moving, 1: right, 2: left, 3: up, 4: down
    always @ (posedge clock30Hz)
    begin
        if (moving == 0) // read pb input
            begin
                if (rightPushButton) moving <= 1;
                if (leftPushButton) moving <= 2;
                if (upPushButton) moving <= 3;
                if (downPushButton) moving <= 4;
            end 
        else
            begin 
                // Check whether should stop moving
                if ((green_y <= RED_WIDTH  && green_x >= (MAX_X-RED_WIDTH-GREEN_WIDTH + 1) && moving == 1) // right collision with Red square  
                    || (green_x >= (MAX_X-RED_WIDTH+1) && green_y <= (RED_WIDTH) && moving == 3) // up collision with Red Square
                    || (green_x >= (MAX_X-GREEN_WIDTH + 1) && moving == 1) // right border collision
                    || (green_x <= MIN_X && moving == 2) // left border collision
                    || (green_y >= (MAX_Y-GREEN_WIDTH + 1) && moving == 4) // bottom border collision
                    || (green_y <= MIN_Y && moving == 3) // top border collision
                )
                    moving <= 0; // set moving = 0 to end movement
                else
                // Continue moving, update coordinates of green square.
                    case (moving)
                        1: green_x <= green_x + 1; // RIGHT
                        2: green_x <= green_x - 1; // LEFT
                        3: green_y <= green_y - 1; // UP
                        4: green_y <= green_y + 1; // DOWN
                        default: ;
                    endcase
            end
    end
endmodule
