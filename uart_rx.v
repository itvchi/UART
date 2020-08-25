// CLK_COUNT = (i_clk_frequency)/(baud_rate)
// Example:
//	50 000 000 Hz/115 200 baud ~ 434
//	50 000 000 Hz/9 600 baud ~ 5208

module uart_rx (
	input i_clk,
	input i_rx,
	output [7:0] o_data,
	output o_data_valid
);

parameter CLK_COUNT = 434;	//baud=115200

parameter IDLE = 3'b000;
parameter START_BIT = 3'b001;
parameter DATA_BIT = 3'b010;
parameter STOP_BIT = 3'b011;
parameter END = 3'b100;

reg [2:0] r_state = 0;
reg [12:0] r_counter = 0;
reg [2:0] r_index = 0;
reg [7:0] r_data = 0;
reg r_data_valid = 0;

	always @ (posedge i_clk)
	begin
		case(r_state)
			IDLE:
			begin
				r_data_valid <= 1'b0;
				r_counter <= 0;
				r_index <= 0;
				
				if(i_rx == 1'b0) r_state <= START_BIT;
				else r_state <= IDLE;
			end
			
			START_BIT:
			begin
				if(r_counter == (CLK_COUNT-1)/2)
				begin
					if(i_rx == 1'b0)
					begin
						r_counter <= 0;
						r_state <= DATA_BIT;
					end
					else r_state <= IDLE;
				end
				else 
				begin
					r_counter <= r_counter + 1;
					r_state <= START_BIT;
				end
			end
			
			DATA_BIT:
			begin
				if(r_counter == CLK_COUNT-1)
				begin
					r_counter <= 0;
					r_data[r_index] <= i_rx;
					
					if(r_index<7)
					begin
						r_index <= r_index + 1;
						r_state <= DATA_BIT;
					end
					else
					begin
						r_index <= 0;
						r_state <= STOP_BIT;
					end
				end
				else 
				begin
					r_counter <= r_counter + 1;
					r_state <= DATA_BIT;
				end
			end
			
			STOP_BIT:
			begin
				if(r_counter == CLK_COUNT-1)
				begin
					if(i_rx == 1'b1)
					begin
						r_counter <= 0;
						r_data_valid <= 1'b1;
						r_state <= END;
					end
					else r_state <= IDLE;
				end
				else 
				begin
					r_counter <= r_counter + 1;
					r_state <= STOP_BIT;
				end
			end
			
			END:
			begin
				r_data_valid <= 1'b0;
				r_state <= IDLE;
			end
			
			default:
			begin
				r_state <= IDLE;
			end
		endcase
	end

	assign o_data = r_data;
	assign o_data_valid = r_data_valid;
	
endmodule