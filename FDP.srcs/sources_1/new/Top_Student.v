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
    input btnR, btnL, btnU, btnD, btnC,
    output [7:0] JB
);
    wire main_reset;
    wire clock_6_25Mhz;
    wire [12:0] pixel_index;
    wire [16:0] oled_data_A;
    wire [16:0] oled_data_B;
    wire [16:0] oled_data_C;
    wire [16:0] oled_data_D;
    wire [16:0] oled_data_teamID;
    wire [16:0] oled_data;
    wire [15:0] radius;

    reg select_module = 0; // Register to select between oled_moduleA (0) and oled_moduleB (1)
    // Multiplexer to select between oled_moduleA and oled_moduleB
    assign oled_data = select_module ? oled_data_B : oled_data_teamID;
    
    assign main_reset = 0;
    assign radius = 16'd20;
    
    // Generate 6.25 MHz clock for oled_driver
    flexible_clock #( .CLK_DIV(8) ) clk_gen_6_25Mhz (
        .clk_in(clk),
        .clk_out(clock_6_25Mhz)
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
        .clk(clk),
        .pixelData(oled_data_B)
    );
    
    Basic_Task_D oled_moduleD(
        .pixelIndex(pixel_index),
        .rightPushButton(btnR),
        .leftPushButton(btnL),
        .upPushButton(btnU),
        .downPushButton(btnD),
        .clk(clk),
        .pixelData(oled_data_D)
    );
    
    Team_09_Oled team_oled_module(
        .pixelIndex(pixel_index),
        .clk(clock_6_25Mhz),
        .pixelData(oled_data_teamID)
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