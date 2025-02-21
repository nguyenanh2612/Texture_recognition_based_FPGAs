module bitonic_sort_9 #(
    parameter WIDTH = 8
) (
    // Input 
    input logic [WIDTH-1:0] i_number_0, i_number_1, i_number_2, i_number_3, i_number_4, 
                            i_number_5, i_number_6, i_number_7, i_number_8, 
    // Output
    output logic [WIDTH-1:0] o_number_0, o_number_1, o_number_2, o_number_3, o_number_4, 
                             o_number_5, o_number_6, o_number_7, o_number_8
);
    // Immediate signals 
    logic [WIDTH-1:0] stage_10, stage_11, stage_12, stage_13,stage_14, stage_15, stage_16, stage_17, stage_18; 
    logic [WIDTH-1:0] stage_20, stage_21, stage_22, stage_23,stage_24, stage_25, stage_26, stage_27, stage_28;
    logic [WIDTH-1:0] stage_30, stage_31, stage_32, stage_33,stage_34, stage_35, stage_36, stage_37, stage_38;
    logic [WIDTH-1:0] stage_40, stage_41, stage_42, stage_43,stage_44, stage_45, stage_46, stage_47, stage_48; 
    logic [WIDTH-1:0] stage_50, stage_51, stage_52, stage_53,stage_54, stage_55, stage_56, stage_57, stage_58; 
    logic [WIDTH-1:0] stage_60, stage_61, stage_62, stage_63,stage_64, stage_65, stage_66, stage_67, stage_68; 
    logic [WIDTH-1:0] stage_70, stage_71, stage_72, stage_73,stage_74, stage_75, stage_76, stage_77, stage_78;   

    // Stage 1
    bitonic_sort_2#(.WIDTH (WIDTH)) sort0 (i_number_0, i_number_1, stage_10, stage_11); 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort1 (i_number_2, i_number_3, stage_13, stage_12); 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort2 (i_number_4, i_number_5, stage_15, stage_14); 
    assign stage_16 = i_number_6; 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort3 (i_number_7, i_number_8, stage_17, stage_18); 

    // Stage 2
    bitonic_sort_2#(.WIDTH (WIDTH)) sort4 (stage_10, stage_12, stage_22, stage_20); 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort5 (stage_11, stage_13, stage_23, stage_21); 
    assign stage_24 = stage_14;
    assign stage_25 = stage_15; 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort6 (stage_16, stage_18, stage_26, stage_28); 
    assign stage_27 = stage_17; 

    // Stage 3 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort7 (stage_20, stage_21, stage_31, stage_30); 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort8 (stage_22, stage_23, stage_33, stage_32);
    bitonic_sort_2#(.WIDTH (WIDTH)) sort9 (stage_24, stage_28, stage_34, stage_38); 
    assign stage_35 = stage_25;
    bitonic_sort_2#(.WIDTH (WIDTH)) sort10 (stage_26, stage_27, stage_36, stage_37); 

    // Stage 4 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort11 (stage_30, stage_38, stage_40, stage_48); 
    assign stage_41 = stage_31; 
    assign stage_42 = stage_32; 
    assign stage_43 = stage_33; 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort12 (stage_34, stage_36, stage_44, stage_46); 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort13 (stage_35, stage_37, stage_45, stage_47); 
    
    // Stage 5 
    assign stage_50 = stage_40; 
    assign stage_51 = stage_41; 
    assign stage_52 = stage_42;
    assign stage_53 = stage_43; 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort14 (stage_44, stage_45, stage_54, stage_55); 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort15 (stage_46, stage_47, stage_56, stage_57); 
    assign stage_58 = stage_48; 

    // Stage 6
    bitonic_sort_2#(.WIDTH (WIDTH)) sort16 (stage_50, stage_54, stage_60, stage_64); 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort17 (stage_51, stage_55, stage_61, stage_65); 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort18 (stage_52, stage_56, stage_62, stage_66); 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort19 (stage_53, stage_57, stage_63, stage_67); 
    assign stage_68 = stage_58; 

    // Stage 7 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort20 (stage_60, stage_62, stage_70, stage_72); 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort21 (stage_61, stage_63, stage_71, stage_73); 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort22 (stage_64, stage_66, stage_74, stage_76); 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort23 (stage_65, stage_67, stage_75, stage_77); 
    assign stage_78 = stage_68; 

    // Stage 8 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort24 (stage_70, stage_71, o_number_0, o_number_1); 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort25 (stage_72, stage_73, o_number_2, o_number_3); 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort26 (stage_74, stage_75, o_number_4, o_number_5); 
    bitonic_sort_2#(.WIDTH (WIDTH)) sort27 (stage_76, stage_77, o_number_6, o_number_7); 
    assign o_number_8 = stage_78;    
endmodule  
