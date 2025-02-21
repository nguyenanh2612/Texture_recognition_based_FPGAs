module median_filter_9 #(
    parameter WIDTH = 8                                                                                                                                                      // Size of each cellparameter WIDTH = 9
) (
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
    // Clock & resetGlobal 
    input logic i_clk,                                                                                                                                                       // Global clock 
    input logic i_rst,                                                                                                                                                       // Global reset
    // Input 
    input logic             i_enable_9x9,                                                                                                                                    // Enable computing of median filter 9x9 and step 7x7                              
    input logic [WIDTH-1:0] i_pixel_00, i_pixel_01, i_pixel_02, i_pixel_03, i_pixel_04, i_pixel_05, i_pixel_06, i_pixel_07, i_pixel_08,                                      // Row 0 
    input logic [WIDTH-1:0] i_pixel_10, i_pixel_11, i_pixel_12, i_pixel_13, i_pixel_14, i_pixel_15, i_pixel_16, i_pixel_17, i_pixel_18,                                      // Row 1 
    input logic [WIDTH-1:0] i_pixel_20, i_pixel_21, i_pixel_22, i_pixel_23, i_pixel_24, i_pixel_25, i_pixel_26, i_pixel_27, i_pixel_28,                                      // Row 2 
    input logic [WIDTH-1:0] i_pixel_30, i_pixel_31, i_pixel_32, i_pixel_33, i_pixel_34, i_pixel_35, i_pixel_36, i_pixel_37, i_pixel_38,                                      // Row 3 
    input logic [WIDTH-1:0] i_pixel_40, i_pixel_41, i_pixel_42, i_pixel_43, i_pixel_44, i_pixel_45, i_pixel_46, i_pixel_47, i_pixel_48,                                      // Row 4 
    input logic [WIDTH-1:0] i_pixel_50, i_pixel_51, i_pixel_52, i_pixel_53, i_pixel_54, i_pixel_55, i_pixel_56, i_pixel_57, i_pixel_58,                                      // Row 5 
    input logic [WIDTH-1:0] i_pixel_60, i_pixel_61, i_pixel_62, i_pixel_63, i_pixel_64, i_pixel_65, i_pixel_66, i_pixel_67, i_pixel_68,                                      // Row 6 
    input logic [WIDTH-1:0] i_pixel_70, i_pixel_71, i_pixel_72, i_pixel_73, i_pixel_74, i_pixel_75, i_pixel_76, i_pixel_77, i_pixel_78,                                      // Row 7 
    input logic [WIDTH-1:0] i_pixel_80, i_pixel_81, i_pixel_82, i_pixel_83, i_pixel_84, i_pixel_85, i_pixel_86, i_pixel_87, i_pixel_88,                                      // Row 8 
    
    ////////////////////////////////////////////////////////////////
    ///////                 OUTPUT OF MODULE                 ///////
    ////////////////////////////////////////////////////////////////
    output logic [WIDTH-1:0] o_value_median                                                                                                                                  // Median pixel of filter 9x9 
);
    ////////////////////////////////////////////////////////
    ///////                 VARIABLE                 /////// 
    ////////////////////////////////////////////////////////
    // Enable syn with data
    logic             enable_9x9_syn_with_data; 
    // Sorted col output signals
    logic [WIDTH-1:0] sorted_col_00, sorted_col_01, sorted_col_02, sorted_col_03, sorted_col_04, sorted_col_05, sorted_col_06, sorted_col_07, sorted_col_08; 
    logic [WIDTH-1:0] sorted_col_10, sorted_col_11, sorted_col_12, sorted_col_13, sorted_col_14, sorted_col_15, sorted_col_16, sorted_col_17, sorted_col_18; 
    logic [WIDTH-1:0] sorted_col_20, sorted_col_21, sorted_col_22, sorted_col_23, sorted_col_24, sorted_col_25, sorted_col_26, sorted_col_27, sorted_col_28; 
    logic [WIDTH-1:0] sorted_col_30, sorted_col_31, sorted_col_32, sorted_col_33, sorted_col_34, sorted_col_35, sorted_col_36, sorted_col_37, sorted_col_38; 
    logic [WIDTH-1:0] sorted_col_40, sorted_col_41, sorted_col_42, sorted_col_43, sorted_col_44, sorted_col_45, sorted_col_46, sorted_col_47, sorted_col_48; 
    logic [WIDTH-1:0] sorted_col_50, sorted_col_51, sorted_col_52, sorted_col_53, sorted_col_54, sorted_col_55, sorted_col_56, sorted_col_57, sorted_col_58; 
    logic [WIDTH-1:0] sorted_col_60, sorted_col_61, sorted_col_62, sorted_col_63, sorted_col_64, sorted_col_65, sorted_col_66, sorted_col_67, sorted_col_68; 
    logic [WIDTH-1:0] sorted_col_70, sorted_col_71, sorted_col_72, sorted_col_73, sorted_col_74, sorted_col_75, sorted_col_76, sorted_col_77, sorted_col_78; 
    logic [WIDTH-1:0] sorted_col_80, sorted_col_81, sorted_col_82, sorted_col_83, sorted_col_84, sorted_col_85, sorted_col_86, sorted_col_87, sorted_col_88;
    
    // Sorted row output signals
    logic [WIDTH-1:0] sorted_row_00, sorted_row_01, sorted_row_02, sorted_row_03, sorted_row_04, sorted_row_05, sorted_row_06, sorted_row_07, sorted_row_08; 
    logic [WIDTH-1:0] sorted_row_10, sorted_row_11, sorted_row_12, sorted_row_13, sorted_row_14, sorted_row_15, sorted_row_16, sorted_row_17, sorted_row_18; 
    logic [WIDTH-1:0] sorted_row_20, sorted_row_21, sorted_row_22, sorted_row_23, sorted_row_24, sorted_row_25, sorted_row_26, sorted_row_27, sorted_row_28; 
    logic [WIDTH-1:0] sorted_row_30, sorted_row_31, sorted_row_32, sorted_row_33, sorted_row_34, sorted_row_35, sorted_row_36, sorted_row_37, sorted_row_38; 
    logic [WIDTH-1:0] sorted_row_40, sorted_row_41, sorted_row_42, sorted_row_43, sorted_row_44, sorted_row_45, sorted_row_46, sorted_row_47, sorted_row_48; 
    logic [WIDTH-1:0] sorted_row_50, sorted_row_51, sorted_row_52, sorted_row_53, sorted_row_54, sorted_row_55, sorted_row_56, sorted_row_57, sorted_row_58; 
    logic [WIDTH-1:0] sorted_row_60, sorted_row_61, sorted_row_62, sorted_row_63, sorted_row_64, sorted_row_65, sorted_row_66, sorted_row_67, sorted_row_68; 
    logic [WIDTH-1:0] sorted_row_70, sorted_row_71, sorted_row_72, sorted_row_73, sorted_row_74, sorted_row_75, sorted_row_76, sorted_row_77, sorted_row_78; 
    logic [WIDTH-1:0] sorted_row_80, sorted_row_81, sorted_row_82, sorted_row_83, sorted_row_84, sorted_row_85, sorted_row_86, sorted_row_87, sorted_row_88;

    // Sorted upper and lower corners
    logic [WIDTH-1:0] sorted_upper_00, sorted_upper_01, sorted_upper_02; 
    logic [WIDTH-1:0] sorted_lower_00, sorted_lower_01, sorted_lower_02; 

    // Reduce dimension to matrix 7x7 
    logic [WIDTH-1:0] i_rd7_00, i_rd7_01, i_rd7_02, i_rd7_03, i_rd7_04, i_rd7_05, i_rd7_06;
    logic [WIDTH-1:0] i_rd7_10, i_rd7_11, i_rd7_12, i_rd7_13, i_rd7_14, i_rd7_15, i_rd7_16;
    logic [WIDTH-1:0] i_rd7_20, i_rd7_21, i_rd7_22, i_rd7_23, i_rd7_24, i_rd7_25, i_rd7_26;
    logic [WIDTH-1:0] i_rd7_30, i_rd7_31, i_rd7_32, i_rd7_33, i_rd7_34, i_rd7_35, i_rd7_36;
    logic [WIDTH-1:0] i_rd7_40, i_rd7_41, i_rd7_42, i_rd7_43, i_rd7_44, i_rd7_45, i_rd7_46;
    logic [WIDTH-1:0] i_rd7_50, i_rd7_51, i_rd7_52, i_rd7_53, i_rd7_54, i_rd7_55, i_rd7_56;
    logic [WIDTH-1:0] i_rd7_60, i_rd7_61, i_rd7_62, i_rd7_63, i_rd7_64, i_rd7_65, i_rd7_66;

    ////////////////////////////////////////////////////////////////
    ///////                 SORT EACH COLUMNS                ///////
    ////////////////////////////////////////////////////////////////
    // Col 0
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )col0(
        // Input
       .i_number_0 (i_pixel_00), 
       .i_number_1 (i_pixel_10), 
       .i_number_2 (i_pixel_20), 
       .i_number_3 (i_pixel_30), 
       .i_number_4 (i_pixel_40), 
       .i_number_5 (i_pixel_50), 
       .i_number_6 (i_pixel_60), 
       .i_number_7 (i_pixel_70), 
       .i_number_8 (i_pixel_80),
       // Output
       .o_number_0 (sorted_col_00), 
       .o_number_1 (sorted_col_10), 
       .o_number_2 (sorted_col_20), 
       .o_number_3 (sorted_col_30), 
       .o_number_4 (sorted_col_40),
       .o_number_5 (sorted_col_50), 
       .o_number_6 (sorted_col_60), 
       .o_number_7 (sorted_col_70), 
       .o_number_8 (sorted_col_80)
    );
    // Col 1
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    ) col1(
        // Input
       .i_number_0 (i_pixel_01), 
       .i_number_1 (i_pixel_11), 
       .i_number_2 (i_pixel_21), 
       .i_number_3 (i_pixel_31), 
       .i_number_4 (i_pixel_41), 
       .i_number_5 (i_pixel_51), 
       .i_number_6 (i_pixel_61), 
       .i_number_7 (i_pixel_71), 
       .i_number_8 (i_pixel_81),
       // Output
       .o_number_0 (sorted_col_01), 
       .o_number_1 (sorted_col_11), 
       .o_number_2 (sorted_col_21), 
       .o_number_3 (sorted_col_31), 
       .o_number_4 (sorted_col_41),
       .o_number_5 (sorted_col_51), 
       .o_number_6 (sorted_col_61), 
       .o_number_7 (sorted_col_71), 
       .o_number_8 (sorted_col_81)
    );
    // Col 2
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )col2(
        // Input
       .i_number_0 (i_pixel_02), 
       .i_number_1 (i_pixel_12), 
       .i_number_2 (i_pixel_22), 
       .i_number_3 (i_pixel_32), 
       .i_number_4 (i_pixel_42), 
       .i_number_5 (i_pixel_52), 
       .i_number_6 (i_pixel_62), 
       .i_number_7 (i_pixel_72), 
       .i_number_8 (i_pixel_82),
       // Output
       .o_number_0 (sorted_col_02), 
       .o_number_1 (sorted_col_12), 
       .o_number_2 (sorted_col_22), 
       .o_number_3 (sorted_col_32), 
       .o_number_4 (sorted_col_42),
       .o_number_5 (sorted_col_52), 
       .o_number_6 (sorted_col_62), 
       .o_number_7 (sorted_col_72), 
       .o_number_8 (sorted_col_82)
    );
    // Col 3
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )col3(
        // Input
       .i_number_0 (i_pixel_03), 
       .i_number_1 (i_pixel_13), 
       .i_number_2 (i_pixel_23), 
       .i_number_3 (i_pixel_33), 
       .i_number_4 (i_pixel_43), 
       .i_number_5 (i_pixel_53), 
       .i_number_6 (i_pixel_63), 
       .i_number_7 (i_pixel_73), 
       .i_number_8 (i_pixel_83),
       // Output
       .o_number_0 (sorted_col_03), 
       .o_number_1 (sorted_col_13), 
       .o_number_2 (sorted_col_23), 
       .o_number_3 (sorted_col_33), 
       .o_number_4 (sorted_col_43),
       .o_number_5 (sorted_col_53), 
       .o_number_6 (sorted_col_63), 
       .o_number_7 (sorted_col_73), 
       .o_number_8 (sorted_col_83)
    );
    // Col 4
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )col4(
       // Input
       .i_number_0 (i_pixel_04), 
       .i_number_1 (i_pixel_14), 
       .i_number_2 (i_pixel_24), 
       .i_number_3 (i_pixel_34), 
       .i_number_4 (i_pixel_44), 
       .i_number_5 (i_pixel_54), 
       .i_number_6 (i_pixel_64), 
       .i_number_7 (i_pixel_74), 
       .i_number_8 (i_pixel_84),
       // Output
       .o_number_0 (sorted_col_04), 
       .o_number_1 (sorted_col_14), 
       .o_number_2 (sorted_col_24), 
       .o_number_3 (sorted_col_34), 
       .o_number_4 (sorted_col_44),
       .o_number_5 (sorted_col_54), 
       .o_number_6 (sorted_col_64), 
       .o_number_7 (sorted_col_74), 
       .o_number_8 (sorted_col_84)
    );
    // Col 5
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )col5(
        // Input
       .i_number_0 (i_pixel_05), 
       .i_number_1 (i_pixel_15), 
       .i_number_2 (i_pixel_25), 
       .i_number_3 (i_pixel_35), 
       .i_number_4 (i_pixel_45), 
       .i_number_5 (i_pixel_55), 
       .i_number_6 (i_pixel_65), 
       .i_number_7 (i_pixel_75), 
       .i_number_8 (i_pixel_85),
       // Output
       .o_number_0 (sorted_col_05), 
       .o_number_1 (sorted_col_15), 
       .o_number_2 (sorted_col_25), 
       .o_number_3 (sorted_col_35), 
       .o_number_4 (sorted_col_45),
       .o_number_5 (sorted_col_55), 
       .o_number_6 (sorted_col_65), 
       .o_number_7 (sorted_col_75), 
       .o_number_8 (sorted_col_85)
    );
    // Col 6
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )col6(
        // Input
       .i_number_0 (i_pixel_06), 
       .i_number_1 (i_pixel_16), 
       .i_number_2 (i_pixel_26), 
       .i_number_3 (i_pixel_36), 
       .i_number_4 (i_pixel_46), 
       .i_number_5 (i_pixel_56), 
       .i_number_6 (i_pixel_66), 
       .i_number_7 (i_pixel_76), 
       .i_number_8 (i_pixel_86),
       // Output
       .o_number_0 (sorted_col_06), 
       .o_number_1 (sorted_col_16), 
       .o_number_2 (sorted_col_26), 
       .o_number_3 (sorted_col_36), 
       .o_number_4 (sorted_col_46),
       .o_number_5 (sorted_col_56), 
       .o_number_6 (sorted_col_66), 
       .o_number_7 (sorted_col_76), 
       .o_number_8 (sorted_col_86)
    );
    // Col 7
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )col7(
        // Input
       .i_number_0 (i_pixel_07), 
       .i_number_1 (i_pixel_17), 
       .i_number_2 (i_pixel_27), 
       .i_number_3 (i_pixel_37), 
       .i_number_4 (i_pixel_47), 
       .i_number_5 (i_pixel_57), 
       .i_number_6 (i_pixel_67), 
       .i_number_7 (i_pixel_77), 
       .i_number_8 (i_pixel_87),
       // Output
       .o_number_0 (sorted_col_07), 
       .o_number_1 (sorted_col_17), 
       .o_number_2 (sorted_col_27), 
       .o_number_3 (sorted_col_37), 
       .o_number_4 (sorted_col_47),
       .o_number_5 (sorted_col_57), 
       .o_number_6 (sorted_col_67), 
       .o_number_7 (sorted_col_77), 
       .o_number_8 (sorted_col_87)
    );
    // Col 5 
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )col8(
        // Input
       .i_number_0 (i_pixel_08), 
       .i_number_1 (i_pixel_18), 
       .i_number_2 (i_pixel_28), 
       .i_number_3 (i_pixel_38), 
       .i_number_4 (i_pixel_48), 
       .i_number_5 (i_pixel_58), 
       .i_number_6 (i_pixel_68), 
       .i_number_7 (i_pixel_78), 
       .i_number_8 (i_pixel_88),
       // Output
       .o_number_0 (sorted_col_08), 
       .o_number_1 (sorted_col_18), 
       .o_number_2 (sorted_col_28), 
       .o_number_3 (sorted_col_38), 
       .o_number_4 (sorted_col_48),
       .o_number_5 (sorted_col_58), 
       .o_number_6 (sorted_col_68), 
       .o_number_7 (sorted_col_78), 
       .o_number_8 (sorted_col_88)
    );

    ////////////////////////////////////////////////////////////
    ///////                 SORT EACH ROW                ///////
    ////////////////////////////////////////////////////////////
    // Row 0 
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row0(
        // Input
       .i_number_0 (sorted_col_00), 
       .i_number_1 (sorted_col_01), 
       .i_number_2 (sorted_col_02), 
       .i_number_3 (sorted_col_03), 
       .i_number_4 (sorted_col_04), 
       .i_number_5 (sorted_col_05), 
       .i_number_6 (sorted_col_06), 
       .i_number_7 (sorted_col_07), 
       .i_number_8 (sorted_col_08),
       // Output
       .o_number_0 (sorted_row_00), 
       .o_number_1 (sorted_row_01), 
       .o_number_2 (sorted_row_02), 
       .o_number_3 (sorted_row_03), 
       .o_number_4 (sorted_row_04),
       .o_number_5 (sorted_row_05), 
       .o_number_6 (sorted_row_06), 
       .o_number_7 (sorted_row_07), 
       .o_number_8 (sorted_row_08)
    ); 
    // Row 1 
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row1(
        // Input
       .i_number_0 (sorted_col_10), 
       .i_number_1 (sorted_col_11), 
       .i_number_2 (sorted_col_12), 
       .i_number_3 (sorted_col_13), 
       .i_number_4 (sorted_col_14), 
       .i_number_5 (sorted_col_15), 
       .i_number_6 (sorted_col_16), 
       .i_number_7 (sorted_col_17), 
       .i_number_8 (sorted_col_18),
       // Output
       .o_number_0 (sorted_row_10), 
       .o_number_1 (sorted_row_11), 
       .o_number_2 (sorted_row_12), 
       .o_number_3 (sorted_row_13), 
       .o_number_4 (sorted_row_14),
       .o_number_5 (sorted_row_15), 
       .o_number_6 (sorted_row_16), 
       .o_number_7 (sorted_row_17), 
       .o_number_8 (sorted_row_18)
    );
    // Row 2 
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row2(
        // Input
       .i_number_0 (sorted_col_20), 
       .i_number_1 (sorted_col_21), 
       .i_number_2 (sorted_col_22), 
       .i_number_3 (sorted_col_23), 
       .i_number_4 (sorted_col_24), 
       .i_number_5 (sorted_col_25), 
       .i_number_6 (sorted_col_26), 
       .i_number_7 (sorted_col_27), 
       .i_number_8 (sorted_col_28),
       // Output
       .o_number_0 (sorted_row_20), 
       .o_number_1 (sorted_row_21), 
       .o_number_2 (sorted_row_22), 
       .o_number_3 (sorted_row_23), 
       .o_number_4 (sorted_row_24),
       .o_number_5 (sorted_row_25), 
       .o_number_6 (sorted_row_26), 
       .o_number_7 (sorted_row_27), 
       .o_number_8 (sorted_row_28)
    );
    // Row 3 
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row3(
        // Input
       .i_number_0 (sorted_col_30), 
       .i_number_1 (sorted_col_31), 
       .i_number_2 (sorted_col_32), 
       .i_number_3 (sorted_col_33), 
       .i_number_4 (sorted_col_34), 
       .i_number_5 (sorted_col_35), 
       .i_number_6 (sorted_col_36), 
       .i_number_7 (sorted_col_37), 
       .i_number_8 (sorted_col_38),
       // Output
       .o_number_0 (sorted_row_30), 
       .o_number_1 (sorted_row_31), 
       .o_number_2 (sorted_row_32), 
       .o_number_3 (sorted_row_33), 
       .o_number_4 (sorted_row_34),
       .o_number_5 (sorted_row_35), 
       .o_number_6 (sorted_row_36), 
       .o_number_7 (sorted_row_37), 
       .o_number_8 (sorted_row_38)
    );
    // Row 4
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row4(
        // Input
       .i_number_0 (sorted_col_40), 
       .i_number_1 (sorted_col_41), 
       .i_number_2 (sorted_col_42), 
       .i_number_3 (sorted_col_43), 
       .i_number_4 (sorted_col_44), 
       .i_number_5 (sorted_col_45), 
       .i_number_6 (sorted_col_46), 
       .i_number_7 (sorted_col_47), 
       .i_number_8 (sorted_col_48),
       // Output
       .o_number_0 (sorted_row_40), 
       .o_number_1 (sorted_row_41), 
       .o_number_2 (sorted_row_42), 
       .o_number_3 (sorted_row_43), 
       .o_number_4 (sorted_row_44),
       .o_number_5 (sorted_row_45), 
       .o_number_6 (sorted_row_46), 
       .o_number_7 (sorted_row_47), 
       .o_number_8 (sorted_row_48)
    ); 
    // Row 5
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row5(
        // Input
       .i_number_0 (sorted_col_50), 
       .i_number_1 (sorted_col_51), 
       .i_number_2 (sorted_col_52), 
       .i_number_3 (sorted_col_53), 
       .i_number_4 (sorted_col_54), 
       .i_number_5 (sorted_col_55), 
       .i_number_6 (sorted_col_56), 
       .i_number_7 (sorted_col_57), 
       .i_number_8 (sorted_col_58),
       // Output
       .o_number_0 (sorted_row_50), 
       .o_number_1 (sorted_row_51), 
       .o_number_2 (sorted_row_52), 
       .o_number_3 (sorted_row_53), 
       .o_number_4 (sorted_row_54),
       .o_number_5 (sorted_row_55), 
       .o_number_6 (sorted_row_56), 
       .o_number_7 (sorted_row_57), 
       .o_number_8 (sorted_row_58)
    ); 
    // Row 6
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row6(
        // Input
       .i_number_0 (sorted_col_60), 
       .i_number_1 (sorted_col_61), 
       .i_number_2 (sorted_col_62), 
       .i_number_3 (sorted_col_63), 
       .i_number_4 (sorted_col_64), 
       .i_number_5 (sorted_col_65), 
       .i_number_6 (sorted_col_66), 
       .i_number_7 (sorted_col_67), 
       .i_number_8 (sorted_col_68),
       // Output
       .o_number_0 (sorted_row_60), 
       .o_number_1 (sorted_row_61), 
       .o_number_2 (sorted_row_62), 
       .o_number_3 (sorted_row_63), 
       .o_number_4 (sorted_row_64),
       .o_number_5 (sorted_row_65), 
       .o_number_6 (sorted_row_66), 
       .o_number_7 (sorted_row_67), 
       .o_number_8 (sorted_row_68)
    ); 
    // Row 7 
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row7(
        // Input
       .i_number_0 (sorted_col_70), 
       .i_number_1 (sorted_col_71), 
       .i_number_2 (sorted_col_72), 
       .i_number_3 (sorted_col_73), 
       .i_number_4 (sorted_col_74), 
       .i_number_5 (sorted_col_75), 
       .i_number_6 (sorted_col_76), 
       .i_number_7 (sorted_col_77), 
       .i_number_8 (sorted_col_78),
       // Output
       .o_number_0 (sorted_row_70), 
       .o_number_1 (sorted_row_71), 
       .o_number_2 (sorted_row_72), 
       .o_number_3 (sorted_row_73), 
       .o_number_4 (sorted_row_74),
       .o_number_5 (sorted_row_75), 
       .o_number_6 (sorted_row_76), 
       .o_number_7 (sorted_row_77), 
       .o_number_8 (sorted_row_78)
    );
    // Row 5 
    bitonic_sort_9#(
        .WIDTH     (WIDTH)
    )row8(
        // Input
       .i_number_0 (sorted_col_80), 
       .i_number_1 (sorted_col_81), 
       .i_number_2 (sorted_col_82), 
       .i_number_3 (sorted_col_83), 
       .i_number_4 (sorted_col_84), 
       .i_number_5 (sorted_col_85), 
       .i_number_6 (sorted_col_86), 
       .i_number_7 (sorted_col_87), 
       .i_number_8 (sorted_col_88),
       // Output
       .o_number_0 (sorted_row_80), 
       .o_number_1 (sorted_row_81), 
       .o_number_2 (sorted_row_82), 
       .o_number_3 (sorted_row_83), 
       .o_number_4 (sorted_row_84),
       .o_number_5 (sorted_row_85), 
       .o_number_6 (sorted_row_86), 
       .o_number_7 (sorted_row_87), 
       .o_number_8 (sorted_row_88)
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
       .i_number_6 (sorted_row_05), 
       .i_number_7 (sorted_row_14), 
       .i_number_8 (sorted_row_23),
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
       .i_number_6 (sorted_row_65), 
       .i_number_7 (sorted_row_74), 
       .i_number_8 (sorted_row_83),
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
        if (i_rst ) begin
            i_rd7_00 <= 'd0;
            i_rd7_01 <= 'd0;
            i_rd7_02 <= 'd0;
            i_rd7_03 <= 'd0;
            i_rd7_04 <= 'd0;
            i_rd7_05 <= 'd0;
            i_rd7_06 <= 'd0;

            i_rd7_10 <= 'd0; 
            i_rd7_11 <= 'd0; 
            i_rd7_12 <= 'd0; 
            i_rd7_13 <= 'd0; 
            i_rd7_14 <= 'd0; 
            i_rd7_15 <= 'd0; 
            i_rd7_16 <= 'd0; 

            i_rd7_20 <= 'd0;
            i_rd7_21 <= 'd0;
            i_rd7_22 <= 'd0;
            i_rd7_23 <= 'd0;
            i_rd7_24 <= 'd0;
            i_rd7_25 <= 'd0;
            i_rd7_26 <= 'd0;

            i_rd7_30 <= 'd0;
            i_rd7_31 <= 'd0;
            i_rd7_32 <= 'd0;
            i_rd7_33 <= 'd0;
            i_rd7_34 <= 'd0;
            i_rd7_35 <= 'd0;
            i_rd7_36 <= 'd0;

            i_rd7_40 <= 'd0;
            i_rd7_41 <= 'd0;
            i_rd7_42 <= 'd0;
            i_rd7_43 <= 'd0;
            i_rd7_44 <= 'd0;
            i_rd7_45 <= 'd0;
            i_rd7_46 <= 'd0;

            i_rd7_50 <= 'd0;
            i_rd7_51 <= 'd0;
            i_rd7_52 <= 'd0;
            i_rd7_53 <= 'd0;
            i_rd7_54 <= 'd0;
            i_rd7_55 <= 'd0;
            i_rd7_56 <= 'd0;

            i_rd7_60 <= 'd0;
            i_rd7_61 <= 'd0;
            i_rd7_62 <= 'd0;
            i_rd7_63 <= 'd0;
            i_rd7_64 <= 'd0;
            i_rd7_65 <= 'd0;
            i_rd7_66 <= 'd0;
        end else if (i_enable_9x9) begin
            i_rd7_00 <= sorted_row_06;
            i_rd7_01 <= sorted_row_07;
            i_rd7_02 <= sorted_row_08;
            i_rd7_03 <= sorted_upper_01;
            i_rd7_04 <= sorted_row_15;
            i_rd7_05 <= sorted_row_16;
            i_rd7_06 <= sorted_row_17;

            i_rd7_10 <= sorted_row_18;
            i_rd7_11 <= sorted_upper_02;
            i_rd7_12 <= sorted_row_24;
            i_rd7_13 <= sorted_row_25;
            i_rd7_14 <= sorted_row_26;
            i_rd7_15 <= sorted_row_27;
            i_rd7_16 <= sorted_row_28;

            i_rd7_20 <= sorted_row_32;
            i_rd7_21 <= sorted_row_33;
            i_rd7_22 <= sorted_row_34;
            i_rd7_23 <= sorted_row_35;
            i_rd7_24 <= sorted_row_36;
            i_rd7_25 <= sorted_row_37;
            i_rd7_26 <= sorted_row_38;

            i_rd7_30 <= sorted_row_41;
            i_rd7_31 <= sorted_row_42;
            i_rd7_32 <= sorted_row_43;
            i_rd7_33 <= sorted_row_44;
            i_rd7_34 <= sorted_row_45;
            i_rd7_35 <= sorted_row_46;
            i_rd7_36 <= sorted_row_47;

            i_rd7_40 <= sorted_row_50;
            i_rd7_41 <= sorted_row_51;
            i_rd7_42 <= sorted_row_52;
            i_rd7_43 <= sorted_row_53;
            i_rd7_44 <= sorted_row_54;
            i_rd7_45 <= sorted_row_55;
            i_rd7_46 <= sorted_row_56;

            i_rd7_50 <= sorted_row_60;
            i_rd7_51 <= sorted_row_61;
            i_rd7_52 <= sorted_row_62;
            i_rd7_53 <= sorted_row_63;
            i_rd7_54 <= sorted_row_64;
            i_rd7_55 <= sorted_lower_00;
            i_rd7_56 <= sorted_row_70;

            i_rd7_60 <= sorted_row_71;
            i_rd7_61 <= sorted_row_72;
            i_rd7_62 <= sorted_row_73;
            i_rd7_63 <= sorted_lower_01;
            i_rd7_64 <= sorted_row_80;
            i_rd7_65 <= sorted_row_81;
            i_rd7_66 <= sorted_row_82;
        end
    end

    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            enable_9x9_syn_with_data <= 1'b0; 
        end else begin
            enable_9x9_syn_with_data <= i_enable_9x9; 
        end 
    end
    //////////////////////////////////////////////////////////////////
    ///////                 SORT WITH MATRIX 7X7               ///////
    //////////////////////////////////////////////////////////////////
    median_filter_7#(
        .WIDTH      (WIDTH)
    )filter7_5(
      // Clock & reset 
      .i_clk, 
      .i_rst, 
      // Input 
      .i_enable_7x7 (enable_9x9_syn_with_data), 
      .i_pixel_00   (i_rd7_00), 
      .i_pixel_01   (i_rd7_01), 
      .i_pixel_02   (i_rd7_02), 
      .i_pixel_03   (i_rd7_03), 
      .i_pixel_04   (i_rd7_04), 
      .i_pixel_05   (i_rd7_05), 
      .i_pixel_06   (i_rd7_06),

      .i_pixel_10   (i_rd7_10), 
      .i_pixel_11   (i_rd7_11), 
      .i_pixel_12   (i_rd7_12), 
      .i_pixel_13   (i_rd7_13), 
      .i_pixel_14   (i_rd7_14), 
      .i_pixel_15   (i_rd7_15), 
      .i_pixel_16   (i_rd7_16),

      .i_pixel_20   (i_rd7_20), 
      .i_pixel_21   (i_rd7_21), 
      .i_pixel_22   (i_rd7_22), 
      .i_pixel_23   (i_rd7_23), 
      .i_pixel_24   (i_rd7_24), 
      .i_pixel_25   (i_rd7_25), 
      .i_pixel_26   (i_rd7_26),

      .i_pixel_30   (i_rd7_30), 
      .i_pixel_31   (i_rd7_31), 
      .i_pixel_32   (i_rd7_32), 
      .i_pixel_33   (i_rd7_33), 
      .i_pixel_34   (i_rd7_34), 
      .i_pixel_35   (i_rd7_35), 
      .i_pixel_36   (i_rd7_36),

      .i_pixel_40   (i_rd7_40), 
      .i_pixel_41   (i_rd7_41), 
      .i_pixel_42   (i_rd7_42), 
      .i_pixel_43   (i_rd7_43), 
      .i_pixel_44   (i_rd7_44), 
      .i_pixel_45   (i_rd7_45), 
      .i_pixel_46   (i_rd7_46),

      .i_pixel_50   (i_rd7_50), 
      .i_pixel_51   (i_rd7_51), 
      .i_pixel_52   (i_rd7_52), 
      .i_pixel_53   (i_rd7_53), 
      .i_pixel_54   (i_rd7_54), 
      .i_pixel_55   (i_rd7_55), 
      .i_pixel_56   (i_rd7_56),

      .i_pixel_60   (i_rd7_60), 
      .i_pixel_61   (i_rd7_61), 
      .i_pixel_62   (i_rd7_62), 
      .i_pixel_63   (i_rd7_63), 
      .i_pixel_64   (i_rd7_64), 
      .i_pixel_65   (i_rd7_65), 
      .i_pixel_66   (i_rd7_66),
       // Output 
      .o_value_median (o_value_median)
    ); 
endmodule