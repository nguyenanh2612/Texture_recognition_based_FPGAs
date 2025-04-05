module ram #(
    parameter DATA_WIDTH=8,                                             // Data width 
    parameter ADDR_WIDTH=6                                              // Address width
)(
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
	input [(DATA_WIDTH-1):0]        i_data,                             // Data input for write
	input [(ADDR_WIDTH-1):0]        i_addr,                             // Address input        
	input                           i_wren,                             // Write enable
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
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	// Variable to hold the registered read address
	reg [ADDR_WIDTH-1:0] addr_reg;

    //////////////////////////////////////////////////////////////
    ///////                 READ AND WRITE                 /////// 
    //////////////////////////////////////////////////////////////
	always @ (posedge i_clk) begin
		// Write
		if (i_wren)
			ram[i_addr] <= i_data;
        // Hold read address 1 clock
		addr_reg <= i_addr;
	end
	assign o_rdata = ram[addr_reg];

endmodule
