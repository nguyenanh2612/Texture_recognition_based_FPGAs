module interpolation_2 #(
   parameter WIDTH = 8,                                                                                    // Width of each cell 
   parameter FIXED = 24                                                                                    // The size of fixed point result of 4 interpolation point
) (
   ///////////////////////////////////////////////////////////////
   ///////                 INPUT OF MODULE                 ///////
   ///////////////////////////////////////////////////////////////
   input logic [WIDTH-1:0] i_pixel_00, i_pixel_01, i_pixel_02, i_pixel_03, i_pixel_04,                      // Row input pixel 0
   input logic [WIDTH-1:0] i_pixel_10, i_pixel_11,             i_pixel_13, i_pixel_14,                      // Row input pixel 1
   input logic [WIDTH-1:0] i_pixel_20,             i_pixel_22,             i_pixel_24,                      // Row input pixel 2
   input logic [WIDTH-1:0] i_pixel_30, i_pixel_31,             i_pixel_33, i_pixel_34,                      // Row input pixel 3
   input logic [WIDTH-1:0] i_pixel_40, i_pixel_41, i_pixel_42, i_pixel_43, i_pixel_44,                      // Row input pixel 4

   ////////////////////////////////////////////////////////////////
   ///////                 OUTPUT OF MODULE                 ///////
   ////////////////////////////////////////////////////////////////
   output logic [WIDTH-1:0] o_pixel_center,                                                                 // Output of central pixel
   output logic [WIDTH-1:0] o_q_ne_0, o_q_ne_2, o_q_ne_4, o_q_ne_6,                                         // 4 normal points 
   output logic [FIXED-1:0] o_q_ne_1, o_q_ne_3, o_q_ne_5, o_q_ne_7                                          // 4 interpolation points 
);
   ////////////////////////////////////////////////////////
   ///////                 VARIABLE                 ///////
   ////////////////////////////////////////////////////////
   localparam X_CORDINATE_1 = 24'h00036A, Y_CORDINATE_1 = 24'h00036A; 
   localparam X_CORDINATE_3 = 24'h000096, Y_CORDINATE_3 = 24'h00036A; 
   localparam X_CORDINATE_5 = 24'h000096, Y_CORDINATE_5 = 24'h000096;
   localparam X_CORDINATE_7 = 24'h00036A, Y_CORDINATE_7 = 24'h000096; 

   /////////////////////////////////////////////////////////////////////////
   ///////                 INTERPOLATION CALCULATION                 ///////
   /////////////////////////////////////////////////////////////////////////
   // Calculate interpolation with k in [0:7]
   // k = 0 
   assign o_q_ne_0 = i_pixel_24; 
   // k = 1 
   bilinear_cal #(
      .WIDTH         (WIDTH), 
      .FIXED         (FIXED)
   )K_1(
      // Input
      // Matrix 
      .i_pixel_00    (i_pixel_33),
      .i_pixel_01    (i_pixel_34),
      .i_pixel_10    (i_pixel_43),
      .i_pixel_11    (i_pixel_44),
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
   assign o_q_ne_2 = i_pixel_42; 
   // k = 3
   bilinear_cal #(
      .WIDTH         (WIDTH), 
      .FIXED         (FIXED)
   )K_3(
      // Input
      // Matrix 
      .i_pixel_00    (i_pixel_30),
      .i_pixel_01    (i_pixel_31),
      .i_pixel_10    (i_pixel_40),
      .i_pixel_11    (i_pixel_41),
      // x,y cordinate
      .i_x_ori       (X_CORDINATE_3[15:8]), 
      .i_y_ori       (Y_CORDINATE_3[15:8]),
      // x,y after cal
      .i_x_ne        (X_CORDINATE_3), 
      .i_y_ne        (Y_CORDINATE_3),
      // Output
      .o_result      (o_q_ne_3)
   ); 
   // k = 4 
   assign o_q_ne_4 = i_pixel_20; 
   // k = 5 
   bilinear_cal #(
      .WIDTH         (WIDTH), 
      .FIXED         (FIXED)
   )K_5(
      // Input
      // Matrix 
      .i_pixel_00    (i_pixel_00),
      .i_pixel_01    (i_pixel_01),
      .i_pixel_10    (i_pixel_10),
      .i_pixel_11    (i_pixel_11),
      // x,y cordinate
      .i_x_ori       (X_CORDINATE_5[15:8]), 
      .i_y_ori       (Y_CORDINATE_5[15:8]),
      // x,y after cal
      .i_x_ne        (X_CORDINATE_5), 
      .i_y_ne        (Y_CORDINATE_5),
      // Output
      .o_result      (o_q_ne_5)
   );
   // k = 6 
   assign o_q_ne_6 = i_pixel_02; 
   // k = 7
   bilinear_cal #(
      .WIDTH         (WIDTH), 
      .FIXED         (FIXED)
   )K_7(
      // Input
      // Matrix 
      .i_pixel_00    (i_pixel_03),
      .i_pixel_01    (i_pixel_04),
      .i_pixel_10    (i_pixel_13),
      .i_pixel_11    (i_pixel_14),
      // x,y cordinate
      .i_x_ori       (X_CORDINATE_7[15:8]), 
      .i_y_ori       (Y_CORDINATE_7[15:8]),
      // x,y after cal
      .i_x_ne        (X_CORDINATE_7), 
      .i_y_ne        (Y_CORDINATE_7),
      // Output
      .o_result      (o_q_ne_7)
   );
   // Center pixel 
   assign o_pixel_center = i_pixel_22; 
endmodule