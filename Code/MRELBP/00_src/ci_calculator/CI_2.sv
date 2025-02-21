module CI_2 #(
    parameter WIDTH = 8                                                                                     // Width of value
) (
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
    input logic [WIDTH-1:0] i_pixel_11, i_pixel_12, i_pixel_13, i_pixel_14, i_pixel_15,                     // row pixel input 1
    input logic [WIDTH-1:0] i_pixel_21, i_pixel_22, i_pixel_23, i_pixel_24, i_pixel_25,                     // row pixel input 2
    input logic [WIDTH-1:0] i_pixel_31, i_pixel_32, i_pixel_33, i_pixel_34, i_pixel_35,                     // row pixel input 3
    input logic [WIDTH-1:0] i_pixel_41, i_pixel_42, i_pixel_43, i_pixel_44, i_pixel_45,                     // row pixel input 4
    input logic [WIDTH-1:0] i_pixel_51, i_pixel_52, i_pixel_53, i_pixel_54, i_pixel_55,                     // row pixel input 5

    ////////////////////////////////////////////////////////////////
    ///////                 OUTPUT OF MODULE                 ///////
    ////////////////////////////////////////////////////////////////
    output logic o_ci_00, o_ci_01, o_ci_02, o_ci_03, o_ci_04,                                               // row output conver to logic 1 (normalization)
    output logic o_ci_10, o_ci_11, o_ci_12, o_ci_13, o_ci_14,                                               // row output conver to logic 2 (normalization)
    output logic o_ci_20, o_ci_21, o_ci_22, o_ci_23, o_ci_24,                                               // row output conver to logic 3 (normalization)
    output logic o_ci_30, o_ci_31, o_ci_32, o_ci_33, o_ci_34,                                               // row output conver to logic 4 (normalization)
    output logic o_ci_40, o_ci_41, o_ci_42, o_ci_43, o_ci_44                                                // row output conver to logic 5 (normalization)
);
    ////////////////////////////////////////////////////////
    ///////                 VARIABLE                 ///////
    ////////////////////////////////////////////////////////
    // Division value
    localparam DIVISOR = 16'd25;
     
    // Sum + average
    logic [15:0] sum; 
    logic [15:0] average; 

    //////////////////////////////////////////////////////////
    ///////                 CALCULATOR                 ///////
    //////////////////////////////////////////////////////////
    // Sum of local path that around the center pixel 
    assign sum = i_pixel_11 + i_pixel_12 + i_pixel_13 + i_pixel_14 + i_pixel_15 +
                 i_pixel_21 + i_pixel_22 + i_pixel_23 + i_pixel_24 + i_pixel_25 +
                 i_pixel_31 + i_pixel_32 + i_pixel_33 + i_pixel_34 + i_pixel_35 +
                 i_pixel_41 + i_pixel_42 + i_pixel_43 + i_pixel_44 + i_pixel_45 +
                 i_pixel_51 + i_pixel_52 + i_pixel_53 + i_pixel_54 + i_pixel_55;   
    // Average of all (Q14.2)
    assign average = (sum << 2) / DIVISOR; 
    
    // Output binary matrix (comapare each pixel to average value)
    assign o_ci_00 = ({6'd0,i_pixel_11,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_01 = ({6'd0,i_pixel_12,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_02 = ({6'd0,i_pixel_13,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_03 = ({6'd0,i_pixel_14,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_04 = ({6'd0,i_pixel_15,2'd0} <= average) ? 1'b0 : 1'b1; 

    assign o_ci_10 = ({6'd0,i_pixel_21,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_11 = ({6'd0,i_pixel_22,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_12 = ({6'd0,i_pixel_23,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_13 = ({6'd0,i_pixel_24,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_14 = ({6'd0,i_pixel_25,2'd0} <= average) ? 1'b0 : 1'b1; 

    assign o_ci_20 = ({6'd0,i_pixel_31,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_21 = ({6'd0,i_pixel_32,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_22 = ({6'd0,i_pixel_33,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_23 = ({6'd0,i_pixel_34,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_24 = ({6'd0,i_pixel_35,2'd0} <= average) ? 1'b0 : 1'b1; 

    assign o_ci_30 = ({6'd0,i_pixel_41,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_31 = ({6'd0,i_pixel_42,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_32 = ({6'd0,i_pixel_43,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_33 = ({6'd0,i_pixel_44,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_34 = ({6'd0,i_pixel_45,2'd0} <= average) ? 1'b0 : 1'b1; 

    assign o_ci_40 = ({6'd0,i_pixel_51,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_41 = ({6'd0,i_pixel_52,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_42 = ({6'd0,i_pixel_53,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_43 = ({6'd0,i_pixel_54,2'd0} <= average) ? 1'b0 : 1'b1; 
    assign o_ci_44 = ({6'd0,i_pixel_55,2'd0} <= average) ? 1'b0 : 1'b1; 
endmodule