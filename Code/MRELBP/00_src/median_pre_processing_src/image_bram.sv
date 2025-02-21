module image_bram #(
    parameter WIDTH = 9,                                 // Width of bram
    parameter DEPTH = 9,                                 // Depth of bram 
    parameter SIZED = 5                                  // Size of each cell 
) (
    input logic                     i_clk,               // Global clock
    input logic                     i_rst,               // Global reset
    input logic [SIZED-1:0]         i_data,              // Data in 8-bit length
    input logic                     i_wren,              // Write enable
    output logic [SIZED*DEPTH-1:0]  o_data [DEPTH-1:0]   // Data output 8-shift register 72 bit
);

/********************************** BRAM **************************************************/ 
    always_ff @(posedge i_clk or posedge i_rst or posedge i_wren) begin : image_input_bram
        if (i_rst) begin 
            // Clear the output when reset is active
            integer i;
            for (i = 0; i < DEPTH; i = i + 1) begin
                o_data[i] <= 0;  // Clear each memory cell to 0
            end
        end else if (i_wren) begin 
            integer i; 
            // Shift the final byte of first shift register to first byte of next shift register
            for (i = DEPTH -1; i > 0; i = i - 1) begin
                o_data[i] <= {o_data[i-1][SIZED-1:0],o_data[i][SIZED*DEPTH-1:SIZED]}; 
            end
            o_data[0] <= {i_data,o_data[0][SIZED*DEPTH-1:SIZED]}; 
        end 
    end 
endmodule