module median_filter_7 #(
    parameter WIDTH = 8                                                                                                     // Size of each cellparameter WIDTH = 9
) (
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
    // Clock & reset 
    input logic i_clk,                                                                                                      // Global clock 
    input logic i_rst,                                                                                                      // Global resset 
    // Input
    input logic             i_enable_7x7,                                                                                   // Enable computing of median filter 7x7 and step 5x5                    
    input logic [WIDTH-1:0] i_pixel_00, i_pixel_01, i_pixel_02, i_pixel_03, i_pixel_04, i_pixel_05, i_pixel_06,             // Row 0
    input logic [WIDTH-1:0] i_pixel_10, i_pixel_11, i_pixel_12, i_pixel_13, i_pixel_14, i_pixel_15, i_pixel_16,             // Row 1 
    input logic [WIDTH-1:0] i_pixel_20, i_pixel_21, i_pixel_22, i_pixel_23, i_pixel_24, i_pixel_25, i_pixel_26,             // Row 2
    input logic [WIDTH-1:0] i_pixel_30, i_pixel_31, i_pixel_32, i_pixel_33, i_pixel_34, i_pixel_35, i_pixel_36,             // Row 3  
    input logic [WIDTH-1:0] i_pixel_40, i_pixel_41, i_pixel_42, i_pixel_43, i_pixel_44, i_pixel_45, i_pixel_46,             // Row 4 
    input logic [WIDTH-1:0] i_pixel_50, i_pixel_51, i_pixel_52, i_pixel_53, i_pixel_54, i_pixel_55, i_pixel_56,             // Row 5 
    input logic [WIDTH-1:0] i_pixel_60, i_pixel_61, i_pixel_62, i_pixel_63, i_pixel_64, i_pixel_65, i_pixel_66,             // Row 6 
    
    ////////////////////////////////////////////////////////////////
    ///////                 OUTPUT OF MODULE                 ///////
    ////////////////////////////////////////////////////////////////
    output logic [WIDTH-1:0] o_value_median                                                                                 // Median pixel of filter 7x7
);
    ////////////////////////////////////////////////////////
    ///////                 VARIABLE                 /////// 
    ////////////////////////////////////////////////////////
    // Enable signal for sort in matrix 5x5 
    logic             enable_5x5; 
    // Sort col output signal 
    logic [WIDTH-1:0] sorted_col_00, sorted_col_01, sorted_col_02, sorted_col_03, sorted_col_04, sorted_col_05, sorted_col_06;
    logic [WIDTH-1:0] sorted_col_10, sorted_col_11, sorted_col_12, sorted_col_13, sorted_col_14, sorted_col_15, sorted_col_16;
    logic [WIDTH-1:0] sorted_col_20, sorted_col_21, sorted_col_22, sorted_col_23, sorted_col_24, sorted_col_25, sorted_col_26;
    logic [WIDTH-1:0] sorted_col_30, sorted_col_31, sorted_col_32, sorted_col_33, sorted_col_34, sorted_col_35, sorted_col_36;
    logic [WIDTH-1:0] sorted_col_40, sorted_col_41, sorted_col_42, sorted_col_43, sorted_col_44, sorted_col_45, sorted_col_46;
    logic [WIDTH-1:0] sorted_col_50, sorted_col_51, sorted_col_52, sorted_col_53, sorted_col_54, sorted_col_55, sorted_col_56;
    logic [WIDTH-1:0] sorted_col_60, sorted_col_61, sorted_col_62, sorted_col_63, sorted_col_64, sorted_col_65, sorted_col_66;

    // Sort row output signal 
    logic [WIDTH-1:0] sorted_row_00, sorted_row_01, sorted_row_02, sorted_row_03, sorted_row_04, sorted_row_05, sorted_row_06;
    logic [WIDTH-1:0] sorted_row_10, sorted_row_11, sorted_row_12, sorted_row_13, sorted_row_14, sorted_row_15, sorted_row_16;
    logic [WIDTH-1:0] sorted_row_20, sorted_row_21, sorted_row_22, sorted_row_23, sorted_row_24, sorted_row_25, sorted_row_26;
    logic [WIDTH-1:0] sorted_row_30, sorted_row_31, sorted_row_32, sorted_row_33, sorted_row_34, sorted_row_35, sorted_row_36;
    logic [WIDTH-1:0] sorted_row_40, sorted_row_41, sorted_row_42, sorted_row_43, sorted_row_44, sorted_row_45, sorted_row_46;
    logic [WIDTH-1:0] sorted_row_50, sorted_row_51, sorted_row_52, sorted_row_53, sorted_row_54, sorted_row_55, sorted_row_56;
    logic [WIDTH-1:0] sorted_row_60, sorted_row_61, sorted_row_62, sorted_row_63, sorted_row_64, sorted_row_65, sorted_row_66;

    // Sort upper and lower corner signal
    logic [WIDTH-1:0] sorted_upper_00, sorted_upper_01, sorted_upper_02; 
    logic [WIDTH-1:0] sorted_lower_00, sorted_lower_01, sorted_lower_02;

    // Register reduction dimesion to 5x5
    logic [WIDTH-1:0] i_me5_00, i_me5_01, i_me5_02, i_me5_03, i_me5_04; 
    logic [WIDTH-1:0] i_me5_10, i_me5_11, i_me5_12, i_me5_13, i_me5_14;
    logic [WIDTH-1:0] i_me5_20, i_me5_21, i_me5_22, i_me5_23, i_me5_24;
    logic [WIDTH-1:0] i_me5_30, i_me5_31, i_me5_32, i_me5_33, i_me5_34;
    logic [WIDTH-1:0] i_me5_40, i_me5_41, i_me5_42, i_me5_43, i_me5_44;
    ////////////////////////////////////////////////////////////////
    ///////                 SORT EACH COLUMNS                ///////
    ////////////////////////////////////////////////////////////////
    // Col 0
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )col0(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (i_pixel_00), 
       .i_number_3 (i_pixel_10), 
       .i_number_4 (i_pixel_20), 
       .i_number_5 (i_pixel_30), 
       .i_number_6 (i_pixel_40), 
       .i_number_7 (i_pixel_50), 
       .i_number_8 (i_pixel_60),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (sorted_col_00), 
       .o_number_3 (sorted_col_10), 
       .o_number_4 (sorted_col_20),
       .o_number_5 (sorted_col_30), 
       .o_number_6 (sorted_col_40), 
       .o_number_7 (sorted_col_50), 
       .o_number_8 (sorted_col_60)
    ); 
    // Col 1
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )col1(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (i_pixel_01), 
       .i_number_3 (i_pixel_11), 
       .i_number_4 (i_pixel_21), 
       .i_number_5 (i_pixel_31), 
       .i_number_6 (i_pixel_41), 
       .i_number_7 (i_pixel_51), 
       .i_number_8 (i_pixel_61),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (sorted_col_01), 
       .o_number_3 (sorted_col_11), 
       .o_number_4 (sorted_col_21),
       .o_number_5 (sorted_col_31), 
       .o_number_6 (sorted_col_41), 
       .o_number_7 (sorted_col_51), 
       .o_number_8 (sorted_col_61)
    );
    // Col 2
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )col2(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (i_pixel_02), 
       .i_number_3 (i_pixel_12), 
       .i_number_4 (i_pixel_22), 
       .i_number_5 (i_pixel_32), 
       .i_number_6 (i_pixel_42), 
       .i_number_7 (i_pixel_52), 
       .i_number_8 (i_pixel_62),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (sorted_col_02), 
       .o_number_3 (sorted_col_12), 
       .o_number_4 (sorted_col_22),
       .o_number_5 (sorted_col_32), 
       .o_number_6 (sorted_col_42), 
       .o_number_7 (sorted_col_52), 
       .o_number_8 (sorted_col_62)
    );
    // Col 3
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )col3(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (i_pixel_03), 
       .i_number_3 (i_pixel_13), 
       .i_number_4 (i_pixel_23), 
       .i_number_5 (i_pixel_33), 
       .i_number_6 (i_pixel_43), 
       .i_number_7 (i_pixel_53), 
       .i_number_8 (i_pixel_63),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (sorted_col_03), 
       .o_number_3 (sorted_col_13), 
       .o_number_4 (sorted_col_23),
       .o_number_5 (sorted_col_33), 
       .o_number_6 (sorted_col_43), 
       .o_number_7 (sorted_col_53), 
       .o_number_8 (sorted_col_63)
    );
    // Col 4
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )col4(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (i_pixel_04), 
       .i_number_3 (i_pixel_14), 
       .i_number_4 (i_pixel_24), 
       .i_number_5 (i_pixel_34), 
       .i_number_6 (i_pixel_44), 
       .i_number_7 (i_pixel_54), 
       .i_number_8 (i_pixel_64),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (sorted_col_04), 
       .o_number_3 (sorted_col_14), 
       .o_number_4 (sorted_col_24),
       .o_number_5 (sorted_col_34), 
       .o_number_6 (sorted_col_44), 
       .o_number_7 (sorted_col_54), 
       .o_number_8 (sorted_col_64)
    );
    // Col 5
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )col5(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (i_pixel_05), 
       .i_number_3 (i_pixel_15), 
       .i_number_4 (i_pixel_25), 
       .i_number_5 (i_pixel_35), 
       .i_number_6 (i_pixel_45), 
       .i_number_7 (i_pixel_55), 
       .i_number_8 (i_pixel_65),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (sorted_col_05), 
       .o_number_3 (sorted_col_15), 
       .o_number_4 (sorted_col_25),
       .o_number_5 (sorted_col_35), 
       .o_number_6 (sorted_col_45), 
       .o_number_7 (sorted_col_55), 
       .o_number_8 (sorted_col_65)
    );
    // Col 6
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )col6(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (i_pixel_06), 
       .i_number_3 (i_pixel_16), 
       .i_number_4 (i_pixel_26), 
       .i_number_5 (i_pixel_36), 
       .i_number_6 (i_pixel_46), 
       .i_number_7 (i_pixel_56), 
       .i_number_8 (i_pixel_66),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (sorted_col_06), 
       .o_number_3 (sorted_col_16), 
       .o_number_4 (sorted_col_26),
       .o_number_5 (sorted_col_36), 
       .o_number_6 (sorted_col_46), 
       .o_number_7 (sorted_col_56), 
       .o_number_8 (sorted_col_66)
    );
    ////////////////////////////////////////////////////////////
    ///////                 SORT EACH ROW                ///////
    ////////////////////////////////////////////////////////////
    // Row 0
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row0(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (sorted_col_00), 
       .i_number_3 (sorted_col_01), 
       .i_number_4 (sorted_col_02), 
       .i_number_5 (sorted_col_03), 
       .i_number_6 (sorted_col_04), 
       .i_number_7 (sorted_col_05), 
       .i_number_8 (sorted_col_06),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (sorted_row_00), 
       .o_number_3 (sorted_row_01), 
       .o_number_4 (sorted_row_02),
       .o_number_5 (sorted_row_03), 
       .o_number_6 (sorted_row_04), 
       .o_number_7 (sorted_row_05), 
       .o_number_8 (sorted_row_06)
    );
    // Row 1
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row1(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (sorted_col_10), 
       .i_number_3 (sorted_col_11), 
       .i_number_4 (sorted_col_12), 
       .i_number_5 (sorted_col_13), 
       .i_number_6 (sorted_col_14), 
       .i_number_7 (sorted_col_15), 
       .i_number_8 (sorted_col_16),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (sorted_row_10), 
       .o_number_3 (sorted_row_11), 
       .o_number_4 (sorted_row_12),
       .o_number_5 (sorted_row_13), 
       .o_number_6 (sorted_row_14), 
       .o_number_7 (sorted_row_15), 
       .o_number_8 (sorted_row_16)
    );
    // Row 2
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row2(
        // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (sorted_col_20), 
       .i_number_3 (sorted_col_21), 
       .i_number_4 (sorted_col_22), 
       .i_number_5 (sorted_col_23), 
       .i_number_6 (sorted_col_24), 
       .i_number_7 (sorted_col_25), 
       .i_number_8 (sorted_col_26),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (sorted_row_20), 
       .o_number_3 (sorted_row_21), 
       .o_number_4 (sorted_row_22),
       .o_number_5 (sorted_row_23), 
       .o_number_6 (sorted_row_24), 
       .o_number_7 (sorted_row_25), 
       .o_number_8 (sorted_row_26)
    );
    // Row 3
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row3(
        // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (sorted_col_30), 
       .i_number_3 (sorted_col_31), 
       .i_number_4 (sorted_col_32), 
       .i_number_5 (sorted_col_33), 
       .i_number_6 (sorted_col_34), 
       .i_number_7 (sorted_col_35), 
       .i_number_8 (sorted_col_36),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (sorted_row_30), 
       .o_number_3 (sorted_row_31), 
       .o_number_4 (sorted_row_32),
       .o_number_5 (sorted_row_33), 
       .o_number_6 (sorted_row_34), 
       .o_number_7 (sorted_row_35), 
       .o_number_8 (sorted_row_36)
    );
    // Row 4
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row4(
        // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (sorted_col_40), 
       .i_number_3 (sorted_col_41), 
       .i_number_4 (sorted_col_42), 
       .i_number_5 (sorted_col_43), 
       .i_number_6 (sorted_col_44), 
       .i_number_7 (sorted_col_45), 
       .i_number_8 (sorted_col_46),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (sorted_row_40), 
       .o_number_3 (sorted_row_41), 
       .o_number_4 (sorted_row_42),
       .o_number_5 (sorted_row_43), 
       .o_number_6 (sorted_row_44), 
       .o_number_7 (sorted_row_45), 
       .o_number_8 (sorted_row_46)
    );
    // Row 5
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row5(
        // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (sorted_col_50), 
       .i_number_3 (sorted_col_51), 
       .i_number_4 (sorted_col_52), 
       .i_number_5 (sorted_col_53), 
       .i_number_6 (sorted_col_54), 
       .i_number_7 (sorted_col_55), 
       .i_number_8 (sorted_col_56),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (sorted_row_50), 
       .o_number_3 (sorted_row_51), 
       .o_number_4 (sorted_row_52),
       .o_number_5 (sorted_row_53), 
       .o_number_6 (sorted_row_54), 
       .o_number_7 (sorted_row_55), 
       .o_number_8 (sorted_row_56)
    );
    // Row 6
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row6(
        // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (sorted_col_60), 
       .i_number_3 (sorted_col_61), 
       .i_number_4 (sorted_col_62), 
       .i_number_5 (sorted_col_63), 
       .i_number_6 (sorted_col_64), 
       .i_number_7 (sorted_col_65), 
       .i_number_8 (sorted_col_66),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (sorted_row_60), 
       .o_number_3 (sorted_row_61), 
       .o_number_4 (sorted_row_62),
       .o_number_5 (sorted_row_63), 
       .o_number_6 (sorted_row_64), 
       .o_number_7 (sorted_row_65), 
       .o_number_8 (sorted_row_66)
    );
    /////////////////////////////////////////////////////////////
    ///////                 SORT 45 DEGREE                ///////
    /////////////////////////////////////////////////////////////
    // Upper corner
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )upper(
       // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (8'd0), 
       .i_number_3 (8'd0), 
       .i_number_4 (8'd0), 
       .i_number_5 (8'd0), 
       .i_number_6 (sorted_row_04), 
       .i_number_7 (sorted_row_13), 
       .i_number_8 (sorted_row_22),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (), 
       .o_number_3 (), 
       .o_number_4 (),
       .o_number_5 (), 
       .o_number_6 (sorted_upper_00), 
       .o_number_7 (sorted_upper_01), 
       .o_number_8 (sorted_upper_02)
    ); 
    // Lower corner
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )lower(
        // Input
       .i_number_0 (8'd0), 
       .i_number_1 (8'd0), 
       .i_number_2 (8'd0), 
       .i_number_3 (8'd0), 
       .i_number_4 (8'd0), 
       .i_number_5 (8'd0), 
       .i_number_6 (sorted_row_44), 
       .i_number_7 (sorted_row_53), 
       .i_number_8 (sorted_row_62),
       // Output
       .o_number_0 (), 
       .o_number_1 (), 
       .o_number_2 (), 
       .o_number_3 (), 
       .o_number_4 (),
       .o_number_5 (), 
       .o_number_6 (sorted_lower_00), 
       .o_number_7 (sorted_lower_01), 
       .o_number_8 (sorted_lower_02)
    ); 
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////                 PIPELINE FOR STEPS THAT REDUCE THE DIMENSION                ///////
    ///////////////////////////////////////////////////////////////////////////////////////////
    always_ff @( posedge i_clk or posedge i_rst) begin 
       if (i_rst) begin
           i_me5_00 <= 'd0; 
           i_me5_01 <= 'd0; 
           i_me5_02 <= 'd0; 
           i_me5_03 <= 'd0; 
           i_me5_04 <= 'd0; 

           i_me5_10 <= 'd0; 
           i_me5_11 <= 'd0; 
           i_me5_12 <= 'd0; 
           i_me5_13 <= 'd0; 
           i_me5_14 <= 'd0;

           i_me5_20 <= 'd0; 
           i_me5_21 <= 'd0; 
           i_me5_22 <= 'd0; 
           i_me5_23 <= 'd0; 
           i_me5_24 <= 'd0;

           i_me5_30 <= 'd0; 
           i_me5_31 <= 'd0; 
           i_me5_32 <= 'd0; 
           i_me5_33 <= 'd0; 
           i_me5_34 <= 'd0;

           i_me5_40 <= 'd0; 
           i_me5_41 <= 'd0; 
           i_me5_42 <= 'd0; 
           i_me5_43 <= 'd0; 
           i_me5_44 <= 'd0;
       end else if (i_enable_7x7) begin
           i_me5_00 <= sorted_row_05;
           i_me5_01 <= sorted_row_06;
           i_me5_02 <= sorted_row_14;
           i_me5_03 <= sorted_row_15;
           i_me5_04 <= sorted_row_16;

           i_me5_10 <= sorted_upper_02;
           i_me5_11 <= sorted_row_23;
           i_me5_12 <= sorted_row_24;
           i_me5_13 <= sorted_row_25;
           i_me5_14 <= sorted_row_26;

           i_me5_20 <= sorted_row_31;
           i_me5_21 <= sorted_row_32;
           i_me5_22 <= sorted_row_33;
           i_me5_23 <= sorted_row_34;
           i_me5_24 <= sorted_row_35;

           i_me5_30 <= sorted_row_40;
           i_me5_31 <= sorted_row_41;
           i_me5_32 <= sorted_row_42;
           i_me5_33 <= sorted_row_43;
           i_me5_34 <= sorted_lower_00;

           i_me5_40 <= sorted_row_50;
           i_me5_41 <= sorted_row_51;
           i_me5_42 <= sorted_row_52;
           i_me5_43 <= sorted_row_60;
           i_me5_44 <= sorted_row_61;
       end
    end

    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            enable_5x5 <= 1'b0;
        end else begin
            enable_5x5 <= i_enable_7x7; 
        end
    end

    ///////////////////////////////////////////////////////////////////
    ///////                 SORT WITH MATRIX 5X5                ///////
    ///////////////////////////////////////////////////////////////////
    median_filter_5#(
        .WIDTH          (WIDTH)
    )matrix5(       
        .i_enable_5x5   (enable_5x5), 

        .i_pixel_00     (i_me5_00),
        .i_pixel_01     (i_me5_01),
        .i_pixel_02     (i_me5_02),
        .i_pixel_03     (i_me5_03),
        .i_pixel_04     (i_me5_04),

        .i_pixel_10     (i_me5_10),
        .i_pixel_11     (i_me5_11),
        .i_pixel_12     (i_me5_12),
        .i_pixel_13     (i_me5_13),
        .i_pixel_14     (i_me5_14),

        .i_pixel_20     (i_me5_20),
        .i_pixel_21     (i_me5_21),
        .i_pixel_22     (i_me5_22),
        .i_pixel_23     (i_me5_23),
        .i_pixel_24     (i_me5_24),

        .i_pixel_30     (i_me5_30),
        .i_pixel_31     (i_me5_31),
        .i_pixel_32     (i_me5_32),
        .i_pixel_33     (i_me5_33),
        .i_pixel_34     (i_me5_34),

        .i_pixel_40     (i_me5_40),
        .i_pixel_41     (i_me5_41),
        .i_pixel_42     (i_me5_42),
        .i_pixel_43     (i_me5_43),
        .i_pixel_44     (i_me5_44),

        .o_value_median (o_value_median)
    );  
endmodule