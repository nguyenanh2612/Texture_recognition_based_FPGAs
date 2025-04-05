module ci_histogram #(
    parameter WIDTH_DATA     = 24,                               // Width data of each address
    parameter bit[23:0] WIDTH_CALULATE = 25                                // Width of input calculate
) (
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
    input logic i_clk,                                           // Global clock
    input logic i_rst,                                           // Global reset
    input logic i_wren,                                          // Write enable
    input logic [WIDTH_CALULATE-1:0] i_din,                      // Data input calculate

    ////////////////////////////////////////////////////////////////
    ///////                 OUTPUT OF MODULE                 ///////
    ////////////////////////////////////////////////////////////////
    output logic [WIDTH_DATA-1:0] o_rdata_0,                     // Data output read for address 0 
    output logic [WIDTH_DATA-1:0] o_rdata_1                      // Data output read for address 1
);
    ////////////////////////////////////////////////////////
    ///////                 VARIABLE                 /////// 
    ////////////////////////////////////////////////////////
    reg [WIDTH_DATA-1:0] ci_his [1:0]; 

    // Function to count number of 1s in input vector
    function bit[23:0] count_ones(input logic [WIDTH_CALULATE-1:0] data_in);
        bit[23:0] count;
        count = 0;
        for (int i = 0; i < WIDTH_CALULATE; i++) begin
            count += data_in[i];
        end
        return count;
    endfunction
    ///////////////////////////////////////////////////////
    ///////                 EXECUTE                 /////// 
    ///////////////////////////////////////////////////////

    always_ff @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            ci_his[0] <= 0; 
            ci_his[1] <= 0; 
        end else begin
            if (i_wren) begin
                ci_his[0] <= ci_his[0] + WIDTH_CALULATE - count_ones(i_din); 
                ci_his[1] <= ci_his[1] + count_ones(i_din);
            end
        end
    end

    assign o_rdata_0 = ci_his[0];
    assign o_rdata_1 = ci_his[1];
endmodule