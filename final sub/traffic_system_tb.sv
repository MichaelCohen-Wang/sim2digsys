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
);



//make test bench with intial 
//for reference, one clock cycle is 10 units of time
initial begin
    clk = 1'b0;  //init clock at 0
    reset = 1'b1; //init reset at 1
    start = 1'b0; //init start at 0
    
    #5 // Wait 5 time units
    
    start = 1'b1;
    #5 // Wait 5 clock cycles (of length 2) then lower reset to 0
    //(including 5 time units wait from previously)
    
    reset = 1'b0;
    
    #5 //wait 10 time units total(5 and 5 from the previous wait) to lower back start 
    
    start = 1'b0;

end

//keeps alternating between 1 and 0 
always begin 
    #1
    clk = ~clk; 
end
// End of your code
endmodule
