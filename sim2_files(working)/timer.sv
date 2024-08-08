module timer(
    input logic clk,
    input logic reset,
    input logic t_start,
    input logic[4:0] t_length,

    output logic t_flicker,
    output logic t_done
);

// Internal signals
logic [4:0] count; // Counter for elapsed ticks
logic running; // Indicates if the timer is running

// Sequential logic
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset Condition
        count <= 5'b1;   // Reset the count
        running <= 1'b0; // Timer is not running
    end else if (t_start) begin
        // Start Condition
        running <= 1'b1; // Start the timer
        count <= 5'b1;   // Initialize count with offset of 1
    end else if (running) begin
        // Timer Counting
        if (count < t_length) begin
            count <= count + 1'b1; // Increment the count
        end
    end
end

// Combinational logic
always_comb begin
    // Default values to avoid latches
    t_flicker = 1'b0; // Default flicker signal
    t_done = 1'b0;    // Default done signal
    // Flicker signal logic: assert for the last 5 ticks before done
    if (running && count >= t_length - 5) begin
        t_flicker = 1'b1; // Flicker in the last 5 ticks
    end else begin
        t_flicker = 1'b0; // Reset flicker signal otherwise
    end

    if (running && count >= t_length && t_length>0) begin
        t_done = 1'b1;
    end
end

endmodule