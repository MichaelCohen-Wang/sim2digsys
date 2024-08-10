// Smart traffic system testbench
module traffic_system_smart(
    input logic clk,
    input logic reset,
    input logic start,
    input logic person_present,
    input logic car_present,
    output logic [1:0] L_out
);

// Enter X and Y here
	localparam X = 0;
	localparam Y = 3;

// Put your code here
// ------------------

//local logic 

	logic t_start;
	logic [4:0] t_length;
	logic t_flicker;
	logic t_done;
	logic t_freeze;

//smart timer unit
	timer_smart smart_timer(
		.clk(clk),
		.reset(reset),
		.t_start(t_start),
		.t_length(t_length),
		.t_freeze(t_freeze),
		.t_flicker(t_flicker),
		.t_done(t_done)
	);

//smart traffic light unit
    traffic_light_smart #(
        .RED_DURATION(20+X),
        .YELLOW_DURATION(3),
        .GREEN_DURATION(20+Y)
    ) smart_light(
        .clk(clk),
        .reset(reset),
        .start(start),
        .t_flicker(t_flicker),
        .t_done(t_done),
        .car_present(car_present),
        .person_present(person_present),
        .t_start(t_start),
        .t_length(t_length),
        .t_freeze(t_freeze),
        .L_out(L_out)
    );
// End of your code
endmodule
