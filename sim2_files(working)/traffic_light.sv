module traffic_light(
    // Inputs
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    input logic t_flicker,        // Flicker signal from timer (flickering green light)
    input logic t_done,           // Done signal from timer

    // Outputs
    output logic t_start,         // Signal to start the timer
    output logic [4:0] t_length,  // Length of time for current state
    output logic [1:0] L_out      // Traffic light outputs (00: OFF, 01: RED, 10: YELLOW, 11: GREEN)
);

// Light Duration Parameters - Defaults
parameter RED_DURATION = 5'd30;
parameter YELLOW_DURATION = 5'd3;
parameter GREEN_DURATION = 5'd30;

// State Encoding (Gray Code)
typedef enum{
    OFF_STATE,
    RED_STATE,
    YELLOW_STATE,
    GREEN_STATE,
    FLICKER_STATE,
    DONE_STATE
} state_t;

state_t current_state;
state_t next_state;

// Timer signals
logic [4:0] timer_length; // Timer length

// Instantiate Timer Module
//timer timer_inst (
   // .clk(clk),
    //.reset(reset),         // Connect reset to the timer
    //.t_start(t_start),
    //.t_length(timer_length),
    //.t_flicker(t_flicker), // Connect flicker directly to the timer
    //.t_done(t_done)        // Connect done directly to the timer
//);

// State Machine Sequential Logic
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= OFF_STATE; // Reset to OFF state
    end 
    else begin
        current_state <= next_state; // Update to the next state
    end
end

// FSM Next State Logic
always_comb begin
    // Defaults
    next_state = current_state;
    t_start = 1'b0;
    t_length = 5'd0; // Default duration to avoid latch
    L_out = 2'b00;   // Default light state to avoid latch

    case (current_state)
        OFF_STATE: begin
            if (start) begin
                L_out = 2'b01;        // RED light ON
                t_start = 1'b1;       // Start timer
                t_length = RED_DURATION; // Set timer length for RED
                next_state = RED_STATE;
            end
        end
        
        RED_STATE: begin
            if (t_done == 1'b1) begin
                L_out = 2'b10;        // YELLOW light ON
                t_start = 1'b1;       // Start timer
                t_length = YELLOW_DURATION; // Set timer length for YELLOW
                next_state = YELLOW_STATE;
            end else begin
                L_out = 2'b01;        // RED light ON
		t_length = RED_DURATION;
            end
        end
        
        YELLOW_STATE: begin
            if (t_done == 1'b1) begin
                L_out = 2'b11;        // GREEN light ON
                t_start = 1'b1;       // Start timer
                t_length = GREEN_DURATION; // Set timer length for GREEN
                next_state = GREEN_STATE;
            end else begin
                L_out = 2'b10;        // YELLOW light ON
		t_length = YELLOW_DURATION;
            end
        end
        
        GREEN_STATE: begin
            if (t_flicker) begin
                L_out = 2'b00;        // Light OFF
                next_state = FLICKER_STATE;
            end else begin
                L_out = 2'b11;        // GREEN light ON
                t_start = 1'b0;       // Ensure timer is not restarted
		t_length = GREEN_DURATION;
            end
        end

        FLICKER_STATE: begin
            if (!t_done) begin
                L_out = 2'b11;        // GREEN light ON
                next_state = GREEN_STATE;
		t_length = GREEN_DURATION;
            end else begin
                L_out = 2'b10;        // YELLOW light ON
                t_start = 1'b1;       // Start timer
                t_length = YELLOW_DURATION; // Set timer length for YELLOW
                next_state = DONE_STATE;
            end
        end

        DONE_STATE: begin
            if (t_done) begin
                L_out = 2'b01;        // RED light ON
                t_start = 1'b1;       // Start timer
                t_length = RED_DURATION; // Set timer length for RED
                next_state = RED_STATE;
            end else begin
		t_length = YELLOW_DURATION;
                L_out = 2'b10;        // YELLOW light ON
                t_start = 1'b0;       // Ensure timer is not restarted
            end
        end

        default: begin
            next_state = OFF_STATE; // Default state
            L_out = 2'b00; // Ensure lights are OFF by default
        end
    endcase
end

endmodule