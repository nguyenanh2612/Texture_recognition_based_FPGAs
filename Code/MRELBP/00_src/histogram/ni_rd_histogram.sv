module ni_rd_histogram #(
    parameter WIDTH = 8,                                                               // Width of data process 
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
   output logic [23:0] o_ni_read,                                                 // Output RD read
   output logic [23:0] o_rd_read                                                  // Output NI read 
);
   /////////////////////////////////////////////////////////
   ///////                 VARIABLES                 ///////
   /////////////////////////////////////////////////////////
   bit [23:0] rdata_ni, rdata_rd;
   bit [23:0] dupdate_ni, dupdate_rd;  
   logic             update_enable_hold;

   ///////////////////////////////////////////////////////////////
   ///////                 INSTANTIATE RAM                 ///////
   ///////////////////////////////////////////////////////////////
   ram #(
      .DATA_WIDTH    (24), 
      .ADDR_WIDTH    (8)
   )ni_memory(
      .i_data        (dupdate_ni),
      .i_addr        (i_ni_result),
      .i_wren        (update_enable_hold),
      .i_clk         (i_clk),
      .o_rdata       (rdata_ni)
   ); 

   ram #(
      .DATA_WIDTH    (24), 
      .ADDR_WIDTH    (8)
   )rd_memory(
      .i_data        (dupdate_rd),
      .i_addr        (i_rd_result),
      .i_wren        (update_enable_hold),
      .i_clk         (i_clk),
      .o_rdata       (rdata_rd)
   ); 

   ////////////////////////////////////////////////////////////////////////////////////
   ///////                 HOLD CONTROL SIGNAL AND PROCESS DATA                 ///////
   ////////////////////////////////////////////////////////////////////////////////////
   always_ff @( posedge i_clk ) begin
      update_enable_hold <= i_update_enable; 
   end

   assign dupdate_ni = rdata_ni + 24'd1; 
   assign dupdate_rd = rdata_rd + 24'd1; 
 
   ///////////////////////////////////////////////////////////
   ///////                 OUTPUT TEST                 ///////
   ///////////////////////////////////////////////////////////
   assign o_ni_read = rdata_ni; 
   assign o_rd_read = rdata_rd; 
endmodule