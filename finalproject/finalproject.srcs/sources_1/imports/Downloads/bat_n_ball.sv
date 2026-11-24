module bat_n_ball (
    input  logic        v_sync,
    input  logic [10:0] pixel_row,
    input  logic [10:0] pixel_col,

    output logic        red,
    output logic        green,
    output logic        blue,

    output logic [7:0]  hits        // successful hits since the last serve
);

    localparam int BSIZE = 8;   // ball size in pixels
    localparam int BAT_W = 40;  // starting bat half-width, doubled from 20
    localparam int BAT_H = 40;   // bat height in pixels

    logic bat1_on;               // indicates whether bat at over current pixel position
    logic bat2_on;
    logic bat3_on;
    logic bat4_on;

    logic game_on = 1'b0;       // indicates whether ball is in play

    // current ball position - initialized to center of screen
    
    //Bat1 position
    logic [10:0] bat1_x = 11'd150;
    
    //Bat2 position
    logic [10:0] bat2_x = 11'd300;
    
    //Bat3 position
    logic [10:0] bat3_x = 11'd450;
    
    //Bat4 position
    logic [10:0] bat4_x = 11'd600;
    
    //Bat y position
    localparam logic [10:0] BAT_Y = 11'd100;

    logic [10:0] bat_w     = BAT_W;  // current bat half-width, shrinks after each hit
    logic [7:0]  hit_count = '0;     // hit counter

    assign hits = hit_count;         // send hit count up to pong.sv

    //------------------------------------------------------------------
    // color setup for red ball and cyan bat on white background
    //------------------------------------------------------------------
    assign red   = ~(bat1_on || bat2_on || bat3_on || bat4_on);
    assign green = 1;
    assign blue  = 1;

    //------------------------------------------------------------------
    // process to draw bat
    // set bat_on if current pixel address is covered by bat position
    // uses bat_w (current width) in place of the fixed BAT_W
    //------------------------------------------------------------------
    always_comb begin : batdraw
    
        if ((((pixel_col >= (bat1_x - bat_w)) || (bat1_x <= bat_w)) &&
              (pixel_col <= (bat1_x + bat_w)) &&
              (pixel_row >= (BAT_Y - BAT_H)) &&
              (pixel_row <= (BAT_Y + BAT_H))))
        begin
            bat1_on = 1'b1;
        end
        else begin
            bat1_on = 1'b0;
        end
        
        if ((((pixel_col >= (bat2_x - bat_w)) || (bat2_x <= bat_w)) &&
              (pixel_col <= (bat2_x + bat_w)) &&
              (pixel_row >= (BAT_Y - BAT_H)) &&
              (pixel_row <= (BAT_Y + BAT_H))))
        begin
            bat2_on = 1'b1;
        end
        else begin
            bat2_on = 1'b0;
        end
        
        if ((((pixel_col >= (bat3_x - bat_w)) || (bat3_x <= bat_w)) &&
              (pixel_col <= (bat3_x + bat_w)) &&
              (pixel_row >= (BAT_Y - BAT_H)) &&
              (pixel_row <= (BAT_Y + BAT_H))))
        begin
            bat3_on = 1'b1;
        end
        else begin
            bat3_on = 1'b0;
        end
        
        if ((((pixel_col >= (bat4_x - bat_w)) || (bat4_x <= bat_w)) &&
              (pixel_col <= (bat4_x + bat_w)) &&
              (pixel_row >= (BAT_Y - BAT_H)) &&
              (pixel_row <= (BAT_Y + BAT_H))))
        begin
            bat4_on = 1'b1;
        end
        else begin
            bat4_on = 1'b0;
        end
        
    end
    
    //uncomment when we are ready to add collision mechanics
    //always_ff @(posedge v_sync)
    
        // allow for bounce off bat
        // x checks rearranged so no subtraction underflows near the left edge
        // !ball_y_motion[10] means the ball is moving down, so each hit counts once
        /*
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
    //end

endmodule
