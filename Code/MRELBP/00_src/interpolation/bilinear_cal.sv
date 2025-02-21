module bilinear_cal #(
    parameter WIDTH = 8,                                                                // Width of each cell 
    parameter FIXED = 24                                                                // The size of fixed point result of 4 interpolation point
) (
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
    input logic [WIDTH-1:0] i_pixel_00, i_pixel_01,                                     // Row 0
    input logic [WIDTH-1:0] i_pixel_10, i_pixel_11,                                     // Row 1
    input logic [WIDTH-1:0] i_x_ori, i_y_ori,                                           // Cordinate x, y of 4 points of matrix 2x2
    input logic [FIXED-1:0] i_x_ne, i_y_ne,                                             // Cordinate x and y after interpolation
    
    ////////////////////////////////////////////////////////////////
    ///////                 OUTPUT OF MODULE                 ///////
    ////////////////////////////////////////////////////////////////
    output logic [FIXED-1:0] o_result                                                   // Output bilinear result               
);
   ////////////////////////////////////////////////////////
   ///////                 VARIABLE                 ///////
   ////////////////////////////////////////////////////////
    localparam ONE = 24'h000100 ;
    
    // Matrix 2x2 fixed point form Q16.8
    logic [FIXED-1:0] pixel_00_d, pixel_01_d; 
    logic [FIXED-1:0] pixel_10_d, pixel_11_d; 
    
    // x,y original cordinates in fixed point form Q16.8
    logic [FIXED-1:0] x_ori_d, y_ori_d; 

    // Interpolation following x asix 
    // f(x,y1) 
    logic [FIXED-1:0] x_y1_d; 
    logic [FIXED+8-1:0] x_y10_d, x_y11_d; 
    // f(x,y2)
    logic [FIXED-1:0] x_y2_d;
    logic [FIXED+8-1:0] x_y20_d, x_y21_d;
    // f(x,y)
    logic [FIXED+8-1:0] x_y_0d, x_y_1d;

   ////////////////////////////////////////////////////////////////////
   ///////                 BILINEAR CALCULATION                 ///////
   ////////////////////////////////////////////////////////////////////

   //////////////////////////////////////////////////////////////////////
   ///////                 CONVERT TO FIXED POINT                 ///////
   //////////////////////////////////////////////////////////////////////
    // Matrix convert
    assign pixel_00_d = {8'd0, i_pixel_00, 8'd0}; 
    assign pixel_01_d = {8'd0, i_pixel_01, 8'd0};
    assign pixel_10_d = {8'd0, i_pixel_10, 8'd0}; 
    assign pixel_11_d = {8'd0, i_pixel_11, 8'd0}; 
    // x,y convert
    assign x_ori_d    = {8'd0, i_x_ori, 8'd0}; 
    assign y_ori_d    = {8'd0, i_y_ori, 8'd0}; 

    /////////////////////////////////////////////////////////////////////////////////////
    ///////                 BILINEAR CALCULATION FOLLOWING X ASIX                 ///////
    /////////////////////////////////////////////////////////////////////////////////////
    always_comb begin
        // f(x,y1)
        x_y10_d = (x_ori_d + ONE - i_x_ne) * pixel_00_d; 
        x_y11_d = (i_x_ne - x_ori_d)       * pixel_01_d;
        x_y1_d  = x_y10_d[FIXED+8-1:WIDTH] + x_y11_d[FIXED+8-1:WIDTH]; 
        // f(x,y2)
        x_y20_d = (x_ori_d + ONE - i_x_ne) * pixel_10_d; 
        x_y21_d = (i_x_ne - x_ori_d)       * pixel_11_d; 
        x_y2_d  = x_y20_d[FIXED+8-1:WIDTH] + x_y21_d[FIXED+8-1:WIDTH];

    /////////////////////////////////////////////////////////////////////////////////////
    ///////                 BILINEAR CALCULATION FOLLOWING Y ASIX                 ///////
    /////////////////////////////////////////////////////////////////////////////////////
        // f(x,y)
        x_y_0d  =  (y_ori_d + ONE - i_y_ne) * x_y1_d; 
        x_y_1d  =  (i_y_ne - y_ori_d)       * x_y2_d;
        o_result = x_y_0d[FIXED+8-1:WIDTH]  + x_y_1d[FIXED+8-1:WIDTH];
    end 
endmodule 