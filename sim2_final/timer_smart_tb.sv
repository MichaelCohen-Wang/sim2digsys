module timer_smart_tb;

    // Inputs
    logic clk; // Clock
    logic reset; // Reset
    logic t_start; // Timer start signal
    logic [4:0] t_length; // Timer length
    logic t_freeze; // Timer freeze signal

    // Outputs
    logic t_flicker; // Timer flicker signal
    logic t_done; // Timer done signal

    // Instantiate the timer_smart module
    timer_smart timer (
        .clk(clk),
        .reset(reset),
        .t_start(t_start),
        .t_length(t_length),
        .t_freeze(t_freeze),
        .t_flicker(t_flicker),
        .t_done(t_done)
    );

    // Clock generation: alternating between 1 and 0 every 5 units of time
    always begin
        #5 clk = ~clk;
    end

    // Testbench stimulus
    initial begin
        // Initial conditions
        clk = 1'b0; // Initialize clock to 0
        reset = 1'b1; // Initialize reset to 1
        t_start = 1'b0; // Initialize start to 0
        t_length = 5'd10; // Initialize timer length to 10
        t_freeze = 1'b0; // Initialize freeze to 0
        
        #50 // Wait 5 clock cycles, then lower reset to 0
        reset = 1'b0;
        
        #5 // Wait 5 time units
        t_start = 1'b1;
        
        #10 // Wait one clock cycle, then bring start back down
        t_start = 1'b0;

        // Wait for timer to reach half the length, then freeze
        #50
        t_freeze = 1'b1;

        // Wait for a few clock cycles, then unfreeze
        #30
        t_freeze = 1'b0;

        // Wait for timer to complete
        #100

        // Reset the timer
        reset = 1'b1;
        #20
        reset = 1'b0;
        
        // Start the timer again with a different length
        t_length = 5'd20;
        t_start = 1'b1;
        #10
        t_start = 1'b0;

        // Wait for timer to complete
        #200

        // End simulation
        $stop;
    end

endmodule
