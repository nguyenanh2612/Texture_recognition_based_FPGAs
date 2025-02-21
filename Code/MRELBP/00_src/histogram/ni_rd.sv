module ni_rd_histogram #(
    parameter WIDTH = 8,                                                               // Width of data process
    parameter SIZED = 6,                                                               // Size bit of each address     
    parameter DEPTH = 256                                                              // Depth of histogram memory
) (
   ///////////////////////////////////////////////////////////////
   ///////                 INPUT OF MODULE                 ///////
   ///////////////////////////////////////////////////////////////
   input logic i_clk,                                                                  // Global clock  
   input logic i_update_enable,                                                        // Update to memory enable (write enable)
   input logic [WIDTH-1:0] i_ni_result,                                                // NI address udpate enable
   input logic [WIDTH-1:0] i_rd_result,                                                // RD address update enable
   
   ////////////////////////////////////////////////////////////////
   ///////                 OUTPUT OF MODULE                 ///////
   ////////////////////////////////////////////////////////////////
   output logic [WIDTH-1:0] o_ni_read,                                                 // Output RD read
   output logic [WIDTH-1:0] o_rd_read                                                  // Output NI read 
);
   ////////////////////////////////////////////////////////
   ///////                 VARIABLE                 ///////
   ////////////////////////////////////////////////////////
   logic [SIZED-1:0] ni_ram [DEPTH-1:0]; 
   logic [SIZED-1:0] rd_ram [DEPTH-1:0];

   ////////////////////////////////////////////////////////
   ///////                 VARIABLE                 ///////
   ////////////////////////////////////////////////////////

   // Hold

   // Update

   // Read

endmodule