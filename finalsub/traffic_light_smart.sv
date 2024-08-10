module traffic_light_smart(
    //inputs
    input logic clk, // Clock
    input logic reset, // Reset
    input logic start, // Start signal
    input logic t_flicker,
    input logic t_done,
    input logic car_present,
    input logic person_present,

    //outputs
    output logic t_start,
    output logic[4:0] t_length,
    output logic t_freeze,
    output logic[1:0] L_out
);

// Light Duration Parameters - Defaults
parameter RED_DURATION = 5'd20;   // Duration for RED light
parameter YELLOW_DURATION = 5'd3;  // Duration for YELLOW light
parameter GREEN_DURATION = 5'd18;   // Duration for GREEN light

// State Encoding (Gray Code)
typedef enum logic [2:0] {
    OFF_STATE      = 3'b000, // State: OFF
    RED_STATE      = 3'b001, // State: RED for cars
    YELLOW_STATE   = 3'b011, // State: YELLOW for cars
    GREEN_STATE    = 3'b010, // State: GREEN for cars
    FLICKER_STATE  = 3'b100, // State: FLICKER for pedestrians
    DONE_STATE     = 3'b111  // State: DONE (before going back to RED)
} state_t;

state_t current_state, next_state;

// Timer signals
logic [4:0] timer_length;  // Timer length

// Instantiate Smart Timer Module

// State Machine Sequential Logic
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= OFF_STATE; // Reset to OFF state
    end else begin
        current_state <= next_state; // Update to the next state
    end
end

// FSM Next State Logic
always_comb begin
    // Defaults
    next_state = current_state;
    t_start = 1'b0;        // Default to not start the timer
    t_length = 5'd0;       // Default duration
    t_freeze = 1'b0;       // Default to not freeze the timer
    L_out = 2'b00;         // Default light output

    // Determine actions based on car_present and person_present sensors
    case (current_state)
        OFF_STATE: begin
	    L_out = 2'b00;
            if (start) begin
                t_start = 1'b1;                
                t_length = RED_DURATION;       
                //L_out = 2'b01; // Set light to RED
                next_state = RED_STATE; 
            end
        end
        
        RED_STATE: begin
            L_out = 2'b01; // Cars RED light ON
            if (car_present && !person_present) begin
                t_start = 1'b1;
                t_length = YELLOW_DURATION;
                L_out = 2'b01; // Set light to RED
                next_state = YELLOW_STATE;
            end else if (person_present && !car_present) begin
                t_freeze = 1'b1;
            end else if (t_done) begin
                t_start = 1'b1;
                t_length = YELLOW_DURATION;
                L_out = 2'b01; // Set light to RED
                next_state = YELLOW_STATE; 
            end
        end
        
        YELLOW_STATE: begin
            L_out = 2'b10; // Cars YELLOW light ON
            if (t_done) begin
                t_start = 1'b1;
                t_length = GREEN_DURATION;
                L_out = 2'b10; // Set light to YELLOW
                next_state = GREEN_STATE; 
            end
        end
        
        GREEN_STATE: begin
            L_out = 2'b11; // Cars GREEN light ON
            if (t_flicker) begin
                //L_out = 2'b11; // Cars OFF during flicker
                next_state = FLICKER_STATE;
            end else if (person_present && !car_present) begin
                t_start = 1'b1;
                t_length = RED_DURATION;
                //L_out = 2'b01; // Set light to RED
                next_state = DONE_STATE;
            end else if (car_present && !person_present) begin
                t_freeze = 1'b1;
            end else if (t_done) begin
                t_start = 1'b1;
                t_length = YELLOW_DURATION;
                //L_out = 2'b10; // Set light to YELLOW
                next_state = DONE_STATE; 
            end
        end

        FLICKER_STATE: begin
            L_out = 2'b00; // Cars OFF during flicker

            if (t_done) begin
                t_start = 1'b1;
                t_length = YELLOW_DURATION;
                //L_out = 2'b01; // Set light to RED
                next_state = DONE_STATE; 
            end else if (t_flicker) begin
                //L_out = 2'b11; // Cars GREEN light ON
                next_state = GREEN_STATE;
            end
        end


        DONE_STATE: begin
            L_out = 2'b10; // Set light to YELLOW
            if (t_done) begin
                t_start = 1'b1;
                t_length = RED_DURATION;
                next_state = RED_STATE;
            end
        end

        default: begin
            next_state = OFF_STATE;
            L_out = 2'b00;
        end
    endcase
end

endmodule
