`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2025 22:20:40
// Design Name: 
// Module Name: Team_09_Oled
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


module Team_09_Oled(
    input [12:0] pixelIndex,
    input clk,
    output reg [15:0] pixelData
    );    
    wire [7:0] x = pixelIndex % 96;
    wire [7:0] y = pixelIndex / 96;
    
    localparam BLACK = 16'b00000_000000_00000;
    localparam WHITE = 16'b11111_111111_11111;
    
    always @ (posedge clk)
    begin
        if (
            (((x >= 13 && x <= 18) || (x >= 38 && x <= 43) || (x >= 77 && x <= 82)) && (y >= 8 && y <= 54))
            || (((y >= 8 && y <= 13) || (y >= 49 && y <= 54)) && (x >= 19 && x <= 37))
            || (((y >= 8 && y <= 13) || (y >= 29 && y <= 34)) && (x >= 56 && x <= 76))
            || ((x >= 50 && x <= 76) && (y >= 49 && y <= 54))
            || ((x >= 50 && x <= 55) && (y >= 8 && y <= 34))
        )
            pixelData <= WHITE;
        else
            pixelData <= BLACK;
    end
    
endmodule


