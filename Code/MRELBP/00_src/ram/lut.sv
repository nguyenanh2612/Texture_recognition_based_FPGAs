module lut #(
    parameter DATA_WIDTH=8,                                             // Data width 
    parameter ADDR_WIDTH=6                                              // Address width
)(
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
	// input [(DATA_WIDTH-1):0]        i_data,                             // Data input for write
	input [(ADDR_WIDTH-1):0]        i_addr,                             // Address input        
	// input                           i_wren,                             // Write enable
    input                           i_clk ,                             // Global clock
    
    ////////////////////////////////////////////////////////////////
    ///////                 OUTPUT OF MODULE                 ///////
    ////////////////////////////////////////////////////////////////
	output [(DATA_WIDTH-1):0]       o_rdata                             // Read data
);

    ////////////////////////////////////////////////////////
    ///////                 VARIABLE                 /////// 
    ////////////////////////////////////////////////////////
	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0] = {
        8'h00, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 
        8'h08, 8'h09, 8'h0A, 8'h0B, 8'h0C, 8'h0D, 8'h0E, 8'h0F, 
        8'h10, 8'h11, 8'h12, 8'h13, 8'h14, 8'h15, 8'h16, 8'h17, 
        8'h18, 8'h19, 8'h1A, 8'h1B, 8'h1C, 8'h1D, 8'h1E, 8'h1F, 
        8'h20, 8'h21, 8'h22, 8'h23, 8'h24, 8'h25, 8'h26, 8'h27, 
        8'h28, 8'h29, 8'h2A, 8'h2B, 8'h2C, 8'h2D, 8'h2E, 8'h2F, 
        8'h30, 8'h31, 8'h32, 8'h33, 8'h34, 8'h35, 8'h36, 8'h37, 
        8'h38, 8'h39, 8'h3A, 8'h3B, 8'h3C, 8'h3D, 8'h3E, 8'h3F

    };

	// Variable to hold the registered read address
	reg [ADDR_WIDTH-1:0] addr_reg;

    //////////////////////////////////////////////////////////////
    ///////                 READ AND WRITE                 /////// 
    //////////////////////////////////////////////////////////////
	always @ (posedge i_clk) begin
		// Write
		// if (i_wren)
			// ram[i_addr] <= i_data;
        // Hold read address 1 clock
		addr_reg <= i_addr;
	end
	assign o_rdata = ram[addr_reg];

endmodule
