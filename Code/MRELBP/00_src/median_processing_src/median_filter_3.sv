module median_filter_3 #(
    parameter WIDTH = 8                                                     // Size of each cellparameter WIDTH = 9
) (
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
    input logic i_enable_3x3,                                               // Enable computing of mdeian filter 3x3
    input logic [WIDTH-1:0] i_pixel_00, i_pixel_01, i_pixel_02,             // Pixel row 0
    input logic [WIDTH-1:0] i_pixel_10, i_pixel_11, i_pixel_12,             // Pixel row 1
    input logic [WIDTH-1:0] i_pixel_20, i_pixel_21, i_pixel_22,             // Pixel row 2

    ////////////////////////////////////////////////////////////////
    ///////                 OUTPUT OF MODULE                 ///////
    ////////////////////////////////////////////////////////////////
    output logic [WIDTH-1:0] o_pixel_median                                 // Median pixel of filter 3x3 
);

    ////////////////////////////////////////////////////////
    ///////                 VARIABLE                 /////// 
    ////////////////////////////////////////////////////////
    // Sorted matrix registers
    logic [WIDTH-1:0] sorted_row[8:0];
    logic [WIDTH-1:0] final_sorted[8:0];


    ////////////////////////////////////////////////////////////
    ///////                 SORT EACH ROW                ///////
    ////////////////////////////////////////////////////////////
    sorted_3_elements row0(
        .i_element_0(i_pixel_00),
        .i_element_1(i_pixel_01),
        .i_element_2(i_pixel_02),
        .o_element_0(sorted_row[0]),
        .o_element_1(sorted_row[1]),
        .o_element_2(sorted_row[2])
    );

    sorted_3_elements row1(
        .i_element_0(i_pixel_10),
        .i_element_1(i_pixel_11),
        .i_element_2(i_pixel_12),
        .o_element_0(sorted_row[3]),
        .o_element_1(sorted_row[4]),
        .o_element_2(sorted_row[5])
    );

    sorted_3_elements row2(
        .i_element_0(i_pixel_20),
        .i_element_1(i_pixel_21),
        .i_element_2(i_pixel_22),
        .o_element_0(sorted_row[6]),
        .o_element_1(sorted_row[7]),
        .o_element_2(sorted_row[8])
    );

    /////////////////////////////////////////////////////////////////
    ///////                 SORT MIDDLE COLUMN                ///////
    /////////////////////////////////////////////////////////////////
    sorted_3_elements column1(
        .i_element_0(sorted_row[1]),
        .i_element_1(sorted_row[4]),
        .i_element_2(sorted_row[7]),
        .o_element_0(final_sorted[1]),
        .o_element_1(final_sorted[4]),
        .o_element_2(final_sorted[7])
    );

    //////////////////////////////////////////////////////////
    ///////                 GET RESULT                 ///////
    //////////////////////////////////////////////////////////
    assign o_pixel_median = (i_enable_3x3) ? final_sorted[4] : o_pixel_median;

endmodule
