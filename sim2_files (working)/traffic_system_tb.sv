//traffic system testbench

module traffic_system_tb;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Light start signal

// Put your code here
// ------------------

logic [1:0] L_out; 


traffic_system traffic_sys(
		.clk(clk),
		.reset(reset),
		.start(start),
		.L_out(L_out)
)

//keeps alternating between 1 and 0 
always begin 
    #5
    clk = ~clk; 
end

//make test bench with intial 
//for reference, one clock cycle is 10 units of time
intial begin
    clk = 1'b0;  //init clock at 0
    reset = 1'b1; //init reset at 1
    start = 1'b0; //init start at 0
    
    #50 // Wait 5 clock cycles then lower reset to 0
    
    reset = 1'b0;
    
    #5 // Wait 5 time units
    
    start = 1'b1;
    
    #10 //one clock cycle then bring start back up 
    
    start = 1'b0;

end
// End of your code
endmodule
