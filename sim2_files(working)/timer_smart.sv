// Smart timer module

module timer_smart(
    input logic clk,
    input logic reset,
    input logic t_start,
    input logic[4:0] t_length,
    input logic t_freeze,

    output logic t_flicker,
    output logic t_done
);

// Put your code here
// ------------------
// Internal registers
logic [4:0] count; // Counter for elapsed ticks
logic running; // Indicates if the timer is running

// Combinational logic for flicker and done signals
always_comb begin
    // Default values to avoid latches
    t_flicker = 1'b0; // Default flicker signal
    t_done = 1'b0;    // Default done signal

    // Done signal logic: assert if the count has reached t_length
    if (running && count >= t_length) begin
        t_done = 1'b1;
    end

    // Flicker signal logic: assert for the last 5 ticks before done
    if (running && (count >= t_length - 5) && (count <= t_length)) begin
        t_flicker = 1'b1;
    end
end

// Sequential logic (always_ff) for timer management
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset Condition
        count <= 5'b1;   // Reset the count
        running <= 1'b0; // Timer is not running
    end 
    if (t_start) begin
        // Start Condition
        running <= 1'b1; // Start the timer
        count <= 5'b1;   // Initialize count offset by 1
    end 
    if (running) begin
        // Timer Counting and Freezing
        if (!t_freeze) begin
            // Only increment the count if t_freeze is not active
            if (count < t_length) begin
                count <= count + 1'b1; // Increment the counter
            end
            // Once count reaches t_length, stop the timer
        end
    end
end
//end of your code
endmodule