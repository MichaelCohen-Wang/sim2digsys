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
logic [4:0] total_time;//length of time the timer measures 

// Sequential logic
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset Condition
        count <= 5'b1;   // Reset the count
        running <= 1'b0; // Timer is not running
        t_flicker = 1'b0;
        t_done = 1'b0;    
    end else if (t_start) begin
            // Start Condition
                t_done <= 1'b0;
                running <= 1'b1; // Start the timer
                count <= 5'b1;   // Initialize count with offset of 1
                total_time=t_length;// transfer length into timer
                if (t_length<=6) begin
                    //in case timer is short and flicker needs to instantly turn on
                    t_flicker <= 1'b1;
                end
                else begin
                    //regular long timer(not yellow)
                    t_flicker = 1'b0;
                end

    end else if (running) begin
        // Timer Counting
        if (count < t_length) begin
            count <= count + 1'b1; // Increment the count            
        end
        //the 1 more time unit than expected from here on is because count isnt updated yet
        if (count+6 >= total_time) begin
            t_flicker = 1'b1; // Flicker in the last 5 ticks
        end
        else begin
            t_flicker <= 1'b0;
        end
        if (count+1 >= total_time) begin
        t_done = 1'b1;
        end
        else begin
            t_done <= 1'b0;
        end
    end
end

// Combinational logic
//always_comb begin
    //// Default values to avoid latches
  //  t_flicker = 1'b0; // Default flicker signal
    //t_done = 1'b0;    // Default done signal
    //// Flicker signal logic: assert for the last 5 ticks before done
    //if (running && ((t_length-count) <= 5)) begin
    //    t_flicker = 1'b1; // Flicker in the last 5 ticks
    //end //else begin
      //  //t_flicker = 1'b0; // Reset flicker signal otherwise
    ////end

    //if (running && count >= t_length && t_length>0) begin
      //  t_done = 1'b1;
    //end
//end

endmodule