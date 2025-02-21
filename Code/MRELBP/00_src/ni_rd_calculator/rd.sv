module rd #(
    parameter WIDTH = 8,                                                                                               // Width of each cell    
    parameter FIXED = 24                                                                                               // The size of fixed point result of 4 interpolation point
) (
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
    // 4 point center pixel of each R 
    input logic [WIDTH-1:0] i_pixel_0, i_pixel_1, i_pixel_2, i_pixel_3,                                               // 4 points center pixel of R1 
    input logic [WIDTH-1:0] i_pixel_4, i_pixel_5, i_pixel_6, i_pixel_7,                                               // 4 points center pixel of R2
    // 4 point interpolation of each R
    input logic [FIXED-1:0] i_fixed_0, i_fixed_1, i_fixed_2, i_fixed_3,                                               // 4 points interpolation of R1
    input logic [FIXED-1:0] i_fixed_4, i_fixed_5, i_fixed_6, i_fixed_7,                                               // 4 points interpolation of R2

    ////////////////////////////////////////////////////////////////
    ///////                 OUTPUT OF MODULE                 ///////
    ////////////////////////////////////////////////////////////////
    output logic [WIDTH-1:0] o_result                                                                                 // Result of RD
);

    ////////////////////////////////////////////////////////
    ///////                 VARIABLE                 ///////
    ////////////////////////////////////////////////////////
    // 4 points convert to fixed point form: Q16.8
    logic [FIXED-1:0] pixel_0_d, pixel_1_d, pixel_2_d, pixel_3_d;
    logic [FIXED-1:0] pixel_4_d, pixel_5_d, pixel_6_d, pixel_7_d;

    ///////////////////////////////////////////////////////
    ///////                 EXECUTE                 ///////
    ///////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////////////////
    ///////                 CONVERT TO FIXED FORM                 ///////
    /////////////////////////////////////////////////////////////////////
    assign pixel_0_d = {8'd0, i_pixel_0, 8'd0}; 
    assign pixel_1_d = {8'd0, i_pixel_1, 8'd0}; 
    assign pixel_2_d = {8'd0, i_pixel_2, 8'd0}; 
    assign pixel_3_d = {8'd0, i_pixel_3, 8'd0}; 
    assign pixel_4_d = {8'd0, i_pixel_4, 8'd0}; 
    assign pixel_5_d = {8'd0, i_pixel_5, 8'd0}; 
    assign pixel_6_d = {8'd0, i_pixel_6, 8'd0}; 
    assign pixel_7_d = {8'd0, i_pixel_7, 8'd0}; 

    /////////////////////////////////////////////////////////////
    ///////                 NORMALIZATION                 ///////
    /////////////////////////////////////////////////////////////
    assign o_result[0] = (pixel_4_d > pixel_0_d); 
    assign o_result[1] = (i_fixed_4 > i_fixed_0); 
    assign o_result[2] = (pixel_5_d > pixel_1_d); 
    assign o_result[3] = (i_fixed_5 > i_fixed_1); 
    assign o_result[4] = (pixel_6_d > pixel_2_d); 
    assign o_result[5] = (i_fixed_6 > i_fixed_2); 
    assign o_result[6] = (pixel_7_d > pixel_3_d); 
    assign o_result[7] = (i_fixed_7 > i_fixed_3); 

endmodule