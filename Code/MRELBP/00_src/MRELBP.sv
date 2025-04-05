module MRELBP #(
    parameter WIDTH = 9,                                           // Width of bram
    parameter DEPTH = 9,                                           // Depth of bram 
    parameter SIZED = 8,                                           // Size of each cellparameter WIDTH = 9
    parameter FIXED = 24                                          // Size of fixed point in interpolation
) (
    ///////////////////////////////////////////////////////////////
    ///////                 INPUT OF MODULE                 ///////
    ///////////////////////////////////////////////////////////////
    input logic i_clk,                                             // GLobal clock 
    input logic i_rst,                                             // Global reset 
    input logic [SIZED-1:0] i_din,                                 // Pixel
    input logic i_done_load_data_r8,                               // Done signal for loading data r8
    input logic i_done_load_data_r6,                               // Done signal for loading data r6
    input logic i_done_load_data_r4,                               // Done signal for loading data r4
    input logic i_done_load_data_r2,                               // Done signal for loading data r2

    //////////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF MEDIAN PRE-PROCESSING               ///////
    //////////////////////////////////////////////////////////////////////////////////
    // output logic o_enable_3x3,                                     // Enable signal 3x3    
    // output logic o_enable_5x5,                                     // Enable signal 5x5    
    // output logic o_enable_7x7,                                     // Enable signal 7x7    
    // output logic o_enable_9x9,                                     // Enable signal 9x9    

    // output logic [2:0]  o_state_3x3,                               // State test of control 3x3
    // output logic [2:0]  o_state_5x5,                               // State test of control 5x5
    // output logic [2:0]  o_state_7x7,                               // State test of control 7x7
    // output logic        o_state_9x9,                               // State test of control 9x9

    // output logic [SIZED*9-1:0] o_bram_of_median_9x9 [8:0]          // Output of bram for median 9x9 
    
    ///////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF MEDIAN PROCESSING                ///////
    ///////////////////////////////////////////////////////////////////////////////

    // output logic [SIZED-1:0] o_median_3x3,                         // Median filter 3x3 result
    // output logic [SIZED-1:0] o_median_5x5,                         // Median filter 5x5 result
    // output logic [SIZED-1:0] o_median_7x7,                         // Median filter 7x7 result
    // output logic [SIZED-1:0] o_median_9x9,                         // Median filter 9x9 result

    ////////////////////////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF MEDIAN PROCESSING RESULT STORE BRAM               ///////
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // output logic [5:0]       o_addr_3x3,                           // Read and write address 3x3 
    // output logic [6:0]       o_addr_5x5,                           // Read and write address 5x5
    // output logic [8:0]       o_addr_7x7,                           // Read and write address 7x7
    // output logic [8:0]       o_addr_9x9,                           //  Read and write address 9x9

    // output logic [SIZED-1:0] o_bram_3x3,                           // Median filter 3x3 result
    // output logic [SIZED-1:0] o_bram_5x5,                           // Median filter 5x5 result
    // output logic [SIZED-1:0] o_bram_7x7,                            // Median filter 7x7 result
    // output logic [SIZED-1:0] o_bram_9x9,                            // Median filter 9x9 result

    ////////////////////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF HOLD VALUE BEFORE CACLCULATE CI               ///////
    ////////////////////////////////////////////////////////////////////////////////////////////
    // output logic [SIZED-1:0] o_hold_value_for_ci [48:0],           // Value hold before calculate CI
    // output logic [SIZED-1:0] o_hold_value [20:0],                  // Value hold before calculate ni and rd

    ////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF CI_2 CALCULATOR               ///////
    ////////////////////////////////////////////////////////////////////////////
    // output logic [15:0] o_average_test,                            // Test average value
    // output logic [24:0] o_ci_2,                                    // Result of ci_2 (normalization)
    // output logic [48:0] o_ci_4,                                    // Result of ci_4 (normalization)  
    // output logic [48:0] o_ci_6,                                    // Result of ci_6 (normalization)                                       
    // output logic [48:0] o_ci_8,                                    // Result of ci_8 (normalization)            

    ///////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF CI_2 HISTOGRAM               ///////
    ///////////////////////////////////////////////////////////////////////////
    output logic [23:0] o_rdata_r2_0,                              // Count logic 0 value in histogram of CI2
    output logic [23:0] o_rdata_r2_1,                              // Count logic 1 value in histogram of CI2
    // output logic        o_ready_r2,                                // Ready_r2 signal for enable to CI histogram

    output logic [23:0] o_rdata_r4_0,                              // Count logic 0 value in histogram of CI2
    output logic [23:0] o_rdata_r4_1,                              // Count logic 1 value in histogram of CI2
    // output logic        o_ready_r4_6_8,                            // Ready_r4,6,8 signal for enable to CI histogram
 
    output logic [23:0] o_rdata_r6_0,                              // Count logic 0 value in histogram of CI2
    output logic [23:0] o_rdata_r6_1,                              // Count logic 1 value in histogram of CI2

    output logic [23:0] o_rdata_r8_0,                              // Count logic 0 value in histogram of CI2
    output logic [23:0] o_rdata_r8_1,                              // Count logic 1 value in histogram of CI2
    
    ///////////////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF INTERPOLATION R CALCULATOR               ///////
    ///////////////////////////////////////////////////////////////////////////////////////
    // output logic [SIZED-1:0] o_pixel_center,                       // Output central value
    // output logic [SIZED-1:0] o_q_ne_even [3:0],                    // Output 4 normal points
    // output logic [FIXED-1:0] o_q_ne_odd  [3:0],                    // Output 4 interpoaltion points  

    ///////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF NI + RD CALCULATOR               ///////
    ///////////////////////////////////////////////////////////////////////////////
    // output logic [FIXED-1:0] o_average_r2,                         // Output average test value
    // output logic [FIXED-1:0] o_average_r4,                         // Output average test value
    // output logic [FIXED-1:0] o_average_r6,                         // Output average test value      
    // output logic [FIXED-1:0] o_average_r8,                         // Output average test value      

    // output logic [SIZED-1:0] o_ni_r2,                              // Output NI calculator
    // output logic [SIZED-1:0] o_rd_r2,                              // Output RD calculator                                                  
    // output logic [SIZED-1:0] o_ni_r4,                              // Output NI calculator
    // output logic [SIZED-1:0] o_rd_r4,                              // Output RD calculator 
    // output logic             o_ready_ni_rd_4,                      // Ready signal for updating ni_rd histogram
    // output logic [SIZED-1:0] o_ni_r6,                              // Output NI calculator
    // output logic [SIZED-1:0] o_rd_r6,                              // Output RD calculator
    // output logic             o_ready_ni_rd_6,                      // Ready signal for updating ni_rd histogram

    // output logic [SIZED-1:0] o_ni_r8,                              // Output NI calculator
    // output logic [SIZED-1:0] o_rd_r8,                              // Output RD calculator   
    // output logic             o_ready_ni_rd_8,                      // Ready signal for updating ni_rd histogram             

    /////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST FOR NI RD HISTOGRAM               ///////
    /////////////////////////////////////////////////////////////////////////////
    output logic [FIXED-1:0]  o_rdata_ni_r2, o_rdata_rd_r2,        // NI, RD read data from R2
    output logic [FIXED-1:0]  o_rdata_ni_r4, o_rdata_rd_r4,        // NI, RD read data from R4
    output logic [FIXED-1:0]  o_rdata_ni_r6, o_rdata_rd_r6,        // NI, RD read data from R6
    output logic [FIXED-1:0]  o_rdata_ni_r8, o_rdata_rd_r8,        // NI, RD read data from R8

    ////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT FOR COMBINE VECTOR               ////////
    ////////////////////////////////////////////////////////////////////////
    output logic [23:0]      o_ci0,                               // Output CI_0
    output logic [23:0]      o_ci1,                               // Output CI_1
    output logic [SIZED:0]   o_ni_addr,                           // Output NI address
    output logic [SIZED:0]   o_rd_addr,                           // Output RD address

    //////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST FOR LUT               ////////
    //////////////////////////////////////////////////////////////////
    // output logic [FIXED-1:0]      o_lut_ni_2,                         // Output LUT NI 2
    // output logic [FIXED-1:0]      o_lut_rd_2,                         // Output LUT RD 2
    // output logic [FIXED-1:0]      o_lut_ni_4,                         // Output LUT NI 4
    // output logic [FIXED-1:0]      o_lut_rd_4,                         // Output LUT RD 4
    // output logic [FIXED-1:0]      o_lut_ni_6,                         // Output LUT NI 6
    // output logic [FIXED-1:0]      o_lut_rd_6,                         // Output LUT RD 6
    // output logic [FIXED-1:0]      o_lut_ni_8,                         // Output LUT NI 8
    // output logic [FIXED-1:0]      o_lut_rd_8,                         // Output LUT RD 8

    //////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST FOR DENSE LAYER               ////////
    //////////////////////////////////////////////////////////////////////////
    output logic                  o_done_layer,                       // Done signal for dense layer
    
    // output logic [55:0]          o_dense_ni_r2,                     // Output dense NI r2
    // output logic [55:0]          o_dense_ni_r4                      // Output dense RD r4
    // output logic [55:0]          o_dense_ni_r6                      // Output dense NI r6
    // output logic [55:0]          o_dense_ni_r8                      // Output dense NI r8

    // output logic [55:0]          o_dense_rd_r2,                      // Output dense RD r2
    // output logic [55:0]          o_dense_rd_r4                      // Output dense RD r4
    // output logic [55:0]          o_dense_rd_r6,                      // Output dense RD r6
    // output logic [55:0]          o_dense_rd_r8                       // Output dense RD r8
    output logic [59:0]             o_dense_layer, 
    output logic [4:0]              o_classi
);

    ////////////////////////////////////////////////////////
    ///////                 VARIABLE                 /////// 
    ////////////////////////////////////////////////////////
    // Genvar for assign
    genvar i;

    // Input bram step
    /*Output of image bram*/
    logic [SIZED*DEPTH-1:0] o_image_bram [DEPTH-1:0];

    // State of each controller
    logic [2:0] state_3x3; 
    logic [2:0] state_5x5;
    logic [2:0] state_7x7;
    logic       state_9x9; 

    // Control of median processing signal
    logic enable_3x3; 
    logic enable_5x5; 
    logic enable_7x7; logic enable_7x7_hold;
    logic enable_9x9; logic enable_9x9_hold; logic enable_9x9_hold_1;  

    // Median result
    logic [SIZED-1:0] median_3x3;
    logic [SIZED-1:0] median_5x5;
    logic [SIZED-1:0] median_7x7;
    logic [SIZED-1:0] median_9x9; 
 
    // Read and write address automatic + ready signal;
    // R2
    logic [5:0] addr_next_3x3_bram, addr_cur_3x3_bram; 
    logic       ready_r2, ready_r2_hold;

    // R4
    logic [6:0] addr_next_5x5_bram, addr_cur_5x5_bram;
    logic       ready_r4, ready_r4_hold;

    // R6 
    logic [8:0] addr_next_7x7_bram, addr_cur_7x7_bram;
    logic       ready_r6;

    // R8
    logic [8:0] addr_next_9x9_bram, addr_cur_9x9_bram; 
    logic       ready_r8;

    // Value hold output for CI_2, CI_4, CI_6, CI_8
    logic [SIZED-1:0] output_49_value_hold [48:0]; 
    logic [24:0] ci_2;
    logic [48:0] ci_4, ci_6, ci_8;

    // Histogram in ci
    logic [23:0] rdata_0_r2, rdata_1_r2;
    logic [23:0] rdata_0_r4, rdata_1_r4;  
    logic [23:0] rdata_0_r6, rdata_1_r6;
    logic [23:0] rdata_0_r8, rdata_1_r8;  

    // Output of test interpolation
    // r=2
    logic [SIZED-1:0]  pixel_center; 
    logic [SIZED-1:0]  q_ne_even_r2 [3:0]; 
    logic [FIXED-1:0]  q_ne_odd_r2  [3:0]; 

    // r=4
    logic              ni_rd4_ready;
    logic [4:0]        r_addr_hold; 
    logic [SIZED-1:0]  output_21_value_hold_r4 [20:0]; 
    logic [SIZED-1:0]  q_ne_even_r4 [3:0]; 
    logic [FIXED-1:0]  q_ne_odd_r4  [3:0];

    // r=6 
    logic              ni_rd6_ready;
    logic [4:0]        r_addr_hold_r6; 
    logic [SIZED-1:0]  output_21_value_hold_r6 [20:0]; 
    logic [SIZED-1:0]  q_ne_even_r6 [3:0]; 
    logic [FIXED-1:0]  q_ne_odd_r6  [3:0];

    // r=8
    logic              ni_rd8_ready; 
    logic [4:0]        r_addr_hold_r8; 
    logic [SIZED-1:0]  output_21_value_hold_r8 [20:0]; 
    logic [SIZED-1:0]  q_ne_even_r8 [3:0]; 
    logic [FIXED-1:0]  q_ne_odd_r8  [3:0];

    // Output ni_rd_2
    logic [SIZED-1:0]  ni_r2, ni_r2_hold; 
    logic [SIZED-1:0]  rd_r2, rd_r2_hold; 
    logic [FIXED-1:0]  average_r2; 

    // Output ni_rd_4
    logic [SIZED-1:0]  ni_r4, ni_r4_hold; 
    logic [SIZED-1:0]  rd_r4, rd_r4_hold; 
    logic [FIXED-1:0]  average_r4; 

    // Output ni_rd_6
    logic [SIZED-1:0]  ni_r6, ni_r6_hold; 
    logic [SIZED-1:0]  rd_r6, rd_r6_hold; 
    logic [FIXED-1:0]  average_r6; 

    // Output ni_rd_8
    logic [SIZED-1:0]  ni_r8, ni_r8_hold; 
    logic [SIZED-1:0]  rd_r8, rd_r8_hold; 
    logic [FIXED-1:0]  average_r8; 


    // NI RD histogram
    logic ni_rd_wren_r2; 
    logic ni_rd_wren_r4; 
    logic ni_rd_wren_r6; 
    logic ni_rd_wren_r8; 

    logic [FIXED-1:0] rdata_ni_r2, rdata_rd_r2; 
    logic [FIXED-1:0] rdata_ni_r4, rdata_rd_r4; 
    logic [FIXED-1:0] rdata_ni_r6, rdata_rd_r6; 
    logic [FIXED-1:0] rdata_ni_r8, rdata_rd_r8; 

    //////////////////////////////////////////////////////////
    ///////                 INPUT BRAM                 /////// 
    //////////////////////////////////////////////////////////

    image_bram #(
        .WIDTH      (WIDTH), 
        .DEPTH      (DEPTH), 
        .SIZED      (SIZED)
    ) store_input_pixel(
        .i_clk      (i_clk), 
        .i_rst      (i_rst), 
        .i_data     (i_din), 
        .i_wren     (1'b1),              // Always write
        .o_data     (o_image_bram)
    );

    //////////////////////////////////////////////////////////////////////////////////
    ///////                 CONTROL FOR MEDIAN PROCESSING BRAM                 /////// 
    //////////////////////////////////////////////////////////////////////////////////

    // Control of median filter 3x3; 
    bram_to_median_3_controller controller_3x3(
        .i_clk                  (i_clk), 
        .i_rst                  (i_rst), 
        .o_state                (state_3x3), 
        .o_enable_3x3           (enable_3x3)
    );
    // Control of median filter 5x5; 
    bram_to_median_5_controller controller_5x5(
        .i_clk                  (i_clk), 
        .i_rst                  (i_rst), 
        .o_state                (state_5x5), 
        .o_enable_5x5           (enable_5x5)
    );
    // Control of median filter 7x7; 
    bram_to_median_7_controller controller_7x7(
        .i_clk                  (i_clk), 
        .i_rst                  (i_rst), 
        .o_state                (state_7x7), 
        .o_enable_7x7           (enable_7x7)
    );
    // Control of median filter 9x9; 
    bram_to_median_9_controller controller_9x9(
        .i_clk                  (i_clk), 
        .i_rst                  (i_rst), 
        .o_state                (state_9x9), 
        .o_enable_9x9           (enable_9x9)
    );  

    /////////////////////////////////////////////////////////////////
    ///////                 MEDIAN PROCESSING                 /////// 
    /////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////
    ///////                 MEDIAN FILTER 3X3                /////// 
    ////////////////////////////////////////////////////////////////
    median_filter_3 #(
        .WIDTH                  (SIZED)
    )filter_3x3(
        // Enable signal
        .i_enable_3x3           (enable_3x3),
        // Row 0
        .i_pixel_00             (o_image_bram[5][7:0]), 
        .i_pixel_01             (o_image_bram[5][15:8]), 
        .i_pixel_02             (o_image_bram[5][23:16]), 
        // Row 1
        .i_pixel_10             (o_image_bram[4][7:0]), 
        .i_pixel_11             (o_image_bram[4][15:8]), 
        .i_pixel_12             (o_image_bram[4][23:16]), 
        // Row 2
        .i_pixel_20             (o_image_bram[3][7:0]), 
        .i_pixel_21             (o_image_bram[3][15:8]), 
        .i_pixel_22             (o_image_bram[3][23:16]),
        // Output 
        .o_pixel_median         (median_3x3)
    ); 

    ////////////////////////////////////////////////////////////////
    ///////                 MEDIAN FILTER 5X5                /////// 
    ////////////////////////////////////////////////////////////////
    median_filter_5 #(
        .WIDTH                  (SIZED)
    )filter_5x5(
        // Enable signal
        .i_enable_5x5           (enable_5x5),
        // Row 0
        .i_pixel_00             (o_image_bram[6][7:0]), 
        .i_pixel_01             (o_image_bram[6][15:8]), 
        .i_pixel_02             (o_image_bram[6][23:16]),
        .i_pixel_03             (o_image_bram[6][31:24]), 
        .i_pixel_04             (o_image_bram[6][39:32]),
        // Row 1
        .i_pixel_10             (o_image_bram[5][7:0]),  
        .i_pixel_11             (o_image_bram[5][15:8]),  
        .i_pixel_12             (o_image_bram[5][23:16]), 
        .i_pixel_13             (o_image_bram[5][31:24]), 
        .i_pixel_14             (o_image_bram[5][39:32]),
        // Row 2
        .i_pixel_20             (o_image_bram[4][7:0]),  
        .i_pixel_21             (o_image_bram[4][15:8]),  
        .i_pixel_22             (o_image_bram[4][23:16]), 
        .i_pixel_23             (o_image_bram[4][31:24]),
        .i_pixel_24             (o_image_bram[4][39:32]),
        // Row 3 
        .i_pixel_30             (o_image_bram[3][7:0]),  
        .i_pixel_31             (o_image_bram[3][15:8]),  
        .i_pixel_32             (o_image_bram[3][23:16]), 
        .i_pixel_33             (o_image_bram[3][31:24]), 
        .i_pixel_34             (o_image_bram[3][39:32]),
        // Row 4
        .i_pixel_40             (o_image_bram[2][7:0]), 
        .i_pixel_41             (o_image_bram[2][15:8]),  
        .i_pixel_42             (o_image_bram[2][23:16]), 
        .i_pixel_43             (o_image_bram[2][31:24]), 
        .i_pixel_44             (o_image_bram[2][39:32]),
        // Output 
        .o_value_median         (median_5x5)
    );
    ////////////////////////////////////////////////////////////////
    ///////                 MEDIAN FILTER 7X7                /////// 
    ////////////////////////////////////////////////////////////////
    median_filter_7 #(
        .WIDTH                  (SIZED)
    )filter_7x7(
        // Global clock and reset
        .i_clk                  (i_clk), 
        .i_rst                  (i_rst), 
        // Enable signal
        .i_enable_7x7           (enable_7x7), 
        // Row 0 
        .i_pixel_00             (o_image_bram[7][7:0]), 
        .i_pixel_01             (o_image_bram[7][15:8]), 
        .i_pixel_02             (o_image_bram[7][23:16]), 
        .i_pixel_03             (o_image_bram[7][31:24]), 
        .i_pixel_04             (o_image_bram[7][39:32]), 
        .i_pixel_05             (o_image_bram[7][47:40]), 
        .i_pixel_06             (o_image_bram[7][55:48]),
        // Row 1 
        .i_pixel_10             (o_image_bram[6][7:0]),  
        .i_pixel_11             (o_image_bram[6][15:8]),  
        .i_pixel_12             (o_image_bram[6][23:16]), 
        .i_pixel_13             (o_image_bram[6][31:24]), 
        .i_pixel_14             (o_image_bram[6][39:32]), 
        .i_pixel_15             (o_image_bram[6][47:40]), 
        .i_pixel_16             (o_image_bram[6][55:48]),
        // Row 2 
        .i_pixel_20             (o_image_bram[5][7:0]),  
        .i_pixel_21             (o_image_bram[5][15:8]),  
        .i_pixel_22             (o_image_bram[5][23:16]), 
        .i_pixel_23             (o_image_bram[5][31:24]), 
        .i_pixel_24             (o_image_bram[5][39:32]), 
        .i_pixel_25             (o_image_bram[5][47:40]), 
        .i_pixel_26             (o_image_bram[5][55:48]),
        // Row 3 
        .i_pixel_30             (o_image_bram[4][7:0]),  
        .i_pixel_31             (o_image_bram[4][15:8]),  
        .i_pixel_32             (o_image_bram[4][23:16]), 
        .i_pixel_33             (o_image_bram[4][31:24]), 
        .i_pixel_34             (o_image_bram[4][39:32]), 
        .i_pixel_35             (o_image_bram[4][47:40]), 
        .i_pixel_36             (o_image_bram[4][55:48]),
        // Row4
        .i_pixel_40             (o_image_bram[3][7:0]),  
        .i_pixel_41             (o_image_bram[3][15:8]),  
        .i_pixel_42             (o_image_bram[3][23:16]), 
        .i_pixel_43             (o_image_bram[3][31:24]), 
        .i_pixel_44             (o_image_bram[3][39:32]), 
        .i_pixel_45             (o_image_bram[3][47:40]), 
        .i_pixel_46             (o_image_bram[3][55:48]),
        // Row 5 
        .i_pixel_50             (o_image_bram[2][7:0]),  
        .i_pixel_51             (o_image_bram[2][15:8]),  
        .i_pixel_52             (o_image_bram[2][23:16]), 
        .i_pixel_53             (o_image_bram[2][31:24]), 
        .i_pixel_54             (o_image_bram[2][39:32]), 
        .i_pixel_55             (o_image_bram[2][47:40]), 
        .i_pixel_56             (o_image_bram[2][55:48]),
        // Row 6
        .i_pixel_60             (o_image_bram[1][7:0]),  
        .i_pixel_61             (o_image_bram[1][15:8]),  
        .i_pixel_62             (o_image_bram[1][23:16]), 
        .i_pixel_63             (o_image_bram[1][31:24]), 
        .i_pixel_64             (o_image_bram[1][39:32]), 
        .i_pixel_65             (o_image_bram[1][47:40]), 
        .i_pixel_66             (o_image_bram[1][55:48]),
        // Output
        .o_value_median         (median_7x7)
    );

    ////////////////////////////////////////////////////////////////
    ///////                 MEDIAN FILTER 9X9                /////// 
    ////////////////////////////////////////////////////////////////
    median_filter_9 #(
        .WIDTH                  (SIZED)
    )filter_9x9(
        // Global clock and reset
        .i_clk                  (i_clk), 
        .i_rst                  (i_rst), 
        // Enable signal
        .i_enable_9x9           (enable_9x9),
        // Row 0
        .i_pixel_00             (o_image_bram[8][7:0]),   
        .i_pixel_01             (o_image_bram[8][15:8]),  
        .i_pixel_02             (o_image_bram[8][23:16]), 
        .i_pixel_03             (o_image_bram[8][31:24]), 
        .i_pixel_04             (o_image_bram[8][39:32]), 
        .i_pixel_05             (o_image_bram[8][47:40]), 
        .i_pixel_06             (o_image_bram[8][55:48]), 
        .i_pixel_07             (o_image_bram[8][63:56]), 
        .i_pixel_08             (o_image_bram[8][71:64]),
        // Row 1
        .i_pixel_10             (o_image_bram[7][7:0]),   
        .i_pixel_11             (o_image_bram[7][15:8]),  
        .i_pixel_12             (o_image_bram[7][23:16]), 
        .i_pixel_13             (o_image_bram[7][31:24]), 
        .i_pixel_14             (o_image_bram[7][39:32]), 
        .i_pixel_15             (o_image_bram[7][47:40]), 
        .i_pixel_16             (o_image_bram[7][55:48]), 
        .i_pixel_17             (o_image_bram[7][63:56]), 
        .i_pixel_18             (o_image_bram[7][71:64]),
        // Row 2
        .i_pixel_20             (o_image_bram[6][7:0]),   
        .i_pixel_21             (o_image_bram[6][15:8]),  
        .i_pixel_22             (o_image_bram[6][23:16]), 
        .i_pixel_23             (o_image_bram[6][31:24]), 
        .i_pixel_24             (o_image_bram[6][39:32]), 
        .i_pixel_25             (o_image_bram[6][47:40]), 
        .i_pixel_26             (o_image_bram[6][55:48]), 
        .i_pixel_27             (o_image_bram[6][63:56]), 
        .i_pixel_28             (o_image_bram[6][71:64]),
        // Row 3
        .i_pixel_30             (o_image_bram[5][7:0]),   
        .i_pixel_31             (o_image_bram[5][15:8]),  
        .i_pixel_32             (o_image_bram[5][23:16]), 
        .i_pixel_33             (o_image_bram[5][31:24]), 
        .i_pixel_34             (o_image_bram[5][39:32]), 
        .i_pixel_35             (o_image_bram[5][47:40]), 
        .i_pixel_36             (o_image_bram[5][55:48]), 
        .i_pixel_37             (o_image_bram[5][63:56]), 
        .i_pixel_38             (o_image_bram[5][71:64]),
        // Row 4
        .i_pixel_40             (o_image_bram[4][7:0]),   
        .i_pixel_41             (o_image_bram[4][15:8]),  
        .i_pixel_42             (o_image_bram[4][23:16]), 
        .i_pixel_43             (o_image_bram[4][31:24]), 
        .i_pixel_44             (o_image_bram[4][39:32]), 
        .i_pixel_45             (o_image_bram[4][47:40]), 
        .i_pixel_46             (o_image_bram[4][55:48]), 
        .i_pixel_47             (o_image_bram[4][63:56]), 
        .i_pixel_48             (o_image_bram[4][71:64]),
        // Row 5
        .i_pixel_50             (o_image_bram[3][7:0]),   
        .i_pixel_51             (o_image_bram[3][15:8]),  
        .i_pixel_52             (o_image_bram[3][23:16]), 
        .i_pixel_53             (o_image_bram[3][31:24]), 
        .i_pixel_54             (o_image_bram[3][39:32]), 
        .i_pixel_55             (o_image_bram[3][47:40]), 
        .i_pixel_56             (o_image_bram[3][55:48]), 
        .i_pixel_57             (o_image_bram[3][63:56]), 
        .i_pixel_58             (o_image_bram[3][71:64]),
        // Row 6
        .i_pixel_60             (o_image_bram[2][7:0]),   
        .i_pixel_61             (o_image_bram[2][15:8]),  
        .i_pixel_62             (o_image_bram[2][23:16]), 
        .i_pixel_63             (o_image_bram[2][31:24]), 
        .i_pixel_64             (o_image_bram[2][39:32]), 
        .i_pixel_65             (o_image_bram[2][47:40]), 
        .i_pixel_66             (o_image_bram[2][55:48]), 
        .i_pixel_67             (o_image_bram[2][63:56]), 
        .i_pixel_68             (o_image_bram[2][71:64]),
        // Row 7
        .i_pixel_70             (o_image_bram[1][7:0]),   
        .i_pixel_71             (o_image_bram[1][15:8]),  
        .i_pixel_72             (o_image_bram[1][23:16]), 
        .i_pixel_73             (o_image_bram[1][31:24]), 
        .i_pixel_74             (o_image_bram[1][39:32]), 
        .i_pixel_75             (o_image_bram[1][47:40]), 
        .i_pixel_76             (o_image_bram[1][55:48]), 
        .i_pixel_77             (o_image_bram[1][63:56]), 
        .i_pixel_78             (o_image_bram[1][71:64]),
        // Row 8
        .i_pixel_80             (o_image_bram[0][7:0]),   
        .i_pixel_81             (o_image_bram[0][15:8]),  
        .i_pixel_82             (o_image_bram[0][23:16]), 
        .i_pixel_83             (o_image_bram[0][31:24]), 
        .i_pixel_84             (o_image_bram[0][39:32]), 
        .i_pixel_85             (o_image_bram[0][47:40]), 
        .i_pixel_86             (o_image_bram[0][55:48]), 
        .i_pixel_87             (o_image_bram[0][63:56]), 
        .i_pixel_88             (o_image_bram[0][71:64]),
        // Output 
        .o_value_median         (median_9x9)
    ); 

    //////////////////////////////////////////////////////////////////////
    ///////                 BRAM FOR MEDIAN RESULT                 /////// 
    //////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////
    ///////                 BRAM FOR 3x3                 /////// 
    ////////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////////////
    ///////                 ADDRESS CALCULATE                 /////// 
    /////////////////////////////////////////////////////////////////
    // Read and write address automatic
    always_ff @(posedge i_clk or posedge enable_3x3) begin
        if (enable_3x3) begin
            addr_cur_3x3_bram <= addr_next_3x3_bram; 
        end
    end
    
    // Addr calculator
    always @(*) begin
        // Enable_3x3 = 1 => check addr_cur_3x3_bram to run next addr.
        //                => assert ready_r2 = 1 in 1 clock at address 40
        //                => assert ready_r4 = 1 in 1 clock at address 48
        // Enable_3x3 = 0 => hold the value addr_cur_3x3_bram.
        //                => assert ready_r2 = 0.
        //                => assert ready_r4 = 0. 
        if (enable_3x3) begin
            // Address add automatically condition
            if (addr_cur_3x3_bram != 48) begin
                addr_next_3x3_bram = addr_cur_3x3_bram + 6'd1;
            end else begin
                addr_next_3x3_bram = 6'd0;
            end 

            // Ready_r2 condition
            if (addr_cur_3x3_bram == 6'd40) begin
                ready_r2 = 1'b1; 
            end else begin
                ready_r2 = 1'b0;
            end 

            // Ready_r4_6_8 condition
            if (addr_cur_3x3_bram == 6'd48) begin
                ready_r4  = 1'b1;
            end else begin
                ready_r4  = 1'b0;
            end
        end else begin
            // Hold addr_cur_3x3_bram + reset ready_r2
            addr_next_3x3_bram = addr_cur_3x3_bram; 
            ready_r2           = 1'b0; 
            ready_r4           = 1'b0;
        end
    end

    // Hold ready_r4 1 clock; 
    always_ff @( posedge i_clk ) begin
        ready_r2_hold <= ready_r2; 
        ready_r4_hold <= ready_r4; 
    end

    assign ready_r6 = ready_r4_hold; 
    assign ready_r8 = ready_r4_hold; 

    ///////////////////////////////////////////////////////////
    ///////                 STORE VALUE                 /////// 
    ///////////////////////////////////////////////////////////
    hold_value #(
        .WIDTH                  (SIZED),
        .SIZE                   (49)
    )bram_median_3x3_result(
        .i_clk                  (i_clk), 
        .i_rst                  (i_rst), 
        .i_enable               (addr_next_3x3_bram), 
        .i_din                  (median_3x3), 

        .o_dout                 (output_49_value_hold)
    );

    ////////////////////////////////////////////////////////////
    ///////                 BRAM FOR 5x5                 /////// 
    ////////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////////////
    ///////                 ADDRESS CALCULATE                 /////// 
    /////////////////////////////////////////////////////////////////
    // Read and write address automatic
    always_ff @(posedge i_clk or posedge enable_5x5) begin
        if (enable_5x5) begin
            addr_cur_5x5_bram <= addr_next_5x5_bram; 
        end
    end

    // Addr calculator
    always @(*) begin
        if (enable_5x5) begin
            if (addr_cur_5x5_bram != 99)
                addr_next_5x5_bram = addr_cur_5x5_bram + 7'd1;
            else
                addr_next_5x5_bram = 7'd0;
        end else begin
            addr_next_5x5_bram = addr_cur_5x5_bram; 
        end
    end

    // Ready singal 
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            ni_rd4_ready <= 1'b0; 
        end else begin
            if (addr_cur_5x5_bram == 87 & enable_5x5) begin
                ni_rd4_ready <= 1'b1; 
            end else begin
                ni_rd4_ready <= 1'b0; 
            end
        end
    end

    // Convert the address
    always_comb begin
        case (addr_next_5x5_bram)
        'd4 /*-'d1*/:       r_addr_hold = 'd0; 
        'd6 /*-'d1*/:       r_addr_hold = 'd1; 
        'd7 /*-'d1*/:       r_addr_hold = 'd2; 
        'd11/*-'d1*/:       r_addr_hold = 'd3; 
        'd12/*-'d1*/:       r_addr_hold = 'd4; 
        'd20/*-'d1*/:       r_addr_hold = 'd5;
        'd31/*-'d1*/:       r_addr_hold = 'd6; 
        'd32/*-'d1*/:       r_addr_hold = 'd7; 
        'd36/*-'d1*/:       r_addr_hold = 'd8;
        'd37/*-'d1*/:       r_addr_hold = 'd9; 
        'd48/*-'d1*/:       r_addr_hold = 'd10; 
        'd56/*-'d1*/:       r_addr_hold = 'd11; 
        'd57/*-'d1*/:       r_addr_hold = 'd12;
        'd61/*-'d1*/:       r_addr_hold = 'd13; 
        'd62/*-'d1*/:       r_addr_hold = 'd14;
        'd69/*-'d1*/:       r_addr_hold = 'd15; 
        'd81/*-'d1*/:       r_addr_hold = 'd16;
        'd82/*-'d1*/:       r_addr_hold = 'd17;
        'd86/*-'d1*/:       r_addr_hold = 'd18;
        'd87/*-'d1*/:       r_addr_hold = 'd19;
            default:  r_addr_hold = 'd20;
        endcase
    end

    ///////////////////////////////////////////////////////////
    ///////                 STORE VALUE                 /////// 
    ///////////////////////////////////////////////////////////
    hold_value #(
        .WIDTH                  (SIZED),
        .SIZE                   (21)     
    )store_value_of_20_value_of_median_5x5(
        .i_clk                  (i_clk), 
        .i_rst                  (i_rst), 
        .i_enable               (r_addr_hold), 
        .i_din                  (median_5x5), 

        .o_dout                 (output_21_value_hold_r4)    
    );

    ////////////////////////////////////////////////////////////
    ///////                 BRAM FOR 7x7                 /////// 
    ////////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////////////
    ///////                 ADDRESS CALCULATE                 /////// 
    /////////////////////////////////////////////////////////////////
    // Hold enable 7x7 signal 1 clock for synthesize data
    always_ff @(posedge i_clk) begin
        enable_7x7_hold <= enable_7x7;
    end
    
    // Read and write address automatic
    always_ff @(posedge i_clk or posedge enable_7x7_hold) begin
        if (enable_7x7_hold) begin
            addr_cur_7x7_bram <= addr_next_7x7_bram; 
        end
    end

    // Addr calculator
    always @(*) begin
        if (enable_7x7_hold) begin
            if (addr_cur_7x7_bram != 323)
                addr_next_7x7_bram = addr_cur_7x7_bram + 9'd1;
            else
                addr_next_7x7_bram = 9'd0;
        end else begin
            addr_next_7x7_bram = addr_cur_7x7_bram; 
        end
    end

    // Ready singal 
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            ni_rd6_ready <= 1'b0; 
        end else begin
            if (addr_cur_7x7_bram == 'd292 & enable_7x7_hold) begin
                ni_rd6_ready <= 1'b1; 
            end else begin
                ni_rd6_ready <= 1'b0; 
            end
        end
    end

    // Convert address 
    always_comb begin
        case (addr_next_7x7_bram)
        'd27 /*-'d1*/ :    r_addr_hold_r6 = 'd0; 
        'd28 /*-'d1*/ :    r_addr_hold_r6 = 'd1; 
        'd30 /*-'d1*/ :    r_addr_hold_r6 = 'd2; 
        'd31 /*-'d1*/ :    r_addr_hold_r6 = 'd3; 
        'd44 /*-'d1*/ :    r_addr_hold_r6 = 'd4; 
        'd90 /*-'d1*/ :    r_addr_hold_r6 = 'd5;
        'd91 /*-'d1*/ :    r_addr_hold_r6 = 'd6; 
        'd93 /*-'d1*/ :    r_addr_hold_r6 = 'd7; 
        'd94 /*-'d1*/ :    r_addr_hold_r6 = 'd8;
        'd116/*-'d1*/ :    r_addr_hold_r6 = 'd9; 
        'd188/*-'d1*/ :    r_addr_hold_r6 = 'd10; 
        'd225/*-'d1*/ :    r_addr_hold_r6 = 'd11; 
        'd226/*-'d1*/ :    r_addr_hold_r6 = 'd12;
        'd228/*-'d1*/ :    r_addr_hold_r6 = 'd13; 
        'd229/*-'d1*/ :    r_addr_hold_r6 = 'd14;
        'd272/*-'d1*/ :    r_addr_hold_r6 = 'd15; 
        'd288/*-'d1*/ :    r_addr_hold_r6 = 'd16;
        'd289/*-'d1*/ :    r_addr_hold_r6 = 'd17;
        'd291/*-'d1*/ :    r_addr_hold_r6 = 'd18;
        'd292/*-'d1*/ :    r_addr_hold_r6 = 'd19;
            default:  r_addr_hold_r6 = 'd20;
        endcase
    end

    ///////////////////////////////////////////////////////////
    ///////                 STORE VALUE                 /////// 
    ///////////////////////////////////////////////////////////
    hold_value #(
        .WIDTH                  (SIZED),
        .SIZE                   (21)     
    )store_value_of_20_value_of_median_7x7(
        .i_clk                  (i_clk), 
        .i_rst                  (i_rst),         
        .i_enable               (r_addr_hold_r6), 
        .i_din                  (median_7x7), 
        .o_dout                 (output_21_value_hold_r6)    
    );

    ////////////////////////////////////////////////////////////
    ///////                 BRAM FOR 9x9                 /////// 
    ////////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////////////
    ///////                 ADDRESS CALCULATE                 /////// 
    /////////////////////////////////////////////////////////////////
    // Hold enable 1 clock
    always_ff @(posedge i_clk) begin
        enable_9x9_hold <= enable_9x9; 
    end

    // Hold enable 2 clock
    always_ff @(posedge i_clk) begin
        enable_9x9_hold_1 <= enable_9x9_hold; 
    end

    // Read and write address automatic
    always_ff @(posedge i_clk or posedge enable_9x9_hold_1) begin
        if (enable_9x9_hold_1) begin
            addr_cur_9x9_bram <= addr_next_9x9_bram; 
        end
    end

    // Addr calculator
    always @(*) begin
        if (enable_9x9_hold_1) begin
            if (addr_cur_9x9_bram != 323)
                addr_next_9x9_bram = addr_cur_9x9_bram + 9'd1;
            else
                addr_next_9x9_bram = 9'd0;
        end else begin
            addr_next_9x9_bram = addr_cur_9x9_bram; 
        end
    end

    // Ready singal 
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            ni_rd8_ready <= 1'b0; 
        end else begin
            if (addr_cur_9x9_bram == 'd301 & enable_9x9_hold_1) begin
                ni_rd8_ready <= 1'b1; 
            end else begin
                ni_rd8_ready <= 1'b0; 
            end
        end
    end

    // Convert the address from bram
    always_comb begin
        case (addr_next_9x9_bram)
        'd16 /*-'d1*/ :    r_addr_hold_r8 = 'd0; 
        'd17 /*-'d1*/ :    r_addr_hold_r8 = 'd1; 
        'd18 /*-'d1*/ :    r_addr_hold_r8 = 'd2; 
        'd19 /*-'d1*/ :    r_addr_hold_r8 = 'd3; 
        'd40 /*-'d1*/ :    r_addr_hold_r8 = 'd4; 
        'd84 /*-'d1*/ :    r_addr_hold_r8 = 'd5;
        'd85 /*-'d1*/ :    r_addr_hold_r8 = 'd6; 
        'd86 /*-'d1*/ :    r_addr_hold_r8 = 'd7; 
        'd87 /*-'d1*/ :    r_addr_hold_r8 = 'd8;
        'd120/*-'d1*/ :    r_addr_hold_r8 = 'd9; 
        'd200/*-'d1*/ :    r_addr_hold_r8 = 'd10; 
        'd222/*-'d1*/ :    r_addr_hold_r8 = 'd11; 
        'd223/*-'d1*/ :    r_addr_hold_r8 = 'd12;
        'd232/*-'d1*/ :    r_addr_hold_r8 = 'd13; 
        'd233/*-'d1*/ :    r_addr_hold_r8 = 'd14;
        'd280/*-'d1*/ :    r_addr_hold_r8 = 'd15; 
        'd290/*-'d1*/ :    r_addr_hold_r8 = 'd16;
        'd291/*-'d1*/ :    r_addr_hold_r8 = 'd17;
        'd300/*-'d1*/ :    r_addr_hold_r8 = 'd18;
        'd301/*-'d1*/ :    r_addr_hold_r8 = 'd19;
            default:  r_addr_hold_r8 = 'd20;
        endcase
    end

    ///////////////////////////////////////////////////////////
    ///////                 STORE VALUE                 /////// 
    ///////////////////////////////////////////////////////////
    hold_value #(
        .WIDTH                  (SIZED),
        .SIZE                   (21)     
    )store_value_of_20_value_of_median_9x9(
        .i_clk                  (i_clk), 
        .i_rst                  (i_rst),         
        .i_enable               (r_addr_hold_r8), 
        .i_din                  (median_9x9), 
        .o_dout                 (output_21_value_hold_r8)  
    );
    /////////////////////////////////////////////////////////////
    ///////                 CI CALCULATOR                 /////// 
    /////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////
    ///////                 CI_2                 /////// 
    ////////////////////////////////////////////////////
    CI_2#(
        .WIDTH                  (SIZED)
    )ci_2_calculator(
        // row pixel input 1
        .i_pixel_11             (output_49_value_hold[8]), 
        .i_pixel_12             (output_49_value_hold[9]), 
        .i_pixel_13             (output_49_value_hold[10]), 
        .i_pixel_14             (output_49_value_hold[11]), 
        .i_pixel_15             (output_49_value_hold[12]),
        // row pixel input 2
        .i_pixel_21             (output_49_value_hold[15]), 
        .i_pixel_22             (output_49_value_hold[16]), 
        .i_pixel_23             (output_49_value_hold[17]), 
        .i_pixel_24             (output_49_value_hold[18]), 
        .i_pixel_25             (output_49_value_hold[19]),
        // row pixel input 3
        .i_pixel_31             (output_49_value_hold[22]), 
        .i_pixel_32             (output_49_value_hold[23]), 
        .i_pixel_33             (output_49_value_hold[24]), 
        .i_pixel_34             (output_49_value_hold[25]), 
        .i_pixel_35             (output_49_value_hold[26]),
        // row pixel input 4
        .i_pixel_41             (output_49_value_hold[29]), 
        .i_pixel_42             (output_49_value_hold[30]), 
        .i_pixel_43             (output_49_value_hold[31]), 
        .i_pixel_44             (output_49_value_hold[32]), 
        .i_pixel_45             (output_49_value_hold[33]),
        // row pixel input 5
        .i_pixel_51             (output_49_value_hold[36]), 
        .i_pixel_52             (output_49_value_hold[37]), 
        .i_pixel_53             (output_49_value_hold[38]), 
        .i_pixel_54             (output_49_value_hold[39]), 
        .i_pixel_55             (output_49_value_hold[40]),
        // row output conver to logic 1 (normalization)
        .o_ci_00                (ci_2[0]), 
        .o_ci_01                (ci_2[1]), 
        .o_ci_02                (ci_2[2]), 
        .o_ci_03                (ci_2[3]), 
        .o_ci_04                (ci_2[4]),
        // row output conver to logic 2 (normalization)
        .o_ci_10                (ci_2[5]), 
        .o_ci_11                (ci_2[6]), 
        .o_ci_12                (ci_2[7]), 
        .o_ci_13                (ci_2[8]), 
        .o_ci_14                (ci_2[9]),
        // row output conver to logic 3 (normalization)
        .o_ci_20                (ci_2[10]), 
        .o_ci_21                (ci_2[11]), 
        .o_ci_22                (ci_2[12]), 
        .o_ci_23                (ci_2[13]), 
        .o_ci_24                (ci_2[14]),
        // row output conver to logic 4 (normalization)
        .o_ci_30                (ci_2[15]), 
        .o_ci_31                (ci_2[16]), 
        .o_ci_32                (ci_2[17]), 
        .o_ci_33                (ci_2[18]), 
        .o_ci_34                (ci_2[19]),
        // row output conver to logic 5 (normalization)
        .o_ci_40                (ci_2[20]), 
        .o_ci_41                (ci_2[21]), 
        .o_ci_42                (ci_2[22]), 
        .o_ci_43                (ci_2[23]), 
        .o_ci_44                (ci_2[24])
    );

    ////////////////////////////////////////////////////
    ///////                 CI_4                 /////// 
    ////////////////////////////////////////////////////
    CI_4#(
        .WIDTH                  (SIZED)
    )ci_4_calculator(
        // Row pixel input 1 
        .i_pixel_00             (output_49_value_hold[0]), 
        .i_pixel_01             (output_49_value_hold[1]), 
        .i_pixel_02             (output_49_value_hold[2]), 
        .i_pixel_03             (output_49_value_hold[3]), 
        .i_pixel_04             (output_49_value_hold[4]), 
        .i_pixel_05             (output_49_value_hold[5]), 
        .i_pixel_06             (output_49_value_hold[6]),
        // Row pixel input 2 
        .i_pixel_10             (output_49_value_hold[7]), 
        .i_pixel_11             (output_49_value_hold[8]), 
        .i_pixel_12             (output_49_value_hold[9]), 
        .i_pixel_13             (output_49_value_hold[10]), 
        .i_pixel_14             (output_49_value_hold[11]), 
        .i_pixel_15             (output_49_value_hold[12]), 
        .i_pixel_16             (output_49_value_hold[13]),
        // Row pixel input 3 
        .i_pixel_20             (output_49_value_hold[14]),
        .i_pixel_21             (output_49_value_hold[15]),
        .i_pixel_22             (output_49_value_hold[16]),
        .i_pixel_23             (output_49_value_hold[17]),
        .i_pixel_24             (output_49_value_hold[18]),
        .i_pixel_25             (output_49_value_hold[19]),
        .i_pixel_26             (output_49_value_hold[20]),
        // Row pixel input 4 
        .i_pixel_30             (output_49_value_hold[21]),
        .i_pixel_31             (output_49_value_hold[22]),
        .i_pixel_32             (output_49_value_hold[23]),
        .i_pixel_33             (output_49_value_hold[24]),
        .i_pixel_34             (output_49_value_hold[25]),
        .i_pixel_35             (output_49_value_hold[26]),
        .i_pixel_36             (output_49_value_hold[27]),
        // Row pixel input 5
        .i_pixel_40             (output_49_value_hold[28]),
        .i_pixel_41             (output_49_value_hold[29]),
        .i_pixel_42             (output_49_value_hold[30]),
        .i_pixel_43             (output_49_value_hold[31]),
        .i_pixel_44             (output_49_value_hold[32]),
        .i_pixel_45             (output_49_value_hold[33]),
        .i_pixel_46             (output_49_value_hold[34]),
        // Row pixel input 6 
        .i_pixel_50             (output_49_value_hold[35]), 
        .i_pixel_51             (output_49_value_hold[36]), 
        .i_pixel_52             (output_49_value_hold[37]), 
        .i_pixel_53             (output_49_value_hold[38]), 
        .i_pixel_54             (output_49_value_hold[39]), 
        .i_pixel_55             (output_49_value_hold[40]), 
        .i_pixel_56             (output_49_value_hold[41]),
        // Row pixel input 7 
        .i_pixel_60             (output_49_value_hold[42]), 
        .i_pixel_61             (output_49_value_hold[43]), 
        .i_pixel_62             (output_49_value_hold[44]), 
        .i_pixel_63             (output_49_value_hold[45]), 
        .i_pixel_64             (output_49_value_hold[46]), 
        .i_pixel_65             (output_49_value_hold[47]), 
        .i_pixel_66             (output_49_value_hold[48]),
        // Row output conver to logic 1 (normalization)
        .o_ci_00                (ci_4[0]),
        .o_ci_01                (ci_4[1]),
        .o_ci_02                (ci_4[2]),
        .o_ci_03                (ci_4[3]),
        .o_ci_04                (ci_4[4]),
        .o_ci_05                (ci_4[5]),
        .o_ci_06                (ci_4[6]),
        // Row output conver to logic 2 (normalization)
        .o_ci_10                (ci_4[7]),
        .o_ci_11                (ci_4[8]),
        .o_ci_12                (ci_4[9]),
        .o_ci_13                (ci_4[10]),
        .o_ci_14                (ci_4[11]),
        .o_ci_15                (ci_4[12]),
        .o_ci_16                (ci_4[13]),
        // Row output conver to logic 3 (normalization)
        .o_ci_20                (ci_4[14]),
        .o_ci_21                (ci_4[15]),
        .o_ci_22                (ci_4[16]),
        .o_ci_23                (ci_4[17]),
        .o_ci_24                (ci_4[18]),
        .o_ci_25                (ci_4[19]),
        .o_ci_26                (ci_4[20]),
        // Row output conver to logic 4 (normalization)
        .o_ci_30                (ci_4[21]),
        .o_ci_31                (ci_4[22]),
        .o_ci_32                (ci_4[23]),
        .o_ci_33                (ci_4[24]),
        .o_ci_34                (ci_4[25]),
        .o_ci_35                (ci_4[26]),
        .o_ci_36                (ci_4[27]),
        // Row output conver to logic 5 (normalization)
        .o_ci_40                (ci_4[28]),
        .o_ci_41                (ci_4[29]),
        .o_ci_42                (ci_4[30]),
        .o_ci_43                (ci_4[31]),
        .o_ci_44                (ci_4[32]),
        .o_ci_45                (ci_4[33]),
        .o_ci_46                (ci_4[34]),
        // Row output conver to logic 6 (normalization)
        .o_ci_50                (ci_4[35]),
        .o_ci_51                (ci_4[36]),
        .o_ci_52                (ci_4[37]),
        .o_ci_53                (ci_4[38]),
        .o_ci_54                (ci_4[39]),
        .o_ci_55                (ci_4[40]),
        .o_ci_56                (ci_4[41]),
        // Row output conver to logic 7 (normalization)
        .o_ci_60                (ci_4[42]),
        .o_ci_61                (ci_4[43]),
        .o_ci_62                (ci_4[44]),
        .o_ci_63                (ci_4[45]),
        .o_ci_64                (ci_4[46]),
        .o_ci_65                (ci_4[47]),
        .o_ci_66                (ci_4[48]) 
    ); 

    ////////////////////////////////////////////////////
    ///////                 CI_6                 /////// 
    ////////////////////////////////////////////////////
    CI_6#(
        .WIDTH                  (SIZED)
    )ci_6_calculator(
        // Row pixel input 1 
        .i_pixel_00             (output_49_value_hold[0]), 
        .i_pixel_01             (output_49_value_hold[1]), 
        .i_pixel_02             (output_49_value_hold[2]), 
        .i_pixel_03             (output_49_value_hold[3]), 
        .i_pixel_04             (output_49_value_hold[4]), 
        .i_pixel_05             (output_49_value_hold[5]), 
        .i_pixel_06             (output_49_value_hold[6]),
        // Row pixel input 2 
        .i_pixel_10             (output_49_value_hold[7]), 
        .i_pixel_11             (output_49_value_hold[8]), 
        .i_pixel_12             (output_49_value_hold[9]), 
        .i_pixel_13             (output_49_value_hold[10]), 
        .i_pixel_14             (output_49_value_hold[11]), 
        .i_pixel_15             (output_49_value_hold[12]), 
        .i_pixel_16             (output_49_value_hold[13]),
        // Row pixel input 3 
        .i_pixel_20             (output_49_value_hold[14]),
        .i_pixel_21             (output_49_value_hold[15]),
        .i_pixel_22             (output_49_value_hold[16]),
        .i_pixel_23             (output_49_value_hold[17]),
        .i_pixel_24             (output_49_value_hold[18]),
        .i_pixel_25             (output_49_value_hold[19]),
        .i_pixel_26             (output_49_value_hold[20]),
        // Row pixel input 4 
        .i_pixel_30             (output_49_value_hold[21]),
        .i_pixel_31             (output_49_value_hold[22]),
        .i_pixel_32             (output_49_value_hold[23]),
        .i_pixel_33             (output_49_value_hold[24]),
        .i_pixel_34             (output_49_value_hold[25]),
        .i_pixel_35             (output_49_value_hold[26]),
        .i_pixel_36             (output_49_value_hold[27]),
        // Row pixel input 5
        .i_pixel_40             (output_49_value_hold[28]),
        .i_pixel_41             (output_49_value_hold[29]),
        .i_pixel_42             (output_49_value_hold[30]),
        .i_pixel_43             (output_49_value_hold[31]),
        .i_pixel_44             (output_49_value_hold[32]),
        .i_pixel_45             (output_49_value_hold[33]),
        .i_pixel_46             (output_49_value_hold[34]),
        // Row pixel input 6 
        .i_pixel_50             (output_49_value_hold[35]), 
        .i_pixel_51             (output_49_value_hold[36]), 
        .i_pixel_52             (output_49_value_hold[37]), 
        .i_pixel_53             (output_49_value_hold[38]), 
        .i_pixel_54             (output_49_value_hold[39]), 
        .i_pixel_55             (output_49_value_hold[40]), 
        .i_pixel_56             (output_49_value_hold[41]),
        // Row pixel input 7 
        .i_pixel_60             (output_49_value_hold[42]), 
        .i_pixel_61             (output_49_value_hold[43]), 
        .i_pixel_62             (output_49_value_hold[44]), 
        .i_pixel_63             (output_49_value_hold[45]), 
        .i_pixel_64             (output_49_value_hold[46]), 
        .i_pixel_65             (output_49_value_hold[47]), 
        .i_pixel_66             (output_49_value_hold[48]),
        // Row output conver to logic 1 (normalization)
        .o_ci_00                (ci_6[0]),
        .o_ci_01                (ci_6[1]),
        .o_ci_02                (ci_6[2]),
        .o_ci_03                (ci_6[3]),
        .o_ci_04                (ci_6[4]),
        .o_ci_05                (ci_6[5]),
        .o_ci_06                (ci_6[6]),
        // Row output conver to logic 2 (normalization)
        .o_ci_10                (ci_6[7]),
        .o_ci_11                (ci_6[8]),
        .o_ci_12                (ci_6[9]),
        .o_ci_13                (ci_6[10]),
        .o_ci_14                (ci_6[11]),
        .o_ci_15                (ci_6[12]),
        .o_ci_16                (ci_6[13]),
        // Row output conver to logic 3 (normalization)
        .o_ci_20                (ci_6[14]),
        .o_ci_21                (ci_6[15]),
        .o_ci_22                (ci_6[16]),
        .o_ci_23                (ci_6[17]),
        .o_ci_24                (ci_6[18]),
        .o_ci_25                (ci_6[19]),
        .o_ci_26                (ci_6[20]),
        // Row output conver to logic 4 (normalization)
        .o_ci_30                (ci_6[21]),
        .o_ci_31                (ci_6[22]),
        .o_ci_32                (ci_6[23]),
        .o_ci_33                (ci_6[24]),
        .o_ci_34                (ci_6[25]),
        .o_ci_35                (ci_6[26]),
        .o_ci_36                (ci_6[27]),
        // Row output conver to logic 5 (normalization)
        .o_ci_40                (ci_6[28]),
        .o_ci_41                (ci_6[29]),
        .o_ci_42                (ci_6[30]),
        .o_ci_43                (ci_6[31]),
        .o_ci_44                (ci_6[32]),
        .o_ci_45                (ci_6[33]),
        .o_ci_46                (ci_6[34]),
        // Row output conver to logic 6 (normalization)
        .o_ci_50                (ci_6[35]),
        .o_ci_51                (ci_6[36]),
        .o_ci_52                (ci_6[37]),
        .o_ci_53                (ci_6[38]),
        .o_ci_54                (ci_6[39]),
        .o_ci_55                (ci_6[40]),
        .o_ci_56                (ci_6[41]),
        // Row output conver to logic 7 (normalization)
        .o_ci_60                (ci_6[42]),
        .o_ci_61                (ci_6[43]),
        .o_ci_62                (ci_6[44]),
        .o_ci_63                (ci_6[45]),
        .o_ci_64                (ci_6[46]),
        .o_ci_65                (ci_6[47]),
        .o_ci_66                (ci_6[48]) 
    ); 

    ////////////////////////////////////////////////////
    ///////                 CI_8                 /////// 
    ////////////////////////////////////////////////////
    CI_8#(
        .WIDTH                  (SIZED)
    )ci_8_calculator(
        // Row pixel input 1 
        .i_pixel_00             (output_49_value_hold[0]), 
        .i_pixel_01             (output_49_value_hold[1]), 
        .i_pixel_02             (output_49_value_hold[2]), 
        .i_pixel_03             (output_49_value_hold[3]), 
        .i_pixel_04             (output_49_value_hold[4]), 
        .i_pixel_05             (output_49_value_hold[5]), 
        .i_pixel_06             (output_49_value_hold[6]),
        // Row pixel input 2 
        .i_pixel_10             (output_49_value_hold[7]), 
        .i_pixel_11             (output_49_value_hold[8]), 
        .i_pixel_12             (output_49_value_hold[9]), 
        .i_pixel_13             (output_49_value_hold[10]), 
        .i_pixel_14             (output_49_value_hold[11]), 
        .i_pixel_15             (output_49_value_hold[12]), 
        .i_pixel_16             (output_49_value_hold[13]),
        // Row pixel input 3 
        .i_pixel_20             (output_49_value_hold[14]),
        .i_pixel_21             (output_49_value_hold[15]),
        .i_pixel_22             (output_49_value_hold[16]),
        .i_pixel_23             (output_49_value_hold[17]),
        .i_pixel_24             (output_49_value_hold[18]),
        .i_pixel_25             (output_49_value_hold[19]),
        .i_pixel_26             (output_49_value_hold[20]),
        // Row pixel input 4 
        .i_pixel_30             (output_49_value_hold[21]),
        .i_pixel_31             (output_49_value_hold[22]),
        .i_pixel_32             (output_49_value_hold[23]),
        .i_pixel_33             (output_49_value_hold[24]),
        .i_pixel_34             (output_49_value_hold[25]),
        .i_pixel_35             (output_49_value_hold[26]),
        .i_pixel_36             (output_49_value_hold[27]),
        // Row pixel input 5
        .i_pixel_40             (output_49_value_hold[28]),
        .i_pixel_41             (output_49_value_hold[29]),
        .i_pixel_42             (output_49_value_hold[30]),
        .i_pixel_43             (output_49_value_hold[31]),
        .i_pixel_44             (output_49_value_hold[32]),
        .i_pixel_45             (output_49_value_hold[33]),
        .i_pixel_46             (output_49_value_hold[34]),
        // Row pixel input 6 
        .i_pixel_50             (output_49_value_hold[35]), 
        .i_pixel_51             (output_49_value_hold[36]), 
        .i_pixel_52             (output_49_value_hold[37]), 
        .i_pixel_53             (output_49_value_hold[38]), 
        .i_pixel_54             (output_49_value_hold[39]), 
        .i_pixel_55             (output_49_value_hold[40]), 
        .i_pixel_56             (output_49_value_hold[41]),
        // Row pixel input 7 
        .i_pixel_60             (output_49_value_hold[42]), 
        .i_pixel_61             (output_49_value_hold[43]), 
        .i_pixel_62             (output_49_value_hold[44]), 
        .i_pixel_63             (output_49_value_hold[45]), 
        .i_pixel_64             (output_49_value_hold[46]), 
        .i_pixel_65             (output_49_value_hold[47]), 
        .i_pixel_66             (output_49_value_hold[48]),
        // Row output conver to logic 1 (normalization)
        .o_ci_00                (ci_8[0]),
        .o_ci_01                (ci_8[1]),
        .o_ci_02                (ci_8[2]),
        .o_ci_03                (ci_8[3]),
        .o_ci_04                (ci_8[4]),
        .o_ci_05                (ci_8[5]),
        .o_ci_06                (ci_8[6]),
        // Row output conver to logic 2 (normalization)
        .o_ci_10                (ci_8[7]),
        .o_ci_11                (ci_8[8]),
        .o_ci_12                (ci_8[9]),
        .o_ci_13                (ci_8[10]),
        .o_ci_14                (ci_8[11]),
        .o_ci_15                (ci_8[12]),
        .o_ci_16                (ci_8[13]),
        // Row output conver to logic 3 (normalization)
        .o_ci_20                (ci_8[14]),
        .o_ci_21                (ci_8[15]),
        .o_ci_22                (ci_8[16]),
        .o_ci_23                (ci_8[17]),
        .o_ci_24                (ci_8[18]),
        .o_ci_25                (ci_8[19]),
        .o_ci_26                (ci_8[20]),
        // Row output conver to logic 4 (normalization)
        .o_ci_30                (ci_8[21]),
        .o_ci_31                (ci_8[22]),
        .o_ci_32                (ci_8[23]),
        .o_ci_33                (ci_8[24]),
        .o_ci_34                (ci_8[25]),
        .o_ci_35                (ci_8[26]),
        .o_ci_36                (ci_8[27]),
        // Row output conver to logic 5 (normalization)
        .o_ci_40                (ci_8[28]),
        .o_ci_41                (ci_8[29]),
        .o_ci_42                (ci_8[30]),
        .o_ci_43                (ci_8[31]),
        .o_ci_44                (ci_8[32]),
        .o_ci_45                (ci_8[33]),
        .o_ci_46                (ci_8[34]),
        // Row output conver to logic 6 (normalization)
        .o_ci_50                (ci_8[35]),
        .o_ci_51                (ci_8[36]),
        .o_ci_52                (ci_8[37]),
        .o_ci_53                (ci_8[38]),
        .o_ci_54                (ci_8[39]),
        .o_ci_55                (ci_8[40]),
        .o_ci_56                (ci_8[41]),
        // Row output conver to logic 7 (normalization)
        .o_ci_60                (ci_8[42]),
        .o_ci_61                (ci_8[43]),
        .o_ci_62                (ci_8[44]),
        .o_ci_63                (ci_8[45]),
        .o_ci_64                (ci_8[46]),
        .o_ci_65                (ci_8[47]),
        .o_ci_66                (ci_8[48]) 
    ); 

    /////////////////////////////////////////////////////////////
    ///////                 CI HISTORGRAM                 /////// 
    /////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////
    ///////                 R=2                 /////// 
    ///////////////////////////////////////////////////
    ci_histogram #(
        .WIDTH_DATA             (24),
        .WIDTH_CALULATE         (25)
    )ci_r2_histogram(
        .i_clk                  (i_clk), 
        .i_rst                  (i_rst), 
        .i_wren                 (ready_r2_hold & !i_done_load_data_r2), 
        .i_din                  (ci_2), 

        .o_rdata_0              (rdata_0_r2), 
        .o_rdata_1              (rdata_1_r2)
    ); 
    ///////////////////////////////////////////////////
    ///////                 R=4                 /////// 
    ///////////////////////////////////////////////////
    ci_histogram #(
        .WIDTH_DATA             (24),
        .WIDTH_CALULATE         (49)
    )ci_r4_histogram(
        .i_clk                  (i_clk), 
        .i_rst                  (i_rst), 
        .i_wren                 (ready_r4_hold & !i_done_load_data_r2), 
        .i_din                  (ci_4), 
        .o_rdata_0              (rdata_0_r4), 
        .o_rdata_1              (rdata_1_r4)
    );

    ///////////////////////////////////////////////////
    ///////                 R=6                 /////// 
    ///////////////////////////////////////////////////
    ci_histogram #(
        .WIDTH_DATA             (24),
        .WIDTH_CALULATE         (49)
    )ci_r6_histogram(
        .i_clk                  (i_clk), 
        .i_rst                  (i_rst), 
        .i_wren                 (ready_r6 & !i_done_load_data_r2), 
        .i_din                  (ci_6), 

        .o_rdata_0              (rdata_0_r6), 
        .o_rdata_1              (rdata_1_r6)
    );    

    ///////////////////////////////////////////////////
    ///////                 R=8                 /////// 
    ///////////////////////////////////////////////////
    ci_histogram #(
        .WIDTH_DATA             (24),
        .WIDTH_CALULATE         (49)
    )ci_r8_histogram(
        .i_clk                  (i_clk), 
        .i_rst                  (i_rst), 
        .i_wren                 (ready_r8 & !i_done_load_data_r2), 
        .i_din                  (ci_8), 
 
        .o_rdata_0              (rdata_0_r8), 
        .o_rdata_1              (rdata_1_r8)
    );

    ////////////////////////////////////////////////////////////////////////
    ///////                 INTERPOLATION CALCULATOR                 /////// 
    ////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////
    ///////                 R=2                 /////// 
    ///////////////////////////////////////////////////
    interpolation_2 #(
        .WIDTH                  (SIZED), 
        .FIXED                  (FIXED)
    )inter_2(
        // Row input pixel 0
        .i_pixel_00             (output_49_value_hold[8]),
        .i_pixel_01             (output_49_value_hold[9]),
        .i_pixel_02             (output_49_value_hold[10]),
        .i_pixel_03             (output_49_value_hold[11]),
        .i_pixel_04             (output_49_value_hold[12]),
        // Row input pixel 1
        .i_pixel_10             (output_49_value_hold[15]),
        .i_pixel_11             (output_49_value_hold[16]),
        .i_pixel_13             (output_49_value_hold[18]),
        .i_pixel_14             (output_49_value_hold[19]),
        // Row input pixel 2
        .i_pixel_20             (output_49_value_hold[22]),
        .i_pixel_22             (output_49_value_hold[24]),
        .i_pixel_24             (output_49_value_hold[26]),
        // Row input pixel 3
        .i_pixel_30             (output_49_value_hold[29]),
        .i_pixel_31             (output_49_value_hold[30]),
        .i_pixel_33             (output_49_value_hold[32]),
        .i_pixel_34             (output_49_value_hold[33]),
        // Row input pixel 4
        .i_pixel_40             (output_49_value_hold[36]),
        .i_pixel_41             (output_49_value_hold[37]),
        .i_pixel_42             (output_49_value_hold[38]),
        .i_pixel_43             (output_49_value_hold[39]),
        .i_pixel_44             (output_49_value_hold[40]),

        // Output of central pixel
        .o_pixel_center         (pixel_center),
        // 4 normal points
        .o_q_ne_0               (q_ne_even_r2[0]), 
        .o_q_ne_2               (q_ne_even_r2[1]), 
        .o_q_ne_4               (q_ne_even_r2[2]), 
        .o_q_ne_6               (q_ne_even_r2[3]),
        // 4 interpolation points
        .o_q_ne_1               (q_ne_odd_r2[0]), 
        .o_q_ne_3               (q_ne_odd_r2[1]), 
        .o_q_ne_5               (q_ne_odd_r2[2]), 
        .o_q_ne_7               (q_ne_odd_r2[3])
    ); 

    ///////////////////////////////////////////////////
    ///////                 R=4                 /////// 
    ///////////////////////////////////////////////////
    interpolation_4 #(
        .WIDTH                  (SIZED), 
        .FIXED                  (FIXED)
    )inter_4(
        // Input   
        .i_pixel_04             (output_21_value_hold_r4[0]),
        .i_pixel_11             (output_21_value_hold_r4[1]),
        .i_pixel_12             (output_21_value_hold_r4[2]),
        .i_pixel_16             (output_21_value_hold_r4[6]),
        .i_pixel_17             (output_21_value_hold_r4[7]),
        .i_pixel_21             (output_21_value_hold_r4[3]),
        .i_pixel_22             (output_21_value_hold_r4[4]),
        .i_pixel_26             (output_21_value_hold_r4[8]), 
        .i_pixel_27             (output_21_value_hold_r4[9]),
        .i_pixel_40             (output_21_value_hold_r4[5]),                                                                                    
        .i_pixel_48             (output_21_value_hold_r4[10]),
        .i_pixel_61             (output_21_value_hold_r4[11]), 
        .i_pixel_62             (output_21_value_hold_r4[12]),                                     
        .i_pixel_66             (output_21_value_hold_r4[16]), 
        .i_pixel_67             (output_21_value_hold_r4[17]),
        .i_pixel_71             (output_21_value_hold_r4[13]), 
        .i_pixel_72             (output_21_value_hold_r4[14]),                                     
        .i_pixel_76             (output_21_value_hold_r4[18]), 
        .i_pixel_77             (output_21_value_hold_r4[19]),
        .i_pixel_84             (output_21_value_hold_r4[15]), 
        // Output
        .o_q_ne_0               (q_ne_even_r4[0]), 
        .o_q_ne_2               (q_ne_even_r4[1]), 
        .o_q_ne_4               (q_ne_even_r4[2]), 
        .o_q_ne_6               (q_ne_even_r4[3]),
        .o_q_ne_1               (q_ne_odd_r4[0]), 
        .o_q_ne_3               (q_ne_odd_r4[1]), 
        .o_q_ne_5               (q_ne_odd_r4[2]), 
        .o_q_ne_7               (q_ne_odd_r4[3])
    ); 

    ///////////////////////////////////////////////////
    ///////                 R=6                 /////// 
    ///////////////////////////////////////////////////
    // Interpolation
    interpolation_6 #(
        .WIDTH                  (SIZED), 
        .FIXED                  (FIXED)
    )inter_6(
        // Input
        .i_pixel_06             (output_21_value_hold_r6[4]), 
        .i_pixel_11             (output_21_value_hold_r6[0]), 
        .i_pixel_12             (output_21_value_hold_r6[1]),
        .i_pixel_21             (output_21_value_hold_r6[2]), 
        .i_pixel_22             (output_21_value_hold_r6[3]),
        .i_pixel_110            (output_21_value_hold_r6[5]), 
        .i_pixel_1_11           (output_21_value_hold_r6[6]),
        .i_pixel_210            (output_21_value_hold_r6[7]), 
        .i_pixel_211            (output_21_value_hold_r6[8]),
        .i_pixel_60             (output_21_value_hold_r6[9]),
        .i_pixel_612            (output_21_value_hold_r6[10]), 
        .i_pixel_101            (output_21_value_hold_r6[11]),  
        .i_pixel_102            (output_21_value_hold_r6[12]), 
        .i_pixel_11_1           (output_21_value_hold_r6[13]), 
        .i_pixel_112            (output_21_value_hold_r6[14]),
        .i_pixel_126            (output_21_value_hold_r6[15]),
        .i_pixel_1010           (output_21_value_hold_r6[16]), 
        .i_pixel_1011           (output_21_value_hold_r6[17]),
        .i_pixel_1110           (output_21_value_hold_r6[18]), 
        .i_pixel_1111           (output_21_value_hold_r6[19]),
        // Output
        .o_q_ne_0               (q_ne_even_r6[0]), 
        .o_q_ne_2               (q_ne_even_r6[1]), 
        .o_q_ne_4               (q_ne_even_r6[2]), 
        .o_q_ne_6               (q_ne_even_r6[3]),
        .o_q_ne_1               (q_ne_odd_r6[0]), 
        .o_q_ne_3               (q_ne_odd_r6[1]), 
        .o_q_ne_5               (q_ne_odd_r6[2]), 
        .o_q_ne_7               (q_ne_odd_r6[3]) 
    ); 

    ///////////////////////////////////////////////////
    ///////                 R=8                 /////// 
    ///////////////////////////////////////////////////
    interpolation_8 #(
        .WIDTH                  (SIZED), 
        .FIXED                  (FIXED)
    )inter_8(   
        // Input
        .i_pixel_08             (output_21_value_hold_r8[4]),
        .i_pixel_22             (output_21_value_hold_r8[0]), 
        .i_pixel_23             (output_21_value_hold_r8[1]),
        .i_pixel_32             (output_21_value_hold_r8[2]), 
        .i_pixel_33             (output_21_value_hold_r8[3]),
        .i_pixel_213            (output_21_value_hold_r8[5]), 
        .i_pixel_214            (output_21_value_hold_r8[6]),
        .i_pixel_313            (output_21_value_hold_r8[7]), 
        .i_pixel_314            (output_21_value_hold_r8[8]),
        .i_pixel_80             (output_21_value_hold_r8[9]), 
        .i_pixel_816            (output_21_value_hold_r8[10]), 
        .i_pixel_132            (output_21_value_hold_r8[11]), 
        .i_pixel_133            (output_21_value_hold_r8[12]),
        .i_pixel_142            (output_21_value_hold_r8[13]), 
        .i_pixel_143            (output_21_value_hold_r8[14]),
        .i_pixel_168            (output_21_value_hold_r8[15]), 
        .i_pixel_1313           (output_21_value_hold_r8[16]), 
        .i_pixel_1314           (output_21_value_hold_r8[17]),
        .i_pixel_1413           (output_21_value_hold_r8[18]), 
        .i_pixel_1414           (output_21_value_hold_r8[19]),
        // Output
        .o_q_ne_0               (q_ne_even_r8[0]), 
        .o_q_ne_2               (q_ne_even_r8[1]), 
        .o_q_ne_4               (q_ne_even_r8[2]), 
        .o_q_ne_6               (q_ne_even_r8[3]),
        .o_q_ne_1               (q_ne_odd_r8[0]), 
        .o_q_ne_3               (q_ne_odd_r8[1]), 
        .o_q_ne_5               (q_ne_odd_r8[2]), 
        .o_q_ne_7               (q_ne_odd_r8[3]) 
    );  

    //////////////////////////////////////////////////////////////////
    ///////                 NI + RD CALCULATOR                 /////// 
    //////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////
    ///////                 R=2                 /////// 
    ///////////////////////////////////////////////////
    ni_rd_2 #(
        .WIDTH                  (SIZED), 
        .FIXED                  (FIXED)
    )ni_rd_r2(
        // Input
        .i_pixel_center         (pixel_center), 
        .i_q_ne_0               (q_ne_even_r2[0]), 
        .i_q_ne_2               (q_ne_even_r2[1]), 
        .i_q_ne_4               (q_ne_even_r2[2]), 
        .i_q_ne_6               (q_ne_even_r2[3]),
        .i_q_ne_1               (q_ne_odd_r2[0]), 
        .i_q_ne_3               (q_ne_odd_r2[1]), 
        .i_q_ne_5               (q_ne_odd_r2[2]), 
        .i_q_ne_7               (q_ne_odd_r2[3]),
        // Output 
        // .o_average              (average_r2), 
        .o_ni                   (ni_r2), 
        .o_rd                   (rd_r2)
    ); 

    // Hold 1 clock
    always_ff @(posedge i_clk) begin
        if (ready_r2_hold) begin
            ni_r2_hold <= ni_r2; 
            rd_r2_hold <= rd_r2; 
        end 
    end

    ///////////////////////////////////////////////////
    ///////                 R=4                 /////// 
    ///////////////////////////////////////////////////
    ni_rd #(
        .WIDTH                  (SIZED), 
        .FIXED                  (FIXED)
    )ni_rd_r4(
        // R1
        .i_q_ne_0_1             (q_ne_even_r2[0]), 
        .i_q_ne_2_1             (q_ne_even_r2[1]), 
        .i_q_ne_4_1             (q_ne_even_r2[2]), 
        .i_q_ne_6_1             (q_ne_even_r2[3]),
        .i_q_ne_1_1             (q_ne_odd_r2[0]), 
        .i_q_ne_3_1             (q_ne_odd_r2[1]), 
        .i_q_ne_5_1             (q_ne_odd_r2[2]), 
        .i_q_ne_7_1             (q_ne_odd_r2[3]),
        // R2
        .i_q_ne_0_2             (q_ne_even_r4[0]), 
        .i_q_ne_2_2             (q_ne_even_r4[1]), 
        .i_q_ne_4_2             (q_ne_even_r4[2]), 
        .i_q_ne_6_2             (q_ne_even_r4[3]),
        .i_q_ne_1_2             (q_ne_odd_r4[0]), 
        .i_q_ne_3_2             (q_ne_odd_r4[1]), 
        .i_q_ne_5_2             (q_ne_odd_r4[2]), 
        .i_q_ne_7_2             (q_ne_odd_r4[3]),
        // Output
        // .o_average              (average_r4), 
        .o_ni                   (ni_r4), 
        .o_rd                   (rd_r4)
    );

    // Hold 1 clock 
    always_ff @(posedge i_clk) begin
        if (ni_rd4_ready) begin
            ni_r4_hold <= ni_r4; 
            rd_r4_hold <= rd_r4; 
        end 
    end

    ///////////////////////////////////////////////////
    ///////                 R=6                 /////// 
    ///////////////////////////////////////////////////
    ni_rd #(
        .WIDTH                  (SIZED), 
        .FIXED                  (FIXED)
    )ni_rd_r6(
        // R1
        .i_q_ne_0_1             (q_ne_even_r4[0]), 
        .i_q_ne_2_1             (q_ne_even_r4[1]), 
        .i_q_ne_4_1             (q_ne_even_r4[2]), 
        .i_q_ne_6_1             (q_ne_even_r4[3]),
        .i_q_ne_1_1             (q_ne_odd_r4[0]), 
        .i_q_ne_3_1             (q_ne_odd_r4[1]), 
        .i_q_ne_5_1             (q_ne_odd_r4[2]), 
        .i_q_ne_7_1             (q_ne_odd_r4[3]),
        // R2
        .i_q_ne_0_2             (q_ne_even_r6[0]), 
        .i_q_ne_2_2             (q_ne_even_r6[1]), 
        .i_q_ne_4_2             (q_ne_even_r6[2]), 
        .i_q_ne_6_2             (q_ne_even_r6[3]),
        .i_q_ne_1_2             (q_ne_odd_r6[0]), 
        .i_q_ne_3_2             (q_ne_odd_r6[1]), 
        .i_q_ne_5_2             (q_ne_odd_r6[2]), 
        .i_q_ne_7_2             (q_ne_odd_r6[3]),
        // Output
        // .o_average              (average_r6), 
        .o_ni                   (ni_r6), 
        .o_rd                   (rd_r6)
    );

    // Hold 1 clock 
    always_ff @(posedge i_clk) begin
        if (ni_rd6_ready) begin
            ni_r6_hold <= ni_r6; 
            rd_r6_hold <= rd_r6; 
        end 
    end
    ///////////////////////////////////////////////////
    ///////                 R=8                 /////// 
    ///////////////////////////////////////////////////
    ni_rd #(
        .WIDTH                  (SIZED), 
        .FIXED                  (FIXED)
    )ni_rd_r8(
        // R1
        .i_q_ne_0_1             (q_ne_even_r6[0]), 
        .i_q_ne_2_1             (q_ne_even_r6[1]), 
        .i_q_ne_4_1             (q_ne_even_r6[2]), 
        .i_q_ne_6_1             (q_ne_even_r6[3]),
        .i_q_ne_1_1             (q_ne_odd_r6[0]), 
        .i_q_ne_3_1             (q_ne_odd_r6[1]), 
        .i_q_ne_5_1             (q_ne_odd_r6[2]), 
        .i_q_ne_7_1             (q_ne_odd_r6[3]),
        // R2
        .i_q_ne_0_2             (q_ne_even_r8[0]), 
        .i_q_ne_2_2             (q_ne_even_r8[1]), 
        .i_q_ne_4_2             (q_ne_even_r8[2]), 
        .i_q_ne_6_2             (q_ne_even_r8[3]),
        .i_q_ne_1_2             (q_ne_odd_r8[0]), 
        .i_q_ne_3_2             (q_ne_odd_r8[1]), 
        .i_q_ne_5_2             (q_ne_odd_r8[2]), 
        .i_q_ne_7_2             (q_ne_odd_r8[3]),
        // Output
        // .o_average              (average_r8), 
        .o_ni                   (ni_r8), 
        .o_rd                   (rd_r8)
    );

    // Hold 1 clock 
    always_ff @(posedge i_clk) begin
        if (ni_rd8_ready) begin
            ni_r8_hold <= ni_r8; 
            rd_r8_hold <= rd_r8; 
        end 
    end

    ///////////////////////////////////////////////////////////////
    ///////                 NI RD HISTOGRAM                 /////// 
    ///////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////                 HOLD READY SIGNAL FOR SYNCHROUNOUS WITH OUTPUT NI_RD                 /////// 
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    always_ff @( posedge i_clk ) begin
        ni_rd_wren_r2 <= ready_r2_hold;
        ni_rd_wren_r4 <= ni_rd4_ready;
        ni_rd_wren_r6 <= ni_rd6_ready;
        ni_rd_wren_r8 <= ni_rd8_ready;
    end

    ///////////////////////////////////////////////////////////////
    ///////                 RAM FOR STORAGE                 /////// 
    ///////////////////////////////////////////////////////////////

    logic [7:0] addr_ni_r2, addr_ni_r4, addr_ni_r6, addr_ni_r8;
    logic [7:0] addr_rd_r2, addr_rd_r4, addr_rd_r6, addr_rd_r8;

    logic [8:0] r_addr_ni, r_addr_rd;

    //////////////////////////////////////////////////////////////////////////////
    ///////                 GEN READ ADDR FOR COMBINE TASK                 ///////
    //////////////////////////////////////////////////////////////////////////////
    
    assign addr_ni_r2 = (i_done_load_data_r8) ? r_addr_ni[7:0] : ni_r2_hold;
    assign addr_rd_r2 = (i_done_load_data_r8) ? r_addr_rd[7:0] : rd_r2_hold;
	 
    assign addr_ni_r4 = (i_done_load_data_r8) ? r_addr_ni[7:0] : ni_r4_hold;
    assign addr_rd_r4 = (i_done_load_data_r8) ? r_addr_rd[7:0] : rd_r4_hold;
	 
    assign addr_ni_r6 = (i_done_load_data_r8) ? r_addr_ni[7:0] : ni_r6_hold;
    assign addr_rd_r6 = (i_done_load_data_r8) ? r_addr_rd[7:0] : rd_r6_hold;
	 
    assign addr_ni_r8 = (i_done_load_data_r8) ? r_addr_ni[7:0] : ni_r8_hold;
    assign addr_rd_r8 = (i_done_load_data_r8) ? r_addr_rd[7:0] : rd_r8_hold;

    always_ff @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            r_addr_ni <= 9'd0;
            r_addr_rd <= 9'd0;
        end else begin
            if (i_done_load_data_r8 && !r_addr_ni[8] && !r_addr_rd[8]) begin
                r_addr_ni <= r_addr_ni + 9'b1;
                r_addr_rd <= r_addr_rd + 9'b1;
            end
        end
    end

    ni_rd_histogram #(
        .WIDTH                      (SIZED),
        .DEPTH                      (256)
    )ram_ni_rd_2(
        .i_clk                      (i_clk),           
        .i_update_enable            (ni_rd_wren_r2), 
        .i_ni_result                (addr_ni_r2), //ni_r2_hold),
        .i_rd_result                (addr_rd_r2), //rd_r2_hold),

        .o_ni_read                  (rdata_ni_r2), 
        .o_rd_read                  (rdata_rd_r2) 
    );  

    ni_rd_histogram #(
        .WIDTH                      (SIZED),
        .DEPTH                      (256)
    )ram_ni_rd_4(
        .i_clk                      (i_clk),           
        .i_update_enable            (ni_rd_wren_r4 & !i_done_load_data_r4), 
        .i_ni_result                (addr_ni_r4), //ni_r4_hold),
        .i_rd_result                (addr_rd_r4), //rd_r4_hold),

        .o_ni_read                  (rdata_ni_r4), 
        .o_rd_read                  (rdata_rd_r4) 
    );
    
    ni_rd_histogram #(
        .WIDTH                      (SIZED),
        .DEPTH                      (256)
    )ram_ni_rd_6(
        .i_clk                      (i_clk),           
        .i_update_enable            (ni_rd_wren_r6 & !i_done_load_data_r6), 
        .i_ni_result                (addr_ni_r6), //ni_r6_hold),
        .i_rd_result                (addr_rd_r6), //rd_r6_hold),

        .o_ni_read                  (rdata_ni_r6), 
        .o_rd_read                  (rdata_rd_r6) 
    );  

    ni_rd_histogram #(
        .WIDTH                      (SIZED),
        .DEPTH                      (256)
    )ram_ni_rd_8(
        .i_clk                      (i_clk),           
        .i_update_enable            (ni_rd_wren_r8 & !i_done_load_data_r8), 
        .i_ni_result                (addr_ni_r8), //ni_r8_hold),
        .i_rd_result                (addr_rd_r8), //rd_r8_hold),

        .o_ni_read                  (rdata_ni_r8), 
        .o_rd_read                  (rdata_rd_r8) 
    );  

    logic [FIXED-1:0] weight_ni_r2, weight_rd_r2;
    logic [FIXED-1:0] weight_ni_r4, weight_rd_r4;
    logic [FIXED-1:0] weight_ni_r6, weight_rd_r6;
    logic [FIXED-1:0] weight_ni_r8, weight_rd_r8;

    ///////////////////////////////////////////////////////////////////
    ///////                 LUT FOR DENSE LAYER                 ///////
    ///////////////////////////////////////////////////////////////////
    logic [7:0] r_addr_ni_hold, r_addr_rd_hold;

    always_ff @(posedge i_clk) begin
        r_addr_ni_hold <= r_addr_ni[7:0]; 
        r_addr_rd_hold <= r_addr_rd[7:0]; 
    end

    lut_ni_2 lut_2_n(
        .i_addr                 (r_addr_ni_hold),
        .o_dout                 (weight_ni_r2)
    ); 

    lut_rd_2 lut_2_r(
        .i_addr                 (r_addr_rd_hold),
        .o_dout                 (weight_rd_r2)
    );

    lut_ni_4 lut_4_n(
        .i_addr                 (r_addr_ni_hold),
        .o_dout                 (weight_ni_r4)
    );

    lut_rd_4 lut_4_r(
        .i_addr                 (r_addr_rd_hold),
        .o_dout                 (weight_rd_r4)
    );

    lut_ni_6 lut_6_n(
        .i_addr                 (r_addr_ni_hold),
        .o_dout                 (weight_ni_r6)
    );

    lut_rd_6 lut_6_r(
        .i_addr                 (r_addr_rd_hold),
        .o_dout                 (weight_rd_r6)
    );

    lut_ni_8 lut_8_n(
        .i_addr                 (r_addr_ni_hold),
        .o_dout                 (weight_ni_r8)
    );

    lut_rd_8 lut_8_r(
        .i_addr                 (r_addr_rd_hold),
        .o_dout                 (weight_rd_r8)
    );

    //////////////////////////////////////////////////////////////////////
    ///////                 DENSE LAYER CALCULATOR                 ///////
    //////////////////////////////////////////////////////////////////////

    logic hold_start; 
    logic done_dense_layer; 
    logic store_1_time = 0;

    logic [23:0] ci_0_total;
    logic [23:0] ci_1_total;

    logic [55:0] dense_ni_r2;
    logic [55:0] dense_ni_r4;
    logic [55:0] dense_ni_r6;
    logic [55:0] dense_ni_r8;

    logic [55:0] dense_rd_r2;
    logic [55:0] dense_rd_r4;
    logic [55:0] dense_rd_r6;   
    logic [55:0] dense_rd_r8;

    logic [59:0] dense_layer_with_bias;

    always_ff @(posedge i_clk) begin
        hold_start <= i_done_load_data_r8;
    end

    dense_layer dense_r2_ni(
        .i_clk                  (i_clk),
        .i_rst                  (i_rst),
        .i_start                (hold_start),
        .i_ni_rd                (rdata_ni_r2),
        .i_weight               (weight_ni_r2),

        .o_done                 (),
        .o_dout                 (dense_ni_r2)
    );

    dense_layer dense_r2_rd(
        .i_clk                  (i_clk),
        .i_rst                  (i_rst),
        .i_start                (hold_start),
        .i_ni_rd                (rdata_rd_r2),
        .i_weight               (weight_rd_r2),

        .o_done                 (),//o_done_layer),
        .o_dout                 (dense_rd_r2)
    ); 

    dense_layer dense_r4_ni(
        .i_clk                  (i_clk),
        .i_rst                  (i_rst),
        .i_start                (hold_start),
        .i_ni_rd                (rdata_ni_r4),
        .i_weight               (weight_ni_r4),

        .o_done                 (),//o_done_layer),
        .o_dout                 (dense_ni_r4)
    );

    dense_layer dense_r4_rd(
        .i_clk                  (i_clk),
        .i_rst                  (i_rst),
        .i_start                (hold_start),
        .i_ni_rd                (rdata_rd_r4),
        .i_weight               (weight_rd_r4),

        .o_done                 (),//o_done_layer),
        .o_dout                 (dense_rd_r4)
    );

    dense_layer dense_r6_ni(
        .i_clk                  (i_clk),
        .i_rst                  (i_rst),
        .i_start                (hold_start),
        .i_ni_rd                (rdata_ni_r6),
        .i_weight               (weight_ni_r6),

        .o_done                 (),//o_done_layer),
        .o_dout                 (dense_ni_r6)
    );

    dense_layer dense_r6_rd(
        .i_clk                  (i_clk),
        .i_rst                  (i_rst),
        .i_start                (hold_start),
        .i_ni_rd                (rdata_rd_r6),
        .i_weight               (weight_rd_r6),

        .o_done                 (),//o_done_layer),
        .o_dout                 (dense_rd_r6)
    );

    dense_layer dense_r8_ni(
        .i_clk                  (i_clk),
        .i_rst                  (i_rst),
        .i_start                (hold_start),
        .i_ni_rd                (rdata_ni_r8),
        .i_weight               (weight_ni_r8),

        .o_done                 (),//o_done_layer),
        .o_dout                 (dense_ni_r8)
    );

    dense_layer dense_r8_rd(
        .i_clk                  (i_clk),
        .i_rst                  (i_rst),
        .i_start                (hold_start),
        .i_ni_rd                (rdata_rd_r8),
        .i_weight               (weight_rd_r8),

        .o_done                 (done_dense_layer),
        .o_dout                 (dense_rd_r8)
    );

    always_ff @(posedge i_clk) begin
        if (i_done_load_data_r2 & !store_1_time) begin
            ci_0_total <= rdata_0_r2 + rdata_0_r4 + rdata_0_r6 + rdata_0_r8;
            ci_1_total <= rdata_1_r2 + rdata_1_r4 + rdata_1_r6 + rdata_1_r8;
            store_1_time <= 1;
        end
    end

    logic [55:0] dense_ci_0, dense_ci_1;
    logic signed [23:0] WEIGHT_CI_0 = 24'h000080, WEIGHT_CI_1 = 24'hFFFF7F;
    logic [23:0] BIAS = 24'h000000;

    assign dense_ci_0 = $signed({24'd0,ci_0_total}) * WEIGHT_CI_0;
    assign dense_ci_1 = $signed({24'd0,ci_1_total}) * WEIGHT_CI_1;

    logic done_dense_layer_hold; 

    always_ff @( posedge i_clk or posedge done_dense_layer ) begin
        if (done_dense_layer) begin
            dense_layer_with_bias <= {{4{dense_rd_r8[55]}},dense_rd_r8} + {{4{dense_ni_r8[55]}},dense_ni_r8} + 
                                     {{4{dense_rd_r6[55]}},dense_rd_r6} + {{4{dense_ni_r6[55]}},dense_ni_r6} + 
                                     {{4{dense_rd_r4[55]}},dense_rd_r4} + {{4{dense_ni_r4[55]}},dense_ni_r4} + 
                                     {{4{dense_rd_r2[55]}},dense_rd_r2} + {{4{dense_ni_r2[55]}},dense_ni_r2} +
                                     {{4{dense_ci_0[55]}},dense_ci_0}   + {{4{dense_ci_1[55]}},dense_ci_1}   + 
                                     {{36{BIAS[23]}},BIAS};
            done_dense_layer_hold <= done_dense_layer; 
        end
    end

    //////////////////////////////////////////////////////////////
    ///////                 CLASSIFICATION                 /////// 
    //////////////////////////////////////////////////////////////
    logic [4:0] classifi_o; 
    classifi classification(
        .i_clk      (i_clk),
        .i_rst      (i_rst),
        .i_enable   (done_dense_layer_hold),
        .i_din      (dense_layer_with_bias),
        .o_dout     (classifi_o)
    );
    
    assign o_classi = classifi_o;
    ////////////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST FOR CONTROL + BRAM INPUT                 /////// 
    ////////////////////////////////////////////////////////////////////////////////////
    /*Out of median 9x9*/
    // assign o_bram_of_median_9x9[0] = o_image_bram[8];  
    // assign o_bram_of_median_9x9[1] = o_image_bram[7];  
    // assign o_bram_of_median_9x9[2] = o_image_bram[6];  
    // assign o_bram_of_median_9x9[3] = o_image_bram[5];  
    // assign o_bram_of_median_9x9[4] = o_image_bram[4];  
    // assign o_bram_of_median_9x9[5] = o_image_bram[3];  
    // assign o_bram_of_median_9x9[6] = o_image_bram[2];  
    // assign o_bram_of_median_9x9[7] = o_image_bram[1];  
    // assign o_bram_of_median_9x9[8] = o_image_bram[0];  

    //////////////////////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST FOR MEDIAN RESULT + ENABLE OF BRAM                 /////// 
    //////////////////////////////////////////////////////////////////////////////////////////////
    // assign o_median_3x3 = median_3x3; 
    // assign o_median_5x5 = median_5x5; 
    // assign o_median_7x7 = median_7x7; 
    // assign o_median_9x9 = median_9x9; 

    // assign o_enable_3x3 = enable_3x3; 
    // assign o_enable_5x5 = enable_5x5;  
    // assign o_enable_7x7 = enable_7x7_hold; 
    // assign o_enable_9x9 = enable_9x9_hold_1; 

    /////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST FOR CI CALCULATOR                 /////// 
    /////////////////////////////////////////////////////////////////////////////
    // assign o_ci_2 = ci_2;
    // assign o_ci_4 = ci_4; 
    // assign o_ci_6 = ci_6; 
    // assign o_ci_8 = ci_8;

    ///////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF CI_2 HISTOGRAM               ///////
    ///////////////////////////////////////////////////////////////////////////
    assign o_rdata_r2_0 = rdata_0_r2; 
    assign o_rdata_r2_1 = rdata_1_r2; 
    // assign o_ready_r2   = ready_r2_hold; 
 
    assign o_rdata_r4_0 = rdata_0_r4;  
    assign o_rdata_r4_1 = rdata_1_r4; 
    assign o_rdata_r6_0 = rdata_0_r6;  
    assign o_rdata_r6_1 = rdata_1_r6;  
    assign o_rdata_r8_0 = rdata_0_r8;  
    assign o_rdata_r8_1 = rdata_1_r8;  

    // assign o_ready_r4_6_8 = ready_r4_hold; 

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST FOR VALUE HOLD BRAM MEDIAN RESULT 3X3 + TEST CURRENT ADDRESS FOR HOLD                 /////// 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Test addr
    // assign o_addr_3x3 = addr_next_3x3_bram; 
    // assign o_addr_5x5 = addr_next_5x5_bram; 
    // assign o_addr_7x7 = addr_next_7x7_bram; 
    // assign o_addr_9x9 = addr_next_9x9_bram; 

    // Test for hold value for bram 3x3
    // generate
        // for (i=0; i<49; i=i+1) begin: assign_to_test_output_2
            // assign o_hold_value_for_ci[i] = output_49_value_hold[i]; 
        // end
    // endgenerate

    // Test for hold value for bram 5x5
    // generate 
        // for (i=0; i<21; i=i+1) begin : assign_to_test_output_4
            // assign o_hold_value[i] = output_21_value_hold_r4[i]; 
        // end
    // endgenerate

    // Test for hold value for bram 7x7
    // generate 
        // for (i=0; i<21; i=i+1) begin : assign_to_test_output_6
            // assign o_hold_value[i] = output_21_value_hold_r6[i]; 
        // end
    // endgenerate

    // Test for hold value for bram 9x9
    // generate 
        // for (i=0; i<21; i=i+1) begin : assign_to_test_output_8
            // assign o_hold_value[i] = output_21_value_hold_r8[i]; 
        // end
    // endgenerate
    /////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST FOR INTERPOLATION                 /////// 
    /////////////////////////////////////////////////////////////////////////////
    // r = 2
    // assign o_pixel_center = pixel_center; 
    // assign o_q_ne_even[0] = q_ne_even_r2[0]; 
    // assign o_q_ne_even[1] = q_ne_even_r2[1];
    // assign o_q_ne_even[2] = q_ne_even_r2[2];
    // assign o_q_ne_even[3] = q_ne_even_r2[3];
    // assign o_q_ne_odd [0] = q_ne_odd_r2 [0]; 
    // assign o_q_ne_odd [1] = q_ne_odd_r2 [1]; 
    // assign o_q_ne_odd [2] = q_ne_odd_r2 [2]; 
    // assign o_q_ne_odd [3] = q_ne_odd_r2 [3]; 

    // r=4
    // assign o_q_ne_even[0] = q_ne_even_r4[0];
    // assign o_q_ne_even[1] = q_ne_even_r4[1];
    // assign o_q_ne_even[2] = q_ne_even_r4[2];
    // assign o_q_ne_even[3] = q_ne_even_r4[3];
    // assign o_q_ne_odd [0] = q_ne_odd_r4 [0];
    // assign o_q_ne_odd [1] = q_ne_odd_r4 [1];
    // assign o_q_ne_odd [2] = q_ne_odd_r4 [2];
    // assign o_q_ne_odd [3] = q_ne_odd_r4 [3];

    // r=6
    // assign o_q_ne_even[0] = q_ne_even_r6[0];
    // assign o_q_ne_even[1] = q_ne_even_r6[1];
    // assign o_q_ne_even[2] = q_ne_even_r6[2];
    // assign o_q_ne_even[3] = q_ne_even_r6[3];
    // assign o_q_ne_odd [0] = q_ne_odd_r6 [0];
    // assign o_q_ne_odd [1] = q_ne_odd_r6 [1];
    // assign o_q_ne_odd [2] = q_ne_odd_r6 [2];
    // assign o_q_ne_odd [3] = q_ne_odd_r6 [3];

    // r=8
    // assign o_q_ne_even[0] = q_ne_even_r8[0];
    // assign o_q_ne_even[1] = q_ne_even_r8[1];
    // assign o_q_ne_even[2] = q_ne_even_r8[2];
    // assign o_q_ne_even[3] = q_ne_even_r8[3];
    // assign o_q_ne_odd [0] = q_ne_odd_r8 [0];
    // assign o_q_ne_odd [1] = q_ne_odd_r8 [1];
    // assign o_q_ne_odd [2] = q_ne_odd_r8 [2];
    // assign o_q_ne_odd [3] = q_ne_odd_r8 [3];  

    ///////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF NI + RD CALCULATOR               ///////
    ///////////////////////////////////////////////////////////////////////////////
    // R2
    // assign o_average_r2 = average_r2; 
    // assign o_ni_r2 = ni_r2_hold; 
    // assign o_rd_r2 = rd_r2_hold;     

    // // R4 
    // // assign o_average_r4 = average_r4; 
    // assign o_ni_r4         = ni_r4_hold; 
    // assign o_rd_r4         = rd_r4_hold;     
    // assign o_ready_ni_rd_4 = ni_rd4_ready; 

    // // R6
    // // assign o_average_r6 = average_r6; 
    // assign o_ni_r6         = ni_r6_hold; 
    // assign o_rd_r6         = rd_r6_hold;       
    // assign o_ready_ni_rd_6 = ni_rd6_ready; 

    // // R6
    // // assign o_average_r8 = average_r8; 
    // assign o_ni_r8 = ni_r8_hold; 
    // assign o_rd_r8 = rd_r8_hold;       
    // assign o_ready_ni_rd_8 = ni_rd8_ready; 

    //////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF NI + RD HISTOGRAM               ///////
    //////////////////////////////////////////////////////////////////////////////
    // R2
    assign o_rdata_ni_r2 = rdata_ni_r2; 
    assign o_rdata_rd_r2 = rdata_rd_r2; 
    // R4
    assign o_rdata_ni_r4 = rdata_ni_r4; 
    assign o_rdata_rd_r4 = rdata_rd_r4;
    // R6
    assign o_rdata_ni_r6 = rdata_ni_r6; 
    assign o_rdata_rd_r6 = rdata_rd_r6;
    // R8
    assign o_rdata_ni_r8 = rdata_ni_r8; 
    assign o_rdata_rd_r8 = rdata_rd_r8; 

    ////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT FOR COMBINE VECTOR               ////////
    ////////////////////////////////////////////////////////////////////////

    assign o_ci0 = ci_0_total;
    assign o_ci1 = ci_1_total;

    assign o_ni_addr = r_addr_ni;
    assign o_rd_addr = r_addr_rd;

    /////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT FOR LUT WEIGHT                 ///////
    /////////////////////////////////////////////////////////////////////
    // assign o_lut_ni_2 = weight_ni_r2;
    // assign o_lut_rd_2 = weight_rd_r2;
    // assign o_lut_ni_4 = weight_ni_r4;
    // assign o_lut_rd_4 = weight_rd_r4;
    // assign o_lut_ni_6 = weight_ni_r6;
    // assign o_lut_rd_6 = weight_rd_r6;
    // assign o_lut_ni_8 = weight_ni_r8;
    // assign o_lut_rd_8 = weight_rd_r8;

    ////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT FOR DENSE LAYER                 /////////
    ////////////////////////////////////////////////////////////////////////
    // assign o_dense_ni_r2 = dense_ni_r2;
    // assign o_dense_ni_r4 = dense_ni_r4;
    // assign o_dense_ni_r6 = dense_ni_r6;
    // assign o_dense_ni_r8 = dense_ni_r8;

    // assign o_dense_rd_r2 = dense_rd_r2;
    // assign o_dense_rd_r4 = dense_rd_r4;
    // assign o_dense_rd_r6 = dense_rd_r6;
    // assign o_dense_rd_r8 = dense_rd_r8;
    assign o_dense_layer = dense_layer_with_bias;

    assign o_done_layer = done_dense_layer; 
endmodule