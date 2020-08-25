module UART (
	input i_clk,
	input i_rx,
	output reg [7:0] o_data
);

wire w_data_valid;
wire [7:0] w_data;

	uart_rx receiver (.i_clk(i_clk), .i_rx(i_rx), .o_data(w_data));

	always @ (w_data_valid)
	begin
		if(w_data_valid == 1'b1) o_data <= w_data;
		else o_data <= w_data;
	end

endmodule