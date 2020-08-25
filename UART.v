module UART (
	input i_clk,
	input i_rx,
	output o_tx
);

wire w_data_valid;
wire [7:0] w_data;

	uart_rx receiver (.i_clk(i_clk), .i_rx(i_rx), .o_data(w_data), .o_data_valid(w_data_valid));
	uart_tx transmiter (.i_clk(i_clk), .i_data(w_data), .i_send(w_data_valid), .o_tx(o_tx));
	
	

endmodule