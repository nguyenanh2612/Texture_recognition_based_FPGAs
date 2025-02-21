module ni_rd_2 #(
    parameter WIDTH = 8,                                                                                    // Width of each cell  
    parameter FIXED = 24                                                                                    // The size of fixed point result of 4 interpolation point
) (
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
    // Pixel center
    input logic [WIDTH-1:0] i_pixel_center,                                                                 // Center pixel
    // R = 2
    input logic [WIDTH-1:0] i_q_ne_0, i_q_ne_2, i_q_ne_4, i_q_ne_6,                                         // 4 normal points 
    input logic [FIXED-1:0] i_q_ne_1, i_q_ne_3, i_q_ne_5, i_q_ne_7,                                         // 4 interpolation points

    ////////////////////////////////////////////////////////////////
    ///////                 OUTPUT OF MODULE                 ///////
    ////////////////////////////////////////////////////////////////
    // output logic [FIXED-1:0] o_average,                                                                     // Output average test value
    output logic [WIDTH-1:0] o_ni, o_rd                                                                     // RD and NI result
);

    /////////////////////////////////////////////////////////////
    ///////                 NI CALCULATOR                 ///////
    /////////////////////////////////////////////////////////////
    ni NI_2(
       // Input 
       // k even
       .i_pixel_0   (i_q_ne_0), 
       .i_pixel_1   (i_q_ne_2), 
       .i_pixel_2   (i_q_ne_4), 
       .i_pixel_3   (i_q_ne_6), 
       // k odd
       .i_fixed_0   (i_q_ne_1), 
       .i_fixed_1   (i_q_ne_3), 
       .i_fixed_2   (i_q_ne_5), 
       .i_fixed_3   (i_q_ne_7),  
       // Output 
       // .o_average   (o_average),
       .o_result    (o_ni)
    ); 

    /////////////////////////////////////////////////////////////
    ///////                 RD CALCULATOR                 ///////
    /////////////////////////////////////////////////////////////
    rd RD_2(
       // Input 
       // 4 points center pixel
       .i_pixel_0       (i_q_ne_0), 
       .i_pixel_1       (i_q_ne_2), 
       .i_pixel_2       (i_q_ne_4), 
       .i_pixel_3       (i_q_ne_6), 
       .i_pixel_4       (i_pixel_center), 
       .i_pixel_5       (i_pixel_center), 
       .i_pixel_6       (i_pixel_center), 
       .i_pixel_7       (i_pixel_center),  
       // 4 points interpolation 
       .i_fixed_0       (i_q_ne_1), 
       .i_fixed_1       (i_q_ne_3), 
       .i_fixed_2       (i_q_ne_5), 
       .i_fixed_3       (i_q_ne_7), 
       .i_fixed_4       ({8'd0, i_pixel_center, 8'd0}), 
       .i_fixed_5       ({8'd0, i_pixel_center, 8'd0}), 
       .i_fixed_6       ({8'd0, i_pixel_center, 8'd0}), 
       .i_fixed_7       ({8'd0, i_pixel_center, 8'd0}),
       // Output
       .o_result        (o_rd)
    );

endmodule