module ni_rd #(
    parameter WIDTH = 8,                                                                                        // Width of each cell    
    parameter FIXED = 24                                                                                        // The size of fixed point result of 4 interpolation point 
) (
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
    // R_1
    input logic [WIDTH-1:0] i_q_ne_0_1, i_q_ne_2_1, i_q_ne_4_1, i_q_ne_6_1,                                     // 4 normal points R1
    input logic [FIXED-1:0] i_q_ne_1_1, i_q_ne_3_1, i_q_ne_5_1, i_q_ne_7_1,                                     // 4 interpolation points R1
    // R_2 
    input logic [WIDTH-1:0] i_q_ne_0_2, i_q_ne_2_2, i_q_ne_4_2, i_q_ne_6_2,                                     // 4 normal points R2
    input logic [FIXED-1:0] i_q_ne_1_2, i_q_ne_3_2, i_q_ne_5_2, i_q_ne_7_2,                                     // 4 interpolation pointsR2
    
    ////////////////////////////////////////////////////////////////
    ///////                 OUTPUT OF MODULE                 ///////
    ////////////////////////////////////////////////////////////////
    // output logic [FIXED-1:0] o_average,                                                                         // Output average test value
    output logic [WIDTH-1:0] o_ni, o_rd                                                                         // RD and NI result
);
    /////////////////////////////////////////////////////////////
    ///////                 NI CALCULATOR                 ///////
    /////////////////////////////////////////////////////////////
    ni NI_R(
       // Input 
       // k even
       .i_pixel_0   (i_q_ne_0_2), 
       .i_pixel_1   (i_q_ne_2_2), 
       .i_pixel_2   (i_q_ne_4_2), 
       .i_pixel_3   (i_q_ne_6_2), 
       // k odd
       .i_fixed_0   (i_q_ne_1_2), 
       .i_fixed_1   (i_q_ne_3_2), 
       .i_fixed_2   (i_q_ne_5_2), 
       .i_fixed_3   (i_q_ne_7_2),  
       // Output 
       // .o_average   (o_average),
       .o_result    (o_ni)
    ); 
    
    /////////////////////////////////////////////////////////////
    ///////                 RD CALCULATOR                 ///////
    /////////////////////////////////////////////////////////////
    rd RD_R(
       // Input 
       // 4 points center pixel
       .i_pixel_0       (i_q_ne_0_1), 
       .i_pixel_1       (i_q_ne_2_1), 
       .i_pixel_2       (i_q_ne_4_1), 
       .i_pixel_3       (i_q_ne_6_1), 
       .i_pixel_4       (i_q_ne_0_2), 
       .i_pixel_5       (i_q_ne_2_2), 
       .i_pixel_6       (i_q_ne_4_2), 
       .i_pixel_7       (i_q_ne_6_2),  
       // 4 points interpolation 
       .i_fixed_0       (i_q_ne_1_1), 
       .i_fixed_1       (i_q_ne_3_1), 
       .i_fixed_2       (i_q_ne_5_1), 
       .i_fixed_3       (i_q_ne_7_1), 
       .i_fixed_4       (i_q_ne_1_2), 
       .i_fixed_5       (i_q_ne_3_2), 
       .i_fixed_6       (i_q_ne_5_2), 
       .i_fixed_7       (i_q_ne_7_2),
       // Output
       .o_result        (o_rd)
    );

endmodule    