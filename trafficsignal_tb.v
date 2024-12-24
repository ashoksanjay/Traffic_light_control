module trafficsignal_tb;

    reg clk, reset, X;
    wire [1:0] hwy, cny;

    // Instantiate the traffic light controller
    trafficsignal uut (
        .hwy(hwy),
        .cny(cny),
        .X(X),
        .clk(clk),
        .reset(reset)
    );

    // Generate clock signal
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize signals
        reset = 1;
        X = 0;
        #10 reset = 0; // Deassert reset

        // Test normal operation
        #20 X = 1; // Simulate vehicle on country road
        #100 X = 0; // No vehicle on country road

        // Test reset
        #50 reset = 1; // Assert reset
        #10 reset = 0; // Deassert reset

        #100 $stop; // End simulation
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | Reset=%b | X=%b | Hwy=%b | Cny=%b | State=%d",
                 $time, reset, X, hwy, cny, uut.state);
    end

endmodule
