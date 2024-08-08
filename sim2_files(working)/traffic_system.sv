// 32X32 Multiplier test template
module traffic_system(
    input logic clk,
    input logic reset,
    input logic start,
    output logic [1:0] L_out
);

// Enter X and Y here
	localparam X = 0;
	localparam Y = 3;

// Put your code here
// ------------------

//extra logic
	logic t_start;
	logic [4:0] t_length;
	logic t_flicker;
	logic t_done;


timer timer_inst (
    .clk(clk),
    .reset(reset),         // Connect reset to the timer
    .t_start(t_start),
    .t_length(t_length),
    .t_flicker(t_flicker), // Connect flicker directly to the timer
    .t_done(t_done)        // Connect done directly to the timer
);

//traffic light
    traffic_light #(
        .RED_DURATION(20+X),
        .YELLOW_DURATION(3),
        .GREEN_DURATION(20+Y)
    ) traffic_light_sys(
        .clk(clk),
        .reset(reset),
        .start(start),
        .t_flicker(t_flicker),
        .t_done(t_done),
        .t_start(t_start),
        .t_length(t_length),
        .L_out(L_out)
    );

// end of your code
endmodule
