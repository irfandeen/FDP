`timescale 1ns / 1ps

module Basic_Task_B(
    input [12:0] pixelIndex,
    input upPushButton, centerPushButton, downPushButton, clock25Mhz,
    output [15:0] pixelData
);

//Initial Code Block -------------------------------------------------------------------------
reg [2:0] upButtonState = 0;
reg [2:0] centerButtonState = 0;
reg [2:0] downButtonState = 0;

// Debounce counter and period (200ms)
reg [23:0] debounceCounter = 0;
localparam DEBOUNCE_PERIOD = 24'd5000000; // 200ms at 25MHz

always @(posedge clock25Mhz) begin
    if (debounceCounter > 0) begin
        debounceCounter <= debounceCounter - 1;
    end else begin
        if (upPushButton) begin
            upButtonState <= (upButtonState == 5) ? 0 : upButtonState + 1;
            debounceCounter <= DEBOUNCE_PERIOD;
        end
        if (centerPushButton) begin
            centerButtonState <= (centerButtonState == 5) ? 0 : centerButtonState + 1;
            debounceCounter <= DEBOUNCE_PERIOD;
        end
        if (downPushButton) begin
            downButtonState <= (downButtonState == 5) ? 0 : downButtonState + 1;
            debounceCounter <= DEBOUNCE_PERIOD;
        end
    end
end

// Start of Part 2 of code -------------------------------------------------------------------

localparam WHITE = 16'b11111_111111_11111;
localparam RED = 16'b11111_000000_00000;
localparam GREEN = 16'b00000_111111_00000;
localparam BLUE = 16'b00000_000000_11111;
localparam ORANGE = 16'b11111_101001_00000;
localparam BLACK = 16'b00000_000000_00000;

wire [16:0] colourTopBox;
wire [16:0] colourMiddleBox;
wire [16:0] colourBottomBox;
wire [16:0] colourCircle;

assign colourTopBox =
    upButtonState == 0 ? WHITE :
    upButtonState == 1 ? RED :
    upButtonState == 2 ? GREEN :
    upButtonState == 3 ? BLUE :
    upButtonState == 4 ? ORANGE :
    upButtonState == 5 ? BLACK :
    BLACK;

assign colourMiddleBox =
    centerButtonState == 0 ? WHITE :
    centerButtonState == 1 ? RED :
    centerButtonState == 2 ? GREEN :
    centerButtonState == 3 ? BLUE :
    centerButtonState == 4 ? ORANGE :
    centerButtonState == 5 ? BLACK :
    BLACK;

assign colourBottomBox =
    downButtonState == 0 ? WHITE :
    downButtonState == 1 ? RED :
    downButtonState == 2 ? GREEN :
    downButtonState == 3 ? BLUE :
    downButtonState == 4 ? ORANGE :
    downButtonState == 5 ? BLACK :
    BLACK;

assign colourCircle =
    upButtonState == 1 && centerButtonState == 1 && downButtonState == 1? RED :
    upButtonState == 4 && centerButtonState == 4 && downButtonState == 4? ORANGE :
    BLACK;


// Start of Part 3 of code -------------------------------------------------------------------

wire [6:0] xCoordinate = pixelIndex % 96;
wire [6:0] yCoordinate = pixelIndex / 96;
reg [6:0] xCircleCenter = 47;
reg [6:0] yCircleCenter = 54;
reg [3:0] radius = 13;

assign pixelData = 
    xCoordinate >= 41 && xCoordinate <= 53 && yCoordinate >= 3 && yCoordinate <= 15 ? colourTopBox :
    xCoordinate >= 41 && xCoordinate <= 53 && yCoordinate >= 18 && yCoordinate <= 30 ? colourMiddleBox :
    xCoordinate >= 41 && xCoordinate <= 53 && yCoordinate >= 33 && yCoordinate <= 45 ? colourBottomBox :
    xCoordinate >= 41 && xCoordinate <= 53 && yCoordinate >= 48 && yCoordinate <= 60 &&
    (xCoordinate - xCircleCenter) * (xCoordinate - xCircleCenter) + (yCoordinate - yCircleCenter) * (yCoordinate - yCircleCenter) <= radius * radius ? colourCircle :
    16'b00000_000000_00000;

endmodule





