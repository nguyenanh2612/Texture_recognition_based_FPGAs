module interpolation_8 #(
    parameter WIDTH = 8,                                                                                                                                    // Width of each cell  
    parameter FIXED = 24                                                                                                                                    // The size of fixed point result of 4 interpolation point
) (
   ///////////////////////////////////////////////////////////////
   ///////                 INPUT OF MODULE                 ///////
   ///////////////////////////////////////////////////////////////
   input logic [WIDTH-1:0]                                                 i_pixel_08,                                                                     // Row input pixel 0
   input logic [WIDTH-1:0]             i_pixel_22, i_pixel_23,                                     i_pixel_213, i_pixel_214,                               // Row input pixel 1  
   input logic [WIDTH-1:0]             i_pixel_32, i_pixel_33,                                     i_pixel_313, i_pixel_314,                               // Row input pixel 2  
   input logic [WIDTH-1:0] i_pixel_80,                                                                                          i_pixel_816,               // Row input pixel 3
   input logic [WIDTH-1:0]             i_pixel_132, i_pixel_133,                                     i_pixel_1313, i_pixel_1314,                           // Row input pixel 4  
   input logic [WIDTH-1:0]             i_pixel_142, i_pixel_143,                                     i_pixel_1413, i_pixel_1414,                           // Row input pixel 5  
   input logic [WIDTH-1:0]                                                 i_pixel_168,                                                                    // Row input pixel 6 

   ////////////////////////////////////////////////////////////////
   ///////                 OUTPUT OF MODULE                 ///////
   ////////////////////////////////////////////////////////////////
   output logic [WIDTH-1:0] o_q_ne_0, o_q_ne_2, o_q_ne_4, o_q_ne_6,                                                                                        // 4 normal points   
   output logic [FIXED-1:0] o_q_ne_1, o_q_ne_3, o_q_ne_5, o_q_ne_7                                                                                         // 4 interpolation points
);
   ////////////////////////////////////////////////////////
   ///////                 VARIABLE                 ///////
   ////////////////////////////////////////////////////////
   localparam X_CORDINATE_1 = 24'h000DA8, Y_CORDINATE_1 = 24'h000DA8; 
   localparam X_CORDINATE_3 = 24'h000258, Y_CORDINATE_3 = 24'h000DA8; 
   localparam X_CORDINATE_5 = 24'h000258, Y_CORDINATE_5 = 24'h000258;
   localparam X_CORDINATE_7 = 24'h000DA8, Y_CORDINATE_7 = 24'h000258;
   /////////////////////////////////////////////////////////////////////////
   ///////                 INTERPOLATION CALCULATION                 ///////
   /////////////////////////////////////////////////////////////////////////
    // k = 0 
    assign o_q_ne_0 = i_pixel_816; 
    // k = 1
    bilinear_cal K_1(
       // Input
       // Matrix 
       .i_pixel_00    (i_pixel_1313),
       .i_pixel_01    (i_pixel_1314),
       .i_pixel_10    (i_pixel_1413),
       .i_pixel_11    (i_pixel_1414),
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
    assign o_q_ne_2 = i_pixel_168; 
    // k = 3 
    bilinear_cal K_3(
      // Input
      // Matrix 
      .i_pixel_00    (i_pixel_132),
      .i_pixel_01    (i_pixel_133),
      .i_pixel_10    (i_pixel_142),
      .i_pixel_11    (i_pixel_143),
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
    assign o_q_ne_4 = i_pixel_80; 
    // k = 5
    bilinear_cal K_5(
      // Input
      // Matrix 
      .i_pixel_00    (i_pixel_22),
      .i_pixel_01    (i_pixel_23),
      .i_pixel_10    (i_pixel_32),
      .i_pixel_11    (i_pixel_33),
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
    assign o_q_ne_6 = i_pixel_08; 
    // k = 7 
    bilinear_cal K_7(
      // Input
      // Matrix 
      .i_pixel_00    (i_pixel_213),
      .i_pixel_01    (i_pixel_214),
      .i_pixel_10    (i_pixel_313),
      .i_pixel_11    (i_pixel_314),
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