`define TRUE 1'b1
`define FALSE 1'b0
`define y2rdelay 2
`define r2gdelay 3

module trafficsignal(output reg [1:0] hwy, 
											output reg [1:0] cny, 
											input X, 
											input clk, 
											input reset);

	
	parameter RED = 2'd0,YELLOW = 2'd1, GREEN = 2'd2;
	
	parameter s0 = 3'd0, s1 = 3'd1, s2 = 3'd2, s3 = 3'd3, s4 = 3'd4;
	
	reg [2:0] state;
	reg [2:0] nextstate;
	
	always @(posedge clk) begin
		if (reset)
			state <= s0;
		else
			state <= nextstate;
	end
	always @(state) begin
		hwy = GREEN;
		cny = RED;
		case(state)
			s0 : ;
			s1 : hwy = YELLOW;
			s2 : hwy = RED;
			s3 : begin
				hwy = RED;
				cny = GREEN;
			end
			s4 : begin
				hwy = RED;
				cny = YELLOW;
			end
		endcase
	end
	always @(state or X) begin
		case(state)
			s0 : if(X)
						nextstate = s1;
					else
						nextstate = s0;
			s1 : begin
					repeat(`y2rdelay) @(posedge clk);
					nextstate = s2;
				end
			s2 : begin
					repeat(`r2gdelay) @(posedge clk);
					nextstate = s3;
				end
			s3 : if(X) 
						nextstate = s3;
					else
						nextstate = s4;
			s4 : begin
					repeat(`y2rdelay) @(posedge clk);
					nextstate = s0;
				end
			default : nextstate = s0;
		endcase
	end

endmodule