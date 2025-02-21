module ni #(
    parameter WIDTH = 8,                                                                                    // Width of each cell   
    parameter FIXED = 24                                                                                    // The size of fixed point result of 4 interpolation point
) (
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
    input logic [WIDTH-1:0] i_pixel_0, i_pixel_1, i_pixel_2, i_pixel_3,                                     // 4 points center pixel
    input logic [FIXED-1:0] i_fixed_0, i_fixed_1, i_fixed_2, i_fixed_3,                                     // 4 interpolation points 

    ////////////////////////////////////////////////////////////////
    ///////                 OUTPUT OF MODULE                 ///////
    ////////////////////////////////////////////////////////////////
    // output logic [FIXED-1:0] o_average,                                                                     // Test average  value 
    output logic [WIDTH-1:0] o_result                                                                       // Result of NI
);
    ////////////////////////////////////////////////////////
    ///////                 VARIABLE                 ///////
    ////////////////////////////////////////////////////////
    // 4 points center to form fixed: Q16.8 
    logic [FIXED-1:0] pixel_0_d, pixel_1_d, pixel_2_d, pixel_3_d; 
    // average
    logic [FIXED+8-1:0] sum_d;
    logic [FIXED-1:0] average_d; 
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

    /////////////////////////////////////////////////////////////////////////////////
    ///////                 CALCULATE AVERAGE + NORMALIZATION                 ///////
    /////////////////////////////////////////////////////////////////////////////////
    // Calculate average value
    always_comb begin
        sum_d = pixel_0_d + pixel_1_d + pixel_2_d + pixel_3_d + 
                i_fixed_0 + i_fixed_1 + i_fixed_2 + i_fixed_3 ; 
        sum_d = sum_d / 32'd8;
        average_d = sum_d[FIXED-1:0]; 
    end

    // Normalization
    assign o_result[0] = (average_d > pixel_0_d); 
    assign o_result[1] = (average_d > i_fixed_0); 
    assign o_result[2] = (average_d > pixel_1_d); 
    assign o_result[3] = (average_d > i_fixed_1); 
    assign o_result[4] = (average_d > pixel_2_d); 
    assign o_result[5] = (average_d > i_fixed_2); 
    assign o_result[6] = (average_d > pixel_3_d); 
    assign o_result[7] = (average_d > i_fixed_3); 

    // Output test 
    // assign o_average = average_d; 
endmodule