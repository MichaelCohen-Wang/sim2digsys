module timer_smart(
    input logic clk,
    input logic reset,
    input logic t_start,
    input logic[4:0] t_length,
    input logic t_freeze,

    output logic t_flicker,
    output logic t_done
);

// Internal signals
logic [4:0] count;       // Counter for elapsed ticks
logic running;           // Indicates if the timer is running
logic [4:0] total_time;  // Total length of time for the timer

// Sequential logic
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset Condition
        count <= 5'b1;        // Reset the count
        running <= 1'b0;      // Timer is not running
        t_flicker <= 1'b0;    // Reset flicker signal
        t_done <= 1'b0;       // Reset done signal
    end else if (t_start) begin
        // Start Condition
        t_done <= 1'b0;
        running <= 1'b1;        // Start the timer
        count <= 5'b1;          // Initialize count with offset of 1
        total_time = t_length;  // Store the timer length
        if (t_length <= 6) begin
            // If timer is short, flicker immediately
            t_flicker <= 1'b1;
        end else begin
            t_flicker <= 1'b0;
        end
    end else if (running && !t_freeze) begin
        // Timer Counting (only if not frozen)
        if (count < total_time) begin
            count <= count + 1'b1; // Increment the count
        end
        if (count + 6 >= total_time) begin
            t_flicker <= 1'b1; // Flicker in the last 5 ticks
        end else begin
            t_flicker <= 1'b0;
        end
        if (count + 1 >= total_time) begin
            t_done <= 1'b1;
        end else begin
            t_done <= 1'b0;
        end
    end
end

endmodule
