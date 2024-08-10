module tb_traffic_light();

    // Testbench signals
    logic clk;
    logic reset;
    logic start;
    logic t_flicker;
    logic t_done;
    logic t_start;
    logic [4:0] t_length;
    logic [1:0] L_out;

    // Instantiate the traffic_light module
    traffic_light uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .t_flicker(t_flicker),
        .t_done(t_done),
        .t_start(t_start),
        .t_length(t_length),
        .L_out(L_out)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 10 ns clock period
    end

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        start = 0;
        t_flicker = 0;
        t_done = 0;

        // Apply reset
        reset = 1;
        #10;
        reset = 0;
        #10;

        // Test Case 1: Start the traffic light cycle
        start = 1;
        #10;
        start = 0;

    end

    // Monitor output signals
    initial begin
        $monitor("At time %0t: L_out = %b, t_start = %b, t_length = %d", $time, L_out, t_start, t_length);
    end

endmodule
