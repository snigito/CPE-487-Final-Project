module bat_n_ball (
    input  logic        v_sync,
    input  logic [10:0] pixel_row,
    input  logic [10:0] pixel_col,

    output logic        red,
    output logic        green,
    output logic        blue,

    output logic [7:0]  hits        // successful hits since the last serve
);

    localparam int ARROW_W = 40;  // starting bat half-width, doubled from 20
    localparam int ARROW_H = 40;   // bat height in pixels

    localparam logic [10:0] BALL_SPEED = 11'd6; // distance ball moves each frame

    logic ARROW1_on;               // indicates whether bat at over current pixel position
    logic ARROW2_on;
    logic ARROW3_on;
    logic ARROW4_on;

    logic game_on = 1'b0;       // indicates whether ball is in play



    // bat vertical position
    localparam logic [10:0] ARROW_Y = 11'd100;
    localparam logic [10:0] ARROW1_X = 11'd100;
    localparam logic [10:0] ARROW2_X = 11'd300;
    localparam logic [10:0] ARROW3_X = 11'd700;
    localparam logic [10:0] ARROW4_X = 11'd900;
    


    logic [7:0]  hit_count = '0;     // hit counter

    assign hits = hit_count;         // send hit count up to pong.sv

    //------------------------------------------------------------------
    // color setup for red ball and cyan bat on white background
    //------------------------------------------------------------------
    assign red   = ~(ARROW1_on || ARROW1_on ||ARROW1_on || ARROW1_on);
    assign green = 1;
    assign blue  = 1;



    //------------------------------------------------------------------
    // process to draw bat
    // set bat_on if current pixel address is covered by bat position
    // uses bat_w (current width) in place of the fixed BAT_W
    //------------------------------------------------------------------
    always_comb begin : arrowdraw

        if ((((pixel_col >= (ARROW1_X - ARROW_W)) || (ARROW1_X <= ARROW_W)) &&
              (pixel_col <= (ARROW1_X + ARROW_W)) &&
              (pixel_row >= (ARROW_Y - ARROW_H)) &&
              (pixel_row <= (ARROW_Y + ARROW_H))))
        begin
            ARROW1_on = 1'b1;
        end
        else begin
            ARROW1_on = 1'b0;
        end
    

        if ((((pixel_col >= (ARROW2_X - ARROW_W)) || (ARROW1_X <= ARROW_W)) &&
              (pixel_col <= (ARROW2_X + ARROW_W)) &&
              (pixel_row >= (ARROW_Y - ARROW_H)) &&
              (pixel_row <= (ARROW_Y + ARROW_H))))
        begin
            ARROW2_on = 1'b1;
        end
        else begin
            ARROW2_on = 1'b0;
        end
        

        if ((((pixel_col >= (ARROW3_X - ARROW_W)) || (ARROW3_X <= ARROW_W)) &&
              (pixel_col <= (ARROW3_x + ARROW_W)) &&
              (pixel_row >= (ARROW_Y - ARROW_H)) &&
              (pixel_row <= (ARROW_Y + ARROW_H))))
        begin
            ARROW3_on = 1'b1;
        end
        else begin
            ARROW3_on = 1'b0;
        end
        

        if ((((pixel_col >= (ARROW4_X - ARROW_W)) || (ARROW4_X <= ARROW_W)) &&
              (pixel_col <= (ARROW4_x + ARROW_W)) &&
              (pixel_row >= (ARROW_Y - ARROW_H)) &&
              (pixel_row <= (ARROW_Y + ARROW_H))))
        begin
            ARROW4_on = 1'b1;
        end
        else begin
            ARROW4_on = 1'b0;
        end

    //------------------------------------------------------------------
    // process to move ball once every frame
    // (i.e., once every vsync pulse)
    //------------------------------------------------------------------

 /*       // !ball_y_motion[10] means the ball is moving down, so each hit counts once
        if (((ball_x + BSIZE/2 + bat_w) >= bat_x) &&
            (ball_x <= (bat_x + bat_w + BSIZE/2)) &&
            ((ball_y + BSIZE/2) >= (BAT_Y - BAT_H)) &&
            ((ball_y - BSIZE/2) <= (BAT_Y + BAT_H)) &&
            !ball_y_motion[10])
        begin
            ball_y_motion <= (~BALL_SPEED) + 11'd1; // set vspeed to (- ball_speed) pixels
            hit_count     <= hit_count + 8'd1;      // count one successful hit
            if (bat_w > 1) bat_w <= bat_w - 11'd1;  // shrink bat by 1 pixel per side
        end
*/

endmodule
