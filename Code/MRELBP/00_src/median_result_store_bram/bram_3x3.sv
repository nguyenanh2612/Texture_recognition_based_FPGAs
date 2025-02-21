module bram_3x3 #(
    parameter WIDTH = 8,                                                                 // Size of each cellparameter
    parameter FILTER = 3                                                                 // Type of median filter
) (
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
    input logic                                                 i_clk,                   // Global clock
    input logic                                                 i_wren,                  // Write enable  
    input logic [$clog2((2*FILTER + 1) * (2*FILTER + 1))-1:0]   i_waddr,                 // Write address
    input logic [$clog2((2*FILTER + 1) * (2*FILTER + 1))-1:0]   i_raddr,                 // Read address
    input logic [WIDTH-1:0]                                     i_din,                   // Data in

    ////////////////////////////////////////////////////////////////
    ///////                 OUTPUT OF MODULE                 ///////
    ////////////////////////////////////////////////////////////////
    output logic [WIDTH-1:0]                                    o_dout                   // Data out 
);

    ////////////////////////////////////////////////////////
    ///////                 VARIABLE                 /////// 
    ////////////////////////////////////////////////////////
    // 8 bit x (2*filter_size + 1) ^ 2 address
    logic [WIDTH-1:0] mem [((2*FILTER + 1) * (2*FILTER + 1)) - 1:0]; 

    /////////////////////////////////////////////////////////////////
    ///////                 WRITE + READ TASK                 /////// 
    /////////////////////////////////////////////////////////////////
    always_ff @(negedge i_clk or posedge i_wren) begin
        // Write
        if (i_wren) begin
            mem[i_waddr] <= i_din;
        end  
    end

    always_ff @(posedge i_clk) begin 
        // Read
        o_dout <= mem[i_raddr]; 
    end
endmodule 