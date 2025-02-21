module interpolation_6 #(
    parameter WIDTH = 8,                                                                                                                               // Width of each cell  
    parameter FIXED = 24                                                                                                                               // The size of fixed point result of 4 interpolation point
) (
   ///////////////////////////////////////////////////////////////
   ///////                 INPUT OF MODULE                 ///////
   ///////////////////////////////////////////////////////////////
    input logic [WIDTH-1:0]                                                 i_pixel_06,                                                                // Row input pixel 0
    input logic [WIDTH-1:0]             i_pixel_11, i_pixel_12,                                     i_pixel_110, i_pixel_1_11,                         // Row input pixel 1
    input logic [WIDTH-1:0]             i_pixel_21, i_pixel_22,                                     i_pixel_210, i_pixel_211,                          // Row input pixel 2
    input logic [WIDTH-1:0] i_pixel_60,                                                                                         i_pixel_612,           // Row input pixel 3
    input logic [WIDTH-1:0]             i_pixel_101, i_pixel_102,                                   i_pixel_1010, i_pixel_1011,                        // Row input pixel 4
    input logic [WIDTH-1:0]             i_pixel_11_1, i_pixel_112,                                  i_pixel_1110, i_pixel_1111,                        // Row input pixel 5
    input logic [WIDTH-1:0]                                                i_pixel_126,                                                                // Row input pixel 6

   ////////////////////////////////////////////////////////////////
   ///////                 OUTPUT OF MODULE                 ///////
   ////////////////////////////////////////////////////////////////
    output logic [WIDTH-1:0] o_q_ne_0, o_q_ne_2, o_q_ne_4, o_q_ne_6,                                                                                   // 4 normal points   
    output logic [FIXED-1:0] o_q_ne_1, o_q_ne_3, o_q_ne_5, o_q_ne_7                                                                                    // 4 interpolation points
);
   ////////////////////////////////////////////////////////
   ///////                 VARIABLE                 ///////
   ////////////////////////////////////////////////////////
   localparam X_CORDINATE_1 = 24'h000A3E, Y_CORDINATE_1 = 24'h000A3E; 
   localparam X_CORDINATE_3 = 24'h0001C2, Y_CORDINATE_3 = 24'h000A3E; 
   localparam X_CORDINATE_5 = 24'h0001C2, Y_CORDINATE_5 = 24'h0001C2;
   localparam X_CORDINATE_7 = 24'h000A3E, Y_CORDINATE_7 = 24'h0001C2;
   /////////////////////////////////////////////////////////////////////////
   ///////                 INTERPOLATION CALCULATION                 ///////
   /////////////////////////////////////////////////////////////////////////
    // k = 0 
    assign o_q_ne_0 = i_pixel_612; 
    // k = 1
    bilinear_cal K_1(
       // Input
       // Matrix 
       .i_pixel_00    (i_pixel_1010),
       .i_pixel_01    (i_pixel_1011),
       .i_pixel_10    (i_pixel_1110),
       .i_pixel_11    (i_pixel_1111),
       // x,y cordinat5
       .i_x_ori       (X_CORDINATE_1[15:8]), 
       .i_y_ori       (Y_CORDINATE_1[15:8]),
       // x,y after cal
       .i_x_ne        (X_CORDINATE_1), 
       .i_y_ne        (Y_CORDINATE_1),
       // Output
       .o_result      (o_q_ne_1)
    ); 
    // k = 2 
    assign o_q_ne_2 = i_pixel_126; 
    // k = 3 
    bilinear_cal K_3(
      // Input
      // Matrix 
      .i_pixel_00    (i_pixel_101),
      .i_pixel_01    (i_pixel_102),
      .i_pixel_10    (i_pixel_11_1),
      .i_pixel_11    (i_pixel_112),
      // x,y cordinat5
      .i_x_ori       (X_CORDINATE_3[15:8]), 
      .i_y_ori       (Y_CORDINATE_3[15:8]),
      // x,y after cal
      .i_x_ne        (X_CORDINATE_3), 
      .i_y_ne        (Y_CORDINATE_3),
      // Output
      .o_result      (o_q_ne_3)
    ); 
    // k = 4 
    assign o_q_ne_4 = i_pixel_60; 
    // k = 5
    bilinear_cal K_5(
      // Input
      // Matrix 
      .i_pixel_00    (i_pixel_11),
      .i_pixel_01    (i_pixel_12),
      .i_pixel_10    (i_pixel_21),
      .i_pixel_11    (i_pixel_22),
      // x,y cordinat5
      .i_x_ori       (X_CORDINATE_5[15:8]), 
      .i_y_ori       (Y_CORDINATE_5[15:8]),
      // x,y after cal
      .i_x_ne        (X_CORDINATE_5), 
      .i_y_ne        (Y_CORDINATE_5),
      // Output
      .o_result      (o_q_ne_5)
    ); 
    // k = 6 
    assign o_q_ne_6 = i_pixel_06; 
    // k = 7 
    bilinear_cal K_7(
      // Input
      // Matrix 
      .i_pixel_00    (i_pixel_110),
      .i_pixel_01    (i_pixel_1_11),
      .i_pixel_10    (i_pixel_210),
      .i_pixel_11    (i_pixel_211),
      // x,y cordinat5
      .i_x_ori       (X_CORDINATE_7[15:8]), 
      .i_y_ori       (Y_CORDINATE_7[15:8]),
      // x,y after cal
      .i_x_ne        (X_CORDINATE_7), 
      .i_y_ne        (Y_CORDINATE_7),
      // Output
      .o_result      (o_q_ne_7)
   ); 
endmodule    