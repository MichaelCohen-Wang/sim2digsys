// Smart traffic system testbench
module traffic_system_smart_tb;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Light start signal
	logic person_present;	  // Is there a person trying to enter
	logic car_present;		  // Is there a car trying to enter

// Put your code here
// ------------------
    traffic_system_smart smart_traffic_sys(
        .clk(clk),
		.reset(reset),
		.start(start),
		.person_present(person_present),
		.car_present(car_present),
		.L_out(L_out)
    );

    always begin 
        #5
        clk = ~clk;
    end
    //one clock cycle is 5*2 = 10 seconds 

    repeat begin
		clk = 1'b0;
		reset = 1'b1;
		start = 1'b0;
		person_present = 1'b0;
		car_present = 1'b0;

        #50 //5 clock cycles 

        reset = 1'b0; //close restart

        start = 1'b1; // start start

        #10 //wait 10 units (2 clock cycles)

        start = 1'b0;

		person_present = 1'b1;

		car_present = 1'b0;

        #5 //
		
		person_present = 1'b0;

		car_present = 1'b1;
		
		#10 // Wait 10 cycles to reach green light (only car present so should have skipped to green )
		
		car_present = 1'b0;  //no person or car present so should continue as usual

    end
// End of your code
endmodule
