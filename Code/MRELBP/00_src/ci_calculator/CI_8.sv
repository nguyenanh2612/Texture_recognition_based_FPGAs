module CI_8 #(
    parameter WIDTH = 8                                                                                                             // Width of value
) (
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
    input logic [WIDTH-1:0] i_pixel_00, i_pixel_01, i_pixel_02, i_pixel_03, i_pixel_04, i_pixel_05, i_pixel_06,                     // Row pixel input 1  
    input logic [WIDTH-1:0] i_pixel_10, i_pixel_11, i_pixel_12, i_pixel_13, i_pixel_14, i_pixel_15, i_pixel_16,                     // Row pixel input 2  
    input logic [WIDTH-1:0] i_pixel_20, i_pixel_21, i_pixel_22, i_pixel_23, i_pixel_24, i_pixel_25, i_pixel_26,                     // Row pixel input 3  
    input logic [WIDTH-1:0] i_pixel_30, i_pixel_31, i_pixel_32, i_pixel_33, i_pixel_34, i_pixel_35, i_pixel_36,                     // Row pixel input 4  
    input logic [WIDTH-1:0] i_pixel_40, i_pixel_41, i_pixel_42, i_pixel_43, i_pixel_44, i_pixel_45, i_pixel_46,                     // Row pixel input 5  
    input logic [WIDTH-1:0] i_pixel_50, i_pixel_51, i_pixel_52, i_pixel_53, i_pixel_54, i_pixel_55, i_pixel_56,                     // Row pixel input 6  
    input logic [WIDTH-1:0] i_pixel_60, i_pixel_61, i_pixel_62, i_pixel_63, i_pixel_64, i_pixel_65, i_pixel_66,                     // Row pixel input 7  

    ////////////////////////////////////////////////////////////////
    ///////                 OUTPUT OF MODULE                 ///////
    ////////////////////////////////////////////////////////////////
    output logic o_ci_00, o_ci_01, o_ci_02, o_ci_03, o_ci_04, o_ci_05, o_ci_06,                                                     // Row output conver to logic 1 (normalization) 
    output logic o_ci_10, o_ci_11, o_ci_12, o_ci_13, o_ci_14, o_ci_15, o_ci_16,                                                     // Row output conver to logic 2 (normalization)
    output logic o_ci_20, o_ci_21, o_ci_22, o_ci_23, o_ci_24, o_ci_25, o_ci_26,                                                     // Row output conver to logic 3 (normalization)
    output logic o_ci_30, o_ci_31, o_ci_32, o_ci_33, o_ci_34, o_ci_35, o_ci_36,                                                     // Row output conver to logic 4 (normalization) 
    output logic o_ci_40, o_ci_41, o_ci_42, o_ci_43, o_ci_44, o_ci_45, o_ci_46,                                                     // Row output conver to logic 5 (normalization) 
    output logic o_ci_50, o_ci_51, o_ci_52, o_ci_53, o_ci_54, o_ci_55, o_ci_56,                                                     // Row output conver to logic 6 (normalization) 
    output logic o_ci_60, o_ci_61, o_ci_62, o_ci_63, o_ci_64, o_ci_65, o_ci_66                                                      // Row output conver to logic 7 (normalization)
);
    ////////////////////////////////////////////////////////
    ///////                 VARIABLE                 ///////
    ////////////////////////////////////////////////////////
    // Division value
    localparam DIVISOR = 16'd289;
    
    // Sum + average
    logic [15:0] sum; 
    logic [15:0] average; 
    
    //////////////////////////////////////////////////////////
    ///////                 CALCULATOR                 ///////
    //////////////////////////////////////////////////////////
    // Sum of local path that around the center pixel 
    assign sum = i_pixel_00 + i_pixel_01 + i_pixel_02 + i_pixel_03 + i_pixel_04 + i_pixel_05 + i_pixel_06 + 
                 i_pixel_10 + i_pixel_11 + i_pixel_12 + i_pixel_13 + i_pixel_14 + i_pixel_15 + i_pixel_16 + 
                 i_pixel_20 + i_pixel_21 + i_pixel_22 + i_pixel_23 + i_pixel_24 + i_pixel_25 + i_pixel_26 + 
                 i_pixel_30 + i_pixel_31 + i_pixel_32 + i_pixel_33 + i_pixel_34 + i_pixel_35 + i_pixel_36 + 
                 i_pixel_40 + i_pixel_41 + i_pixel_42 + i_pixel_43 + i_pixel_44 + i_pixel_45 + i_pixel_46 + 
                 i_pixel_50 + i_pixel_51 + i_pixel_52 + i_pixel_53 + i_pixel_54 + i_pixel_55 + i_pixel_56 + 
                 i_pixel_60 + i_pixel_61 + i_pixel_62 + i_pixel_63 + i_pixel_64 + i_pixel_65 + i_pixel_66;  
    // Average of all (16 bit fixed point ???)
    assign average = (sum << 2) / DIVISOR; 
    
    // Output binary matrix (compare each pixel to average value)
    assign o_ci_00 = ({6'd0,i_pixel_00,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_01 = ({6'd0,i_pixel_01,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_02 = ({6'd0,i_pixel_02,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_03 = ({6'd0,i_pixel_03,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_04 = ({6'd0,i_pixel_04,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_05 = ({6'd0,i_pixel_05,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_06 = ({6'd0,i_pixel_06,2'd0} <= average) ? 1'b0 : 1'b1;

    assign o_ci_10 = ({6'd0,i_pixel_10,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_11 = ({6'd0,i_pixel_11,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_12 = ({6'd0,i_pixel_12,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_13 = ({6'd0,i_pixel_13,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_14 = ({6'd0,i_pixel_14,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_15 = ({6'd0,i_pixel_15,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_16 = ({6'd0,i_pixel_16,2'd0} <= average) ? 1'b0 : 1'b1;

    assign o_ci_20 = ({6'd0,i_pixel_20,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_21 = ({6'd0,i_pixel_21,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_22 = ({6'd0,i_pixel_22,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_23 = ({6'd0,i_pixel_23,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_24 = ({6'd0,i_pixel_24,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_25 = ({6'd0,i_pixel_25,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_26 = ({6'd0,i_pixel_26,2'd0} <= average) ? 1'b0 : 1'b1;

    assign o_ci_30 = ({6'd0,i_pixel_30,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_31 = ({6'd0,i_pixel_31,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_32 = ({6'd0,i_pixel_32,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_33 = ({6'd0,i_pixel_33,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_34 = ({6'd0,i_pixel_34,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_35 = ({6'd0,i_pixel_35,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_36 = ({6'd0,i_pixel_36,2'd0} <= average) ? 1'b0 : 1'b1;

    assign o_ci_40 = ({6'd0,i_pixel_40,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_41 = ({6'd0,i_pixel_41,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_42 = ({6'd0,i_pixel_42,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_43 = ({6'd0,i_pixel_43,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_44 = ({6'd0,i_pixel_44,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_45 = ({6'd0,i_pixel_45,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_46 = ({6'd0,i_pixel_46,2'd0} <= average) ? 1'b0 : 1'b1;

    assign o_ci_50 = ({6'd0,i_pixel_50,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_51 = ({6'd0,i_pixel_51,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_52 = ({6'd0,i_pixel_52,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_53 = ({6'd0,i_pixel_53,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_54 = ({6'd0,i_pixel_54,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_55 = ({6'd0,i_pixel_55,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_56 = ({6'd0,i_pixel_56,2'd0} <= average) ? 1'b0 : 1'b1;

    assign o_ci_60 = ({6'd0,i_pixel_60,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_61 = ({6'd0,i_pixel_61,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_62 = ({6'd0,i_pixel_62,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_63 = ({6'd0,i_pixel_63,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_64 = ({6'd0,i_pixel_64,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_65 = ({6'd0,i_pixel_65,2'd0} <= average) ? 1'b0 : 1'b1;
    assign o_ci_66 = ({6'd0,i_pixel_66,2'd0} <= average) ? 1'b0 : 1'b1;
endmodule