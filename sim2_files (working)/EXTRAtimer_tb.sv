module tb_timer;

// Testbench signals
logic clk;
logic reset;
logic t_start;
logic [4:0] t_length;
logic t_flicker;
logic t_done;

// Instantiate the timer module
timer uut (
    .clk(clk),
    .reset(reset),
    .t_start(t_start),
    .t_length(t_length),
    .t_flicker(t_flicker),
    .t_done(t_done)
);

// Clock generation
always begin
    #5 clk = ~clk; // 10ns clock period
end

// Testbench procedure
initial begin
    // Initialize signals
    clk = 0;
    reset = 0;
    t_start = 0;
    t_length = 5'b00000;

    // Apply reset
    $display("Applying reset");
    reset = 1;
    #10;
    reset = 0;
    #10;

    // Test case 1: Start timer with t_length = 10
    $display("Starting timer with t_length = 10");
    t_length = 5'b01010; // t_length = 10
    t_start = 1;
    #10;
    t_start = 0;

    // Wait for the timer to complete
    #100;
    
    // Check if the timer is done
    if (t_done !== 1'b1) begin
        $display("Test failed: Timer did not complete as expected");
        $finish;
    end

    // Test case 2: Start timer with t_length = 5
    $display("Starting timer with t_length = 5");
    t_length = 5'b00101; // t_length = 5
    t_start = 1;
    #10;
    t_start = 0;

    // Wait for the timer to complete
    #50;
    
    // Check if the timer is done
    if (t_done !== 1'b1) begin
        $display("Test failed: Timer did not complete as expected");
        $finish;
    end

    // Test case 3: Test flicker signal
    $display("Starting timer with t_length = 15 to test flicker signal");
    t_length = 5'b01111; // t_length = 15
    t_start = 1;
    #10;
    t_start = 0;

    // Wait and monitor flicker signal
    #20;
    if (t_flicker !== 1'b0) begin
        $display("Test failed: Flicker signal should be 0 at this point");
        $finish;
    end

    // Wait for the timer to approach the end
    #10;
    if (t_flicker !== 1'b1) begin
        $display("Test failed: Flicker signal should be 1 in the last 5 ticks");
        $finish;
    end

    // Wait for timer completion
    #15;
    if (t_flicker !== 1'b0) begin
        $display("Test failed: Flicker signal should be 0 after timer completion");
        $finish;
    end
    
    // Final report
    $display("All tests passed successfully");
    $finish;
end

endmodule
