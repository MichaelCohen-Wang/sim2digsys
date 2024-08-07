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

//timer
	timer timer_sys(
		.clk(clk),
		.reset(reset),
		.t_start(t_start),
		.t_length(t_length),
		.t_freeze(t_freeze),
		.t_flicker(t_flicker),
		.t_done(t_done)
	);

//traffic light
    traffic_light #(
        .RED_DURATION(20+x),
        .YELLOW_DURATION(5'b3),
        .GREEN_DURATION(20+y)
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
