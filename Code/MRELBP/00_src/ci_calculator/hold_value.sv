// module hold_value #(
//     parameter WIDTH = 8,                                    // Width of data
//     parameter SIZE =  25                                    // Number of elements
// ) (
//     ///////////////////////////////////////////////////////////////
//     ///////                 INPUT OF MODULE                 ///////
//     ///////////////////////////////////////////////////////////////
//     input logic [$clog2(SIZE)-1:0]      i_enable,           // Enable hold value
//     input logic [WIDTH-1:0]             i_din,              // Data in for hold 

//     ////////////////////////////////////////////////////////////////
//     ///////                 OUTPUT OF MODULE                 ///////
//     ////////////////////////////////////////////////////////////////
//     output logic [WIDTH-1:0]            o_dout [SIZE-1:0]   // Data out
// );
//     ////////////////////////////////////////////////////////
//     ///////                 VARIABLE                 ///////
//     ////////////////////////////////////////////////////////
//     // Internal memory
//     logic [WIDTH-1:0] mem [SIZE-1:0]; 

//     //////////////////////////////////////////////////////////
//     ///////                 HOLD VALUE                 ///////
//     //////////////////////////////////////////////////////////
//     always @(*) begin
//         for (int i = 0; i < SIZE; i++) begin
//             if (i_enable == i) begin
//                 mem[i] = i_din;
//             end
//             o_dout[i] = mem[i];
//         end
//     end

// endmodule 

module hold_value #(
    parameter WIDTH = 8,                                    // Width of data
    parameter SIZE =  25                                    // Number of elements
) (
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
    input logic                         i_clk,              // Global clock
    input logic                         i_rst,              // Global reset
    input logic [$clog2(SIZE)-1:0]      i_enable,           // Enable hold value
    input logic [WIDTH-1:0]             i_din,              // Data in for hold 

    ////////////////////////////////////////////////////////////////
    ///////                 OUTPUT OF MODULE                 ///////
    ////////////////////////////////////////////////////////////////
    output logic [WIDTH-1:0]            o_dout [SIZE-1:0]   // Data out
);
    ////////////////////////////////////////////////////////
    ///////                 VARIABLE                 ///////
    ////////////////////////////////////////////////////////
    // Internal memory
    logic [WIDTH-1:0] mem [SIZE-1:0];
    int j; 
    genvar i;
    //////////////////////////////////////////////////////////
    ///////                 HOLD VALUE                 ///////
    //////////////////////////////////////////////////////////
    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            for (j=0; j<SIZE; j=j+1) begin
                mem[j] <= 0; 
            end
        end else begin
            mem[i_enable] <= i_din;
        end
    end

    ////////////////////////////////////////////////////////////////
    ///////                 ASSIGN TO OUTPUT                 ///////
    ////////////////////////////////////////////////////////////////
    generate 
        for (i=0; i<SIZE; i=i+1) begin : assign_to_output
            assign o_dout[i] = mem[i]; 
        end
    endgenerate

endmodule