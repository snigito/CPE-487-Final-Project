module pong (
    input  logic        clk_in,       // system clock

    output logic [3:0]  VGA_red,      // VGA outputs
    output logic [3:0]  VGA_green,
    output logic [3:0]  VGA_blue,
    output logic        VGA_hsync,
    output logic        VGA_vsync,

    input  logic        btnl,
    input  logic        btnr,
    input  logic        btn0,

    output logic [7:0]  SEG7_anode,   // anodes of eight 7-seg displays
    output logic [6:0]  SEG7_seg
);

    logic pxl_clk;             // 25 MHz clock to VGA sync module

    // internal signals to connect modules
    logic S_red, S_green, S_blue;
    logic S_vsync;

    logic [10:0] S_pixel_row;
    logic [10:0] S_pixel_col;

    logic [10:0] batpos = '0;

    logic [20:0] count;

    logic [7:0]  S_hits;              // hit count from bat_n_ball

    logic [31:0] display;             // widened to 32 bits for 8 digits

    logic [2:0] led_mpx;              // 7-seg multiplexing clock

    //------------------------------------------------------------------
    // Bat position control
    //------------------------------------------------------------------
    always_ff @(posedge clk_in) begin : pos

        count <= count + 21'd1;

        if (btnl && (count == 21'd0) && (batpos > 0)) begin
            batpos <= batpos - 11'd10;
        end
        else if (btnr && (count == 21'd0) && (batpos < 11'd800)) begin
            batpos <= batpos + 11'd10;
        end
    end

    assign led_mpx = count[19:17]; // 7-seg multiplexing clock

    //------------------------------------------------------------------
    // show hit count in binary, one bit per 7-segment digit
    // Each digit gets 4 bits: three 0s plus one bit of S_hits,
    // so every digit shows 0 or 1. Rightmost digit = bit 0.
    //------------------------------------------------------------------
    assign display = {3'b000, S_hits[7], 3'b000, S_hits[6],
                      3'b000, S_hits[5], 3'b000, S_hits[4],
                      3'b000, S_hits[3], 3'b000, S_hits[2],
                      3'b000, S_hits[1], 3'b000, S_hits[0]};

    //------------------------------------------------------------------
    // instantiate bat and ball component
    //------------------------------------------------------------------
    bat_n_ball add_bb (
        .v_sync   (S_vsync),
        .pixel_row(S_pixel_row),
        .pixel_col(S_pixel_col),
        .bat_x    (batpos),
        .serve    (btn0),
        .red      (S_red),
        .green    (S_green),
        .blue     (S_blue),
        .hits     (S_hits)        // hit count out
    );

    //------------------------------------------------------------------
    // instantiate vga_sync component
    //------------------------------------------------------------------
    vga_sync vga_driver (
        .pixel_clk(pxl_clk),

        .red_in   ({S_red,   3'b000}),
        .green_in ({S_green, 3'b000}),
        .blue_in  ({S_blue,  3'b000}),

        .red_out  (VGA_red),
        .green_out(VGA_green),
        .blue_out (VGA_blue),

        .pixel_row(S_pixel_row),
        .pixel_col(S_pixel_col),

        .hsync    (VGA_hsync),
        .vsync    (S_vsync)
    );

    // connect output vsync
    assign VGA_vsync = S_vsync;

    //------------------------------------------------------------------
    // Clock wizard
    //------------------------------------------------------------------
    clk_wiz_0 clk_wiz_inst_0 (
        .clk_in1 (clk_in),
        .clk_out1(pxl_clk)
    );

    //------------------------------------------------------------------
    // 7-segment display driver
    //------------------------------------------------------------------
    leddec16 led1 (
        .dig   (led_mpx),
        .data  (display),
        .anode (SEG7_anode),
        .seg   (SEG7_seg)
    );

endmodule
