`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2025 09:27:49
// Design Name: 
// Module Name: testbench_clock_divider
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


module testbench_clock_divider;
    reg clk = 0;
    wire clock_6_25Mhz;
    
    // Instantiate the top module
    Top_Student uut (
        .clk(clk),
        .clock_6_25Mhz(clock_6_25Mhz)
    );
    
    // Generate a 100 MHz clock (10 ns period)
    always #5 begin
        clk = ~clk; // Toggle clock every 5 ns (100 MHz)
    end
endmodule
