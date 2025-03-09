`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clk,
    output [7:0] JB
);
    wire main_reset;
    wire clock_6_25Mhz;
    wire [12:0] pixel_index;
    wire [16:0] oled_data;
    wire [15:0] radius;
    
    assign main_reset = 0;
    assign radius = 16'd20;
    
    // Generate 6.25 MHz clock
    flexible_clock #( .CLK_DIV(8) ) clk_gen (
        .clk_in(clk),
        .clk_out(clock_6_25Mhz)
    );
    
    Basic_Task_A oled_module(
        .pixel_index(pixel_index),
        .radius(radius),
        .pixel_colour(oled_data)
    );
    
    Oled_Display oled_driver(
        .clk(clock_6_25Mhz), 
        .reset(main_reset), 
        .frame_begin(), 
        .sending_pixels(),
        .sample_pixel(), 
        .pixel_index(pixel_index), 
        .pixel_data(oled_data), 
        .cs(JB[0]), 
        .sdin(JB[1]), 
        .sclk(JB[3]), 
        .d_cn(JB[4]), 
        .resn(JB[5]), 
        .vccen(JB[6]),
        .pmoden(JB[7])
    );
    
endmodule