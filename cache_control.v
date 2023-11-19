// cache_control for handeling cache misses

module cache_fill_FSM(
	input clk, rst,
	input miss_detected, // active high when tag match logic detects a miss
	input [15:0] miss_address, // address that missed the cache
	output fsm_busy, // asserted while FSM is busy handling the miss (can be used as pipeline stall signal)
	output write_data_array, // write enable to cache data array to signal when filling with memory_data
	output write_tag_array, // write enable to cache tag array to signal when all words are filled in to data array
	output [15:0] memory_address, // address to read from memory
	input [15:0] memory_data, // data returned by memory (after  delay)
	input memory_data_valid // active high indicates valid data returning on memory bus
	);

	wire block_address = {miss_address[15:4], 4'h0}

	wire prev_state; // tracks the prev state as an output of the dff
	wire swap_state = miss_detected | memory_data_valid; // determines whether we need toswap states
	wire new_state = curr_state ^ swap_state; // the new state determined by the previous state and whether we will be swapping
	
	// idle = 0, wait = 1
	dff idle_wait_fm (.q(prev_state), .d(new_state), .wen(swap_state), .clk(clk), .rst(rst));

	// busy when new_state = 1
	assign fsm_busy = new_state; // stall signal

	//

endmodule
