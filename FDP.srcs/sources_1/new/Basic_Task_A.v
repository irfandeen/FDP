`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2025 09:54:49
// Design Name: 
// Module Name: Basic_Task_A
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


module Basic_Task_A (
    input wire [12:0] pixel_index,
    input wire [15:0] radius,
    output reg [15:0] pixel_colour
);
    wire [7:0] x;
    wire [7:0] y;
    
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    
    always @* begin
        if ((x >= 2 && y >=3 && x <= 91 && y <= 5) ||  // top border
            (x >= 2 && y >= 3 && x <= 4 && y <= 61) || // left border
            (x >= 2 && y >= 59 && x <= 91 && y <= 61) || // bottom border
            (x >= 89 && y >= 3 && x <= 91 && y <= 61)) // right border
        begin
            pixel_colour <= 16'b11111_000000_00000;
        end
        else if (((x - 46) ** 2 + (y - 31) ** 2) >= (radius ** 2) && 
                 ((x - 46) ** 2 + (y - 31) ** 2) <= ((radius + 5) ** 2))
        begin
            pixel_colour <= 16'b00000_111111_00000;
        end
        else
        begin
            pixel_colour <= 16'b00000_000000_00000;
        end
    end
    
endmodule
