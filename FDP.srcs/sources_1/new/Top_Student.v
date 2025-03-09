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
    input btnU, btnC, btnD,
    output [7:0] JB
);
    wire main_reset;
    wire clock_6_25Mhz;
    wire clock_25Mhz;
    wire [12:0] pixel_index;
    wire [16:0] oled_data_A;
    wire [16:0] oled_data_B;
    wire [16:0] oled_data;
    wire [15:0] radius;

    reg select_module = 1; // Register to select between oled_moduleA (0) and oled_moduleB (1)
    // Multiplexer to select between oled_moduleA and oled_moduleB
    assign oled_data = select_module ? oled_data_B : oled_data_A;
    
    assign main_reset = 0;
    assign radius = 16'd20;
    
    // Generate 6.25 MHz clock
    flexible_clock #( .CLK_DIV(8) ) clk_gen_6_25Mhz (
        .clk_in(clk),
        .clk_out(clock_6_25Mhz)
    );

    // Generate 25 Mhz clock
    flexible_clock #( .CLK_DIV(2) ) clk_gen_25Mhz (
        .clk_in(clk),
        .clk_out(clock_25Mhz)
    );
    
    Basic_Task_A oled_moduleA(
        .pixel_index(pixel_index),
        .radius(radius),
        .pixel_colour(oled_data_A)
    );
    Basic_Task_B oled_moduleB(
        .pixelIndex(pixel_index),
        .upPushButton(btnU),
        .centerPushButton(btnC),
        .downPushButton(btnD),
        .clock25Mhz(clock_25Mhz),
        .pixelData(oled_data_B)
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