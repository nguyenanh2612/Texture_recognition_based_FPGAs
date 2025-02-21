module median_filter_5 #(
    parameter WIDTH = 8                                                                                     // Size of each cellparameter WIDTH = 9                                                                     
) (
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
    input logic             i_enable_5x5,                                                                   // Enable computing of mdeian filter 5x5
    input logic [WIDTH-1:0] i_pixel_00, i_pixel_01, i_pixel_02, i_pixel_03, i_pixel_04,                     // Row 0
    input logic [WIDTH-1:0] i_pixel_10, i_pixel_11, i_pixel_12, i_pixel_13, i_pixel_14,                     // Row 1
    input logic [WIDTH-1:0] i_pixel_20, i_pixel_21, i_pixel_22, i_pixel_23, i_pixel_24,                     // Row 2
    input logic [WIDTH-1:0] i_pixel_30, i_pixel_31, i_pixel_32, i_pixel_33, i_pixel_34,                     // Row 3
    input logic [WIDTH-1:0] i_pixel_40, i_pixel_41, i_pixel_42, i_pixel_43, i_pixel_44,                     // Row 4

    ////////////////////////////////////////////////////////////////
    ///////                 OUTPUT OF MODULE                 ///////
    ////////////////////////////////////////////////////////////////
    output logic [WIDTH-1:0] o_value_median                                                                  // Median pixel of filter 3x3  
);
    ////////////////////////////////////////////////////////
    ///////                 VARIABLE                 /////// 
    ////////////////////////////////////////////////////////
    // Sorted col output signals
    logic [WIDTH-1:0] sorted_col_00, sorted_col_01, sorted_col_02, sorted_col_03, sorted_col_04;            // Row 0
    logic [WIDTH-1:0] sorted_col_10, sorted_col_11, sorted_col_12, sorted_col_13, sorted_col_14;            // Row 1
    logic [WIDTH-1:0] sorted_col_20, sorted_col_21, sorted_col_22, sorted_col_23, sorted_col_24;            // Row 2
    logic [WIDTH-1:0] sorted_col_30, sorted_col_31, sorted_col_32, sorted_col_33, sorted_col_34;            // Row 3
    logic [WIDTH-1:0] sorted_col_40, sorted_col_41, sorted_col_42, sorted_col_43, sorted_col_44;            // Row 4

    // Sorted row output signals
    logic [WIDTH-1:0] sorted_row_00, sorted_row_01, sorted_row_02, sorted_row_03, sorted_row_04;            // Row 0
    logic [WIDTH-1:0] sorted_row_10, sorted_row_11, sorted_row_12, sorted_row_13, sorted_row_14;            // Row 1
    logic [WIDTH-1:0] sorted_row_20, sorted_row_21, sorted_row_22, sorted_row_23, sorted_row_24;            // Row 2
    logic [WIDTH-1:0] sorted_row_30, sorted_row_31, sorted_row_32, sorted_row_33, sorted_row_34;            // Row 3
    logic [WIDTH-1:0] sorted_row_40, sorted_row_41, sorted_row_42, sorted_row_43, sorted_row_44;            // Row 4

    // Sorted diagonal output signals
    logic [WIDTH-1:0] diagonal_00, diagonal_01, diagonal_02, diagonal_03;
    logic [WIDTH-1:0] diagonal_10, diagonal_11, diagonal_12, diagonal_13, diagonal_14; 
    logic [WIDTH-1:0] diagonal_20, diagonal_21, diagonal_22, diagonal_23;

    // Sorted 3 elements diagonal 
    logic [WIDTH-1:0] diagonal_center;

    ////////////////////////////////////////////////////////////
    ///////                 SORT EACH ROW                ///////
    ////////////////////////////////////////////////////////////
    // Col 0
    bitonic_sort_9#(
        .WIDTH      (WIDTH)
    )col0(
        // Input
        .i_number_0 (8'd0), 
        .i_number_1 (8'd0), 
        .i_number_2 (8'd0), 
        .i_number_3 (8'd0), 
        .i_number_4 (i_pixel_00), 
        .i_number_5 (i_pixel_10), 
        .i_number_6 (i_pixel_20), 
        .i_number_7 (i_pixel_30), 
        .i_number_8 (i_pixel_40),
        // Output
        .o_number_0 (), 
        .o_number_1 (), 
        .o_number_2 (), 
        .o_number_3 (), 
        .o_number_4 (sorted_col_00),
        .o_number_5 (sorted_col_10), 
        .o_number_6 (sorted_col_20), 
        .o_number_7 (sorted_col_30), 
        .o_number_8 (sorted_col_40)
    ); 
    // Col 1
    bitonic_sort_9#(
        .WIDTH      (WIDTH)
    )col1(
        // Input
        .i_number_0 (8'd0), 
        .i_number_1 (8'd0), 
        .i_number_2 (8'd0), 
        .i_number_3 (8'd0), 
        .i_number_4 (i_pixel_01), 
        .i_number_5 (i_pixel_11), 
        .i_number_6 (i_pixel_21), 
        .i_number_7 (i_pixel_31), 
        .i_number_8 (i_pixel_41),
        // Output
        .o_number_0 (), 
        .o_number_1 (), 
        .o_number_2 (), 
        .o_number_3 (), 
        .o_number_4 (sorted_col_01),
        .o_number_5 (sorted_col_11), 
        .o_number_6 (sorted_col_21), 
        .o_number_7 (sorted_col_31), 
        .o_number_8 (sorted_col_41)
    );
    // Col 2
    bitonic_sort_9#(
        .WIDTH      (WIDTH)
    )col2(
        // Input
        .i_number_0 (8'd0), 
        .i_number_1 (8'd0), 
        .i_number_2 (8'd0), 
        .i_number_3 (8'd0), 
        .i_number_4 (i_pixel_02), 
        .i_number_5 (i_pixel_12), 
        .i_number_6 (i_pixel_22), 
        .i_number_7 (i_pixel_32), 
        .i_number_8 (i_pixel_42),
        // Output
        .o_number_0 (), 
        .o_number_1 (), 
        .o_number_2 (), 
        .o_number_3 (), 
        .o_number_4 (sorted_col_02),
        .o_number_5 (sorted_col_12), 
        .o_number_6 (sorted_col_22), 
        .o_number_7 (sorted_col_32), 
        .o_number_8 (sorted_col_42)
    );
    // Col 3
    bitonic_sort_9#(
        .WIDTH      (WIDTH)
    )col3(
        // Input
        .i_number_0 (8'd0), 
        .i_number_1 (8'd0), 
        .i_number_2 (8'd0), 
        .i_number_3 (8'd0), 
        .i_number_4 (i_pixel_03), 
        .i_number_5 (i_pixel_13), 
        .i_number_6 (i_pixel_23), 
        .i_number_7 (i_pixel_33), 
        .i_number_8 (i_pixel_43),
        // Output
        .o_number_0 (), 
        .o_number_1 (), 
        .o_number_2 (), 
        .o_number_3 (), 
        .o_number_4 (sorted_col_03),
        .o_number_5 (sorted_col_13), 
        .o_number_6 (sorted_col_23), 
        .o_number_7 (sorted_col_33), 
        .o_number_8 (sorted_col_43)
    );
    // Col 4 
    bitonic_sort_9#(
        .WIDTH      (WIDTH)
    )col4(
        // Input
        .i_number_0 (8'd0), 
        .i_number_1 (8'd0), 
        .i_number_2 (8'd0), 
        .i_number_3 (8'd0), 
        .i_number_4 (i_pixel_04), 
        .i_number_5 (i_pixel_14), 
        .i_number_6 (i_pixel_24), 
        .i_number_7 (i_pixel_34), 
        .i_number_8 (i_pixel_44),
        // Output
        .o_number_0 (), 
        .o_number_1 (), 
        .o_number_2 (), 
        .o_number_3 (), 
        .o_number_4 (sorted_col_04),
        .o_number_5 (sorted_col_14), 
        .o_number_6 (sorted_col_24), 
        .o_number_7 (sorted_col_34), 
        .o_number_8 (sorted_col_44)
    );

    /////////////////////////////////////////////////////////////////
    ///////                 SORT EACH COLUMN                ///////
    /////////////////////////////////////////////////////////////////
    // Row 0
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row0(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (8'd0), 
       .i_number_3 (8'd0), 
       .i_number_4 (sorted_col_00), 
       .i_number_5 (sorted_col_01), 
       .i_number_6 (sorted_col_02), 
       .i_number_7 (sorted_col_03), 
       .i_number_8 (sorted_col_04),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (), 
       .o_number_3 (), 
       .o_number_4 (sorted_row_00),
       .o_number_5 (sorted_row_01), 
       .o_number_6 (sorted_row_02), 
       .o_number_7 (sorted_row_03), 
       .o_number_8 (sorted_row_04)
    );
    // Row 1
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row1(
        // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (8'd0), 
       .i_number_3 (8'd0), 
       .i_number_4 (sorted_col_10), 
       .i_number_5 (sorted_col_11), 
       .i_number_6 (sorted_col_12), 
       .i_number_7 (sorted_col_13), 
       .i_number_8 (sorted_col_14),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (), 
       .o_number_3 (), 
       .o_number_4 (sorted_row_10),
       .o_number_5 (sorted_row_11), 
       .o_number_6 (sorted_row_12), 
       .o_number_7 (sorted_row_13), 
       .o_number_8 (sorted_row_14)
    );
    // Row 2
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row2(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (8'd0), 
       .i_number_3 (8'd0), 
       .i_number_4 (sorted_col_20), 
       .i_number_5 (sorted_col_21), 
       .i_number_6 (sorted_col_22), 
       .i_number_7 (sorted_col_23), 
       .i_number_8 (sorted_col_24),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (), 
       .o_number_3 (), 
       .o_number_4 (sorted_row_20),
       .o_number_5 (sorted_row_21), 
       .o_number_6 (sorted_row_22), 
       .o_number_7 (sorted_row_23), 
       .o_number_8 (sorted_row_24)
    );
    // Row 3
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row3(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (8'd0), 
       .i_number_3 (8'd0), 
       .i_number_4 (sorted_col_30), 
       .i_number_5 (sorted_col_31), 
       .i_number_6 (sorted_col_32), 
       .i_number_7 (sorted_col_33), 
       .i_number_8 (sorted_col_34),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (), 
       .o_number_3 (), 
       .o_number_4 (sorted_row_30),
       .o_number_5 (sorted_row_31), 
       .o_number_6 (sorted_row_32), 
       .o_number_7 (sorted_row_33), 
       .o_number_8 (sorted_row_34)
    );
    // Row 4
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row4(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (8'd0), 
       .i_number_3 (8'd0), 
       .i_number_4 (sorted_col_40), 
       .i_number_5 (sorted_col_41), 
       .i_number_6 (sorted_col_42), 
       .i_number_7 (sorted_col_43), 
       .i_number_8 (sorted_col_44),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (), 
       .o_number_3 (), 
       .o_number_4 (sorted_row_40),
       .o_number_5 (sorted_row_41), 
       .o_number_6 (sorted_row_42), 
       .o_number_7 (sorted_row_43), 
       .o_number_8 (sorted_row_44)
    );

    /////////////////////////////////////////////////////////////
    ///////                 SORT 45 DEGREE                ///////
    /////////////////////////////////////////////////////////////
    // Diagonal 0
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )diagonal0(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (8'd0), 
       .i_number_3 (8'd0), 
       .i_number_4 (8'd0), 
       .i_number_5 (sorted_row_03), 
       .i_number_6 (sorted_row_12), 
       .i_number_7 (sorted_row_21), 
       .i_number_8 (sorted_row_30),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (), 
       .o_number_3 (), 
       .o_number_4 (),
       .o_number_5 (diagonal_00), 
       .o_number_6 (diagonal_01), 
       .o_number_7 (diagonal_02), 
       .o_number_8 (diagonal_03)
    ); 
    // Diagonal 1
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )diagonal1(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (8'd0), 
       .i_number_3 (8'd0), 
       .i_number_4 (sorted_row_04), 
       .i_number_5 (sorted_row_13), 
       .i_number_6 (sorted_row_22), 
       .i_number_7 (sorted_row_31), 
       .i_number_8 (sorted_row_40),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (), 
       .o_number_3 (), 
       .o_number_4 (diagonal_10),
       .o_number_5 (diagonal_11), 
       .o_number_6 (diagonal_12), 
       .o_number_7 (diagonal_13), 
       .o_number_8 (diagonal_14)
    );
    // Diagonal 2
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )diagonal2(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (8'd0), 
       .i_number_3 (8'd0), 
       .i_number_4 (8'd0), 
       .i_number_5 (sorted_row_14), 
       .i_number_6 (sorted_row_23), 
       .i_number_7 (sorted_row_32), 
       .i_number_8 (sorted_row_41),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (), 
       .o_number_3 (), 
       .o_number_4 (),
       .o_number_5 (diagonal_20), 
       .o_number_6 (diagonal_21), 
       .o_number_7 (diagonal_22), 
       .o_number_8 (diagonal_23)
    );

    ///////////////////////////////////////////////////////////////////////
    ///////                 SORT 3 DIAGONAL ELEMENTS                ///////
    ///////////////////////////////////////////////////////////////////////
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )sort(
        // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (8'd0), 
       .i_number_3 (8'd0), 
       .i_number_4 (8'd0), 
       .i_number_5 (8'd0), 
       .i_number_6 (diagonal_20), 
       .i_number_7 (diagonal_12), 
       .i_number_8 (diagonal_03),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (), 
       .o_number_3 (), 
       .o_number_4 (),
       .o_number_5 (), 
       .o_number_6 (), 
       .o_number_7 (diagonal_center), 
       .o_number_8 ()
    ); 

    ////////////////////////////////////////////////////////////
    ///////                 GET RESULT                 ///////
    ////////////////////////////////////////////////////////////
    assign o_value_median = (i_enable_5x5) ? diagonal_center : o_value_median; 

endmodule