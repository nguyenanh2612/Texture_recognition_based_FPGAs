module tb;
    ////////////////////////////////////////////////////////////////////
    ///////                 PARAMETER + VARIABLE                 /////// 
    ////////////////////////////////////////////////////////////////////
    /*Parameter*/
    parameter WIDTH = 9;                        // Width of bram 
    parameter DEPTH = 9;                        // Depth of bram   
    parameter SIZED = 8;                        // Size of each cellparameter WIDTH = 9  
    parameter FIXED = 24;                       // Size of fixed point in interpolation
    /*Variable*/
    // Count varibale
    // int i;

    // Input
    logic tb_clk; 
    logic tb_rst; 
    logic [SIZED-1:0] tb_din; 
    bit tb_done_load_data_r2;
    bit tb_done_load_data_r4;
    bit tb_done_load_data_r6;
    bit tb_done_load_data_r8;

    // Output
    logic [23:0] tb_ci_0;    
    logic [23:0] tb_ci_1;    
    logic [SIZED:0] tb_ni_addr; 
    logic [SIZED:0] tb_rd_addr; 
    logic [4:0] tb_classi;

    // Output test 

    ////////////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST FOR CONTROL + BRAM INPUT                 /////// 
    ////////////////////////////////////////////////////////////////////////////////////
    // logic tb_enable_3x3; 
    // logic tb_enable_5x5; 
    // logic tb_enable_7x7;
    // logic tb_enable_9x9;

    // logic [2:0] tb_state_3x3;
    // logic [2:0] tb_state_5x5;
    // logic [2:0] tb_state_7x7;
    // logic       tb_state_9x9;

    // logic [SIZED*9-1:0] tb_bram_of_median_9x9 [8:0]; 

    ////////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST FOR MEDIAN PROCESSING                /////// 
    ////////////////////////////////////////////////////////////////////////////////
    // logic [SIZED-1:0] tb_median_3x3; 
    // logic [SIZED-1:0] tb_median_5x5; 
    // logic [SIZED-1:0] tb_median_7x7;
    // logic [SIZED-1:0] tb_median_9x9;

    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF MEDIAN PROCESSING RESULT STORE               ///////
    ///////////////////////////////////////////////////////////////////////////////////////////
    // logic [5:0]       tb_addr_3x3;
    // logic [6:0]       tb_addr_5x5;
    // logic [8:0]       tb_addr_7x7; 
    // logic [8:0]       tb_addr_9x9; 

    // logic [SIZED-1:0] tb_bram_3x3;
    // logic [SIZED-1:0] tb_bram_5x5; 
    // logic [SIZED-1:0] tb_bram_7x7;
    // logic [SIZED-1:0] tb_bram_9x9; 

    /////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF PRE CI_CALULATOR               ///////
    /////////////////////////////////////////////////////////////////////////////
    // logic [SIZED-1:0]  tb_hold_value_for_ci_calculator [48:0]; 
    // logic [SIZED-1:0] tb_hold_value [20:0]; 

    ////////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF RESULT CI_CALULATOR               ///////
    ////////////////////////////////////////////////////////////////////////////////
    // logic [15:0]       tb_average_ci; 
    // logic [24:0]       tb_ci_2; 
    // logic [48:0]       tb_ci_4;
    // logic [48:0]       tb_ci_6;
    // logic [48:0]       tb_ci_8;

    ////////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF RESULT CI_HISTOGRAM               ///////
    ////////////////////////////////////////////////////////////////////////////////
    logic [23:0]       tb_rdata_r2_0; 
    logic [23:0]       tb_rdata_r2_1; 
    // logic              tb_ready_r2; 

    logic [23:0]       tb_rdata_r4_0;  
    logic [23:0]       tb_rdata_r4_1;  
    logic [23:0]       tb_rdata_r6_0;  
    logic [23:0]       tb_rdata_r6_1;  
    logic [23:0]       tb_rdata_r8_0;  
    logic [23:0]       tb_rdata_r8_1;  
    // logic              tb_ready_r4_6_8;

    /////////////////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF INTERPOLATION R=2 CALCULATOR               ///////
    /////////////////////////////////////////////////////////////////////////////////////////
    // logic [SIZED-1:0] tb_pixel_center; 
    // logic [SIZED-1:0] tb_q_ne_even [3:0]; 
    // logic [FIXED-1:0] tb_q_ne_odd  [3:0]; 

    ///////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF NI + RD CALCULATOR               ///////
    ///////////////////////////////////////////////////////////////////////////////
    // logic [FIXED-1:0] tb_average_r2; 
    // logic [SIZED-1:0] tb_ni_r2;
    // logic [SIZED-1:0] tb_rd_r2;

    // // logic [FIXED-1:0] tb_average_r4; 
    // logic [SIZED-1:0] tb_ni_r4;
    // logic [SIZED-1:0] tb_rd_r4;
    // logic             tb_ready_ni_rd_r4;

    // // logic [FIXED-1:0] tb_average_r6; 
    // logic [SIZED-1:0] tb_ni_r6;
    // logic [SIZED-1:0] tb_rd_r6;
    // logic             tb_ready_ni_rd_r6; 
    // // logic [FIXED-1:0] tb_average_r8; 
    // logic [SIZED-1:0] tb_ni_r8;
    // logic [SIZED-1:0] tb_rd_r8;
    // logic             tb_ready_ni_rd_r8;

    /////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST FOR NI RD HISTOGRAM               ///////
    /////////////////////////////////////////////////////////////////////////////
    logic [FIXED-1:0] tb_rdata_ni_r2, tb_rdata_rd_r2;
    logic [FIXED-1:0] tb_rdata_ni_r4, tb_rdata_rd_r4;
    logic [FIXED-1:0] tb_rdata_ni_r6, tb_rdata_rd_r6;
    logic [FIXED-1:0] tb_rdata_ni_r8, tb_rdata_rd_r8;

    //////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST FOR LUT               ////////
    //////////////////////////////////////////////////////////////////
    // logic [FIXED-1:0] tb_lut_rd_2;
    // logic [FIXED-1:0] tb_lut_rd_4;
    // logic [FIXED-1:0] tb_lut_rd_6;
    // logic [FIXED-1:0] tb_lut_rd_8;

    // logic [FIXED-1:0] tb_lut_ni_2;
    // logic [FIXED-1:0] tb_lut_ni_4;
    // logic [FIXED-1:0] tb_lut_ni_6;
    // logic [FIXED-1:0] tb_lut_ni_8;


    //////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST FOR DENSE LAYER               ////////
    //////////////////////////////////////////////////////////////////////////
    logic tb_done_layer; 

    // logic [55:0]     tb_dense_ni_r2;
    // logic [55:0]     tb_dense_ni_r4;
    // logic [55:0]     tb_dense_ni_r6;
    // logic [55:0]     tb_dense_ni_r8;

    // logic [55:0]     tb_dense_rd_r2;
    // logic [55:0]     tb_dense_rd_r4;
    // logic [55:0]     tb_dense_rd_r6;
    // logic [55:0]     tb_dense_rd_r8;

    logic [59:0] tb_dense_layer; 

    //////////////////////////////////////////////////////////////////
    ///////                 INSTANTIATE MODULE                 /////// 
    //////////////////////////////////////////////////////////////////
    MRELBP #(
        .WIDTH  (WIDTH),
        .DEPTH  (DEPTH),
        .SIZED  (SIZED), 
        .FIXED  (FIXED)
    )dut(
        // Input
        .i_clk                      (tb_clk), 
        .i_rst                      (tb_rst), 
        .i_din                      (tb_din), 
        .i_done_load_data_r8        (tb_done_load_data_r8),
        .i_done_load_data_r6        (tb_done_load_data_r6),
        .i_done_load_data_r4        (tb_done_load_data_r4),
        .i_done_load_data_r2        (tb_done_load_data_r2),

    //////////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF MEDIAN PRE-PROCESSING               ///////
    //////////////////////////////////////////////////////////////////////////////////
        // .o_enable_3x3                     (tb_enable_3x3),
        // .o_enable_5x5                     (tb_enable_5x5),
        // .o_enable_7x7                     (tb_enable_7x7),
        // .o_enable_9x9                     (tb_enable_9x9),

        // .o_state_3x3                      (tb_state_3x3),
        // .o_state_5x5                      (tb_state_5x5),
        // .o_state_7x7                      (tb_state_7x7),
        // .o_state_9x9                      (tb_state_9x9),

        // .o_bram_of_median_9x9             (tb_bram_of_median_9x9)

    ///////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF MEDIAN PROCESSING                ///////
    ///////////////////////////////////////////////////////////////////////////////
        // .o_median_3x3                      (tb_median_3x3),
        // .o_median_5x5                      (tb_median_5x5), 
        // .o_median_7x7                      (tb_median_7x7), 
        // .o_median_9x9                      (tb_median_9x9), 
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF MEDIAN PROCESSING RESULT STORE               ///////
    ///////////////////////////////////////////////////////////////////////////////////////////
        // .o_addr_3x3                         (tb_addr_3x3),
        // .o_addr_5x5                         (tb_addr_5x5),  
        // .o_addr_7x7                         (tb_addr_7x7), 
        // .o_addr_9x9                         (tb_addr_9x9),     

        // .o_bram_3x3                         (tb_bram_3x3),
        // .o_bram_5x5                         (tb_bram_5x5), 
        // .o_bram_7x7                         (tb_bram_7x7), 
        // .o_bram_9x9                         (tb_bram_9x9),

    /////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF PRE CI_CALULATOR               ///////
    /////////////////////////////////////////////////////////////////////////////
        // .o_hold_value_for_ci                    (tb_hold_value_for_ci_calculator),
        // .o_hold_value                           (tb_hold_value),
    /////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF PRE CI_CALULATOR               ///////
    /////////////////////////////////////////////////////////////////////////////
        // .o_average_test                         (tb_average_ci), 
        // .o_ci_2                                 (tb_ci_2), 
        // .o_ci_4                                 (tb_ci_4), 
        // .o_ci_6                                 (tb_ci_6),
        // .o_ci_8                                 (tb_ci_8), 

    /////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF CI HISTOGRAM               ///////
    /////////////////////////////////////////////////////////////////////////
        .o_rdata_r2_0                           (tb_rdata_r2_0), 
        .o_rdata_r2_1                           (tb_rdata_r2_1),
        // .o_ready_r2                             (tb_ready_r2),
        .o_rdata_r4_0                           (tb_rdata_r4_0),   
        .o_rdata_r4_1                           (tb_rdata_r4_1),   
        .o_rdata_r6_0                           (tb_rdata_r6_0),   
        .o_rdata_r6_1                           (tb_rdata_r6_1),   
        .o_rdata_r8_0                           (tb_rdata_r8_0),   
        .o_rdata_r8_1                           (tb_rdata_r8_1),   
        // .o_ready_r4_6_8                         (tb_ready_r4_6_8),
    /////////////////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF INTERPOLATION R=2 CALCULATOR               ///////
    /////////////////////////////////////////////////////////////////////////////////////////
        // .o_pixel_center                          (tb_pixel_center),
        // .o_q_ne_even                             (tb_q_ne_even), 
        // .o_q_ne_odd                              (tb_q_ne_odd),  

    ///////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST OF NI + RD CALCULATOR               ///////
    ///////////////////////////////////////////////////////////////////////////////
        // .o_average_r2                            (tb_average_r2), 
        // .o_average_r4                            (tb_average_r4), 
        // .o_average_r6                            (tb_average_r6), 
        // .o_average_r8                            (tb_average_r8), 

        // .o_ni_r2                                 (tb_ni_r2), 
        // .o_rd_r2                                 (tb_rd_r2),
        // .o_ni_r4                                 (tb_ni_r4), 
        // .o_rd_r4                                 (tb_rd_r4), 
        // .o_ready_ni_rd_4                         (tb_ready_ni_rd_r4),
        // .o_ni_r6                                 (tb_ni_r6), 
        // .o_rd_r6                                 (tb_rd_r6),
        // .o_ready_ni_rd_6                         (tb_ready_ni_rd_r6),
        // .o_ni_r8                                 (tb_ni_r8), 
        // .o_rd_r8                                 (tb_rd_r8),
        // .o_ready_ni_rd_8                         (tb_ready_ni_rd_r8), 

    /////////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST FOR NI RD HISTOGRAM               ///////
    /////////////////////////////////////////////////////////////////////////////
        .o_rdata_ni_r2                           (tb_rdata_ni_r2),
        .o_rdata_rd_r2                           (tb_rdata_rd_r2),
        .o_rdata_ni_r4                           (tb_rdata_ni_r4),
        .o_rdata_rd_r4                           (tb_rdata_rd_r4),
        .o_rdata_ni_r6                           (tb_rdata_ni_r6),
        .o_rdata_rd_r6                           (tb_rdata_rd_r6),
        .o_rdata_ni_r8                           (tb_rdata_ni_r8),
        .o_rdata_rd_r8                           (tb_rdata_rd_r8), 

    ////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT FOR COMBINE VECTOR               ////////
    ////////////////////////////////////////////////////////////////////////
        .o_ci0                                  (tb_ci_0),
        .o_ci1                                  (tb_ci_1), 
        .o_ni_addr                              (tb_ni_addr),
        .o_rd_addr                              (tb_rd_addr),
    
    //////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST FOR LUT               ////////
    //////////////////////////////////////////////////////////////////
        // .o_lut_rd_2                             (tb_lut_rd_2),
        // .o_lut_rd_4                             (tb_lut_rd_4),
        // .o_lut_rd_6                             (tb_lut_rd_6),
        // .o_lut_rd_8                             (tb_lut_rd_8),

        // .o_lut_ni_2                             (tb_lut_ni_2),
        // .o_lut_ni_4                             (tb_lut_ni_4),
        // .o_lut_ni_6                             (tb_lut_ni_6),
        // .o_lut_ni_8                             (tb_lut_ni_8), 

    //////////////////////////////////////////////////////////////////////////
    ///////                 OUTPUT TEST FOR DENSE LAYER               ////////
    //////////////////////////////////////////////////////////////////////////   
        .o_done_layer                           (tb_done_layer), 

        // .o_dense_ni_r2                          (tb_dense_ni_r2), 
        // .o_dense_ni_r4                          (tb_dense_ni_r4)
        // .o_dense_ni_r6                          (tb_dense_ni_r6)
        // .o_dense_ni_r8                          (tb_dense_ni_r8)

        // .o_dense_rd_r2                          (tb_dense_rd_r2),
        // .o_dense_rd_r4                          (tb_dense_rd_r4)
        // .o_dense_rd_r6                          (tb_dense_rd_r6),
        // .o_dense_rd_r8                          (tb_dense_rd_r8)

        .o_dense_layer                          (tb_dense_layer), 
        .o_classi                               (tb_classi)
);

    ////////////////////////////////////////////////////////////////
    ///////                 DUMP FILE + VARS                 /////// 
    ////////////////////////////////////////////////////////////////
    initial begin
        $dumpfile("MRELBP.vcd"); 
        $dumpvars(0,tb); 
    end

    //////////////////////////////////////////////////////////////
    ///////                 GENERATE CLOCK                 /////// 
    //////////////////////////////////////////////////////////////
    initial begin
        tb_clk = 1'b1; 
        forever #5 tb_clk = ~tb_clk;
    end

    //////////////////////////////////////////////////////////////
    ///////                 GENERATE CLOCK                 /////// 
    //////////////////////////////////////////////////////////////
    logic [SIZED-1:0] tb_mem [12212803:0];
    initial begin
        $readmemh("D:/Capstone/Texture regconition based FPGAs/code/test_step/MRELP/02_sim/pixel_input.dump", tb_mem);
    end

    longint unsigned i = 0;

    /////////////////////////////////////////////////////////
    ///////                 TEST CASE                 /////// 
    /////////////////////////////////////////////////////////
    initial begin
        $display("///////////////////////////////////////////////////");
        $display("///                 APLLY RESET                 ///");
        $display("///////////////////////////////////////////////////");
        tb_rst = 1'b1; 
        tb_din = 0; // Apply reset 
        #10;
        $display("//////////////////////////////////////////////////////////////////////");
        $display("///                 START TEST WITH 90 INPUT PIXELS                ///");
        $display("//////////////////////////////////////////////////////////////////////");
        tb_rst = 1'b0;
        // Add stimulus 
        repeat (1221805) begin 
        // repeat (29160) begin 
        // repeat (360) begin
        // repeat (3240) begin
            tb_din = tb_mem[i]; 
            i=i+1;
            // $display("i: %0d", i);
            // if (i == 1221805) begin 
                // tb_done_load_data = 1'b1;
            // end
            #10; 
        end
        $display("Final i: %0d", i);
        // if (i == 1221805) begin 
        //     tb_done_load_data = 1'b1;
        // end
        #250; 
        tb_done_load_data_r2 = 1'b1;
        #770; 
        tb_done_load_data_r4 = 1'b1;
        tb_done_load_data_r6 = 1'b1;
      #205930; 
        tb_done_load_data_r8 = 1'b1;
        #1000000; 
        $stop; 
    end

    //////////////////////////////////////////////////////////////
    ///////                 CAPTURE RESULT                 /////// 
    //////////////////////////////////////////////////////////////
    // always_ff @( posedge tb_clk ) begin
    //     tb_enable_7x7_syn_with_data <= tb_enable_7x7;
    //     tb_enable_9x9_syn_with_data_1 <= tb_enable_9x9;  
    // end

    // always_ff @( posedge tb_clk ) begin
    //     tb_enable_9x9_syn_with_data_2 <= tb_enable_9x9_syn_with_data_1; 
    // end

    // always_ff @( posedge tb_clk ) begin
    //     $display("////////////////////////////////////////////////////////");
    //     $display("///                 TIME: %0t + DIN:%h               ///", $time, tb_din);
    //     $display("////////////////////////////////////////////////////////");
        // $display("%h", tb_bram_of_median_9x9[8]);
        // $display("%h", tb_bram_of_median_9x9[7]);
        // $display("%h", tb_bram_of_median_9x9[6]);
        // $display("%h", tb_bram_of_median_9x9[5]);
        // $display("%h", tb_bram_of_median_9x9[4]);
        // $display("%h", tb_bram_of_median_9x9[3]);
        // $display("%h", tb_bram_of_median_9x9[2]);
        // $display("%h", tb_bram_of_median_9x9[1]);
        // $display("%h", tb_bram_of_median_9x9[0]);
        
        // $display("Enable 3x3:%b -- 5x5:%b -- 7x7%b -- 9x9:%b", tb_enable_3x3, tb_enable_5x5, tb_enable_7x7, tb_enable_9x9);
        
        // $display("Median result(3x3): %h -- Enable: %b", tb_median_3x3, tb_enable_3x3);
        // $display("Median result(5x5): %h -- Enable: %b", tb_median_5x5, tb_enable_5x5);
        // $display("Median result(7x7): %h -- Enable: %b", tb_median_7x7, tb_enable_7x7);
        // $display("Median result(9x9): %h -- Enable: %b", tb_median_9x9, tb_enable_9x9);
        
        // $display("Median result(3x3): %h", tb_median_3x3);
        // $display("Median result(5x5): %h", tb_median_5x5);
        // $display("Median result(7x7): %h", tb_median_7x7);
        // $display("Median result(9x9): %h", tb_median_9x9);
        
        // $display("Median store result: %h", tb_bram_3x3);
        
        // $display("Element[0]: %h -- Element[1]: %h -- Element[2]: %h -- Element[3]: %h -- Element[4]: %h -- Element[5]: %h -- Element[6]: %h", tb_hold_value_for_ci_calculator[0],tb_hold_value_for_ci_calculator[1],tb_hold_value_for_ci_calculator[2],tb_hold_value_for_ci_calculator[3],tb_hold_value_for_ci_calculator[4],tb_hold_value_for_ci_calculator[5],tb_hold_value_for_ci_calculator[6]);
        // $display("Element[7]: %h -- Element[8]: %h -- Element[9]: %h -- Element[10]: %h -- Element[11]: %h -- Element[12]: %h -- Element[13]: %h", tb_hold_value_for_ci_calculator[7],tb_hold_value_for_ci_calculator[8],tb_hold_value_for_ci_calculator[9],tb_hold_value_for_ci_calculator[10],tb_hold_value_for_ci_calculator[11],tb_hold_value_for_ci_calculator[12],tb_hold_value_for_ci_calculator[13]);
        // $display("Element[14]: %h -- Element[15]: %h -- Element[16]: %h -- Element[17]: %h -- Element[18]: %h -- Element[19]: %h -- Element[20]: %h", tb_hold_value_for_ci_calculator[14],tb_hold_value_for_ci_calculator[15],tb_hold_value_for_ci_calculator[16],tb_hold_value_for_ci_calculator[17],tb_hold_value_for_ci_calculator[18],tb_hold_value_for_ci_calculator[19],tb_hold_value_for_ci_calculator[20]);
        // $display("Element[21]: %h -- Element[22]: %h -- Element[23]: %h -- Element[24]: %h -- Element[25]: %h -- Element[26]: %h -- Element[27]: %h", tb_hold_value_for_ci_calculator[21],tb_hold_value_for_ci_calculator[22],tb_hold_value_for_ci_calculator[23],tb_hold_value_for_ci_calculator[24],tb_hold_value_for_ci_calculator[25],tb_hold_value_for_ci_calculator[26],tb_hold_value_for_ci_calculator[27]);
        // $display("Element[28]: %h -- Element[29]: %h -- Element[30]: %h -- Element[31]: %h -- Element[32]: %h -- Element[33]: %h -- Element[34]: %h", tb_hold_value_for_ci_calculator[28],tb_hold_value_for_ci_calculator[29],tb_hold_value_for_ci_calculator[30],tb_hold_value_for_ci_calculator[31],tb_hold_value_for_ci_calculator[32],tb_hold_value_for_ci_calculator[33],tb_hold_value_for_ci_calculator[34]);
        // $display("Element[35]: %h -- Element[36]: %h -- Element[37]: %h -- Element[38]: %h -- Element[39]: %h -- Element[40]: %h -- Element[41]: %h", tb_hold_value_for_ci_calculator[35],tb_hold_value_for_ci_calculator[36],tb_hold_value_for_ci_calculator[37],tb_hold_value_for_ci_calculator[38],tb_hold_value_for_ci_calculator[39],tb_hold_value_for_ci_calculator[40],tb_hold_value_for_ci_calculator[41]);
        // $display("Element[42]: %h -- Element[43]: %h -- Element[44]: %h -- Element[45]: %h -- Element[46]: %h -- Element[47]: %h -- Element[48]: %h", tb_hold_value_for_ci_calculator[42],tb_hold_value_for_ci_calculator[43],tb_hold_value_for_ci_calculator[44],tb_hold_value_for_ci_calculator[45],tb_hold_value_for_ci_calculator[46],tb_hold_value_for_ci_calculator[47],tb_hold_value_for_ci_calculator[48]);
        
        // $display("Element[0]: %h -- Element[1]: %h -- Element[2]: %h -- Element[3]: %h -- Element[4]: %h -- Element[5]: %h -- Element[6]: %h", tb_hold_value[0],tb_hold_value[1],tb_hold_value[2],tb_hold_value[3],tb_hold_value[4],tb_hold_value[5],tb_hold_value[6]);
        // $display("Element[7]: %h -- Element[8]: %h -- Element[9]: %h -- Element[10]: %h -- Element[11]: %h -- Element[12]: %h -- Element[13]: %h", tb_hold_value[7],tb_hold_value[8],tb_hold_value[9],tb_hold_value[10],tb_hold_value[11],tb_hold_value[12],tb_hold_value[13]);
        // $display("Element[14]: %h -- Element[15]: %h -- Element[16]: %h -- Element[17]: %h -- Element[18]: %h -- Element[19]: %h -- Element[20]: %h", tb_hold_value[14],tb_hold_value[15],tb_hold_value[16],tb_hold_value[17],tb_hold_value[18],tb_hold_value[19],tb_hold_value[20]);

        // $display("Result of CI at radius 2: %b", tb_ci_2);
        // $display("Result of CI at radius 4: %b", tb_ci_4);
        // $display("Result of CI at radius 6: %b", tb_ci_6);
        // $display("Result of CI at radius 8: %b", tb_ci_8);
        
        // $display("Central element: %h -- Average_value: %h", tb_pixel_center, tb_average);
        // $display("Average_value r2: %h -- Average_value r4: %h -- Average_value r6: %h -- Average_value r8: %h", tb_average_r2, tb_average_r4, tb_average_r6, tb_average_r8);
        // $display("q_ne[0]: %h -- q_ne[2]: %h -- q_ne[4]: %h -- q_ne[6]: %h", tb_q_ne_even[0],tb_q_ne_even[1],tb_q_ne_even[2],tb_q_ne_even[3]);
        // $display("q_ne[1]: %h -- q_ne[3]: %h -- q_ne[5]: %h -- q_ne[7]: %h", tb_q_ne_odd[0],tb_q_ne_odd[1],tb_q_ne_odd[2],tb_q_ne_odd[3]);
        // $display("Output read data of bram 5x5: %h  with addr: %0d", tb_bram_5x5, tb_addr_5x5);

        // $display("NI_r2:%b ------ RD_r2:%b", tb_ni_r2, tb_rd_r2);
        // $display("NI_r4:%b ------ RD_r4:%b", tb_ni_r4, tb_rd_r4);
        // $display("NI_r6:%b ------ RD_r6:%b", tb_ni_r6, tb_rd_r6);
        // $display("NI_r8:%b ------ RD_r8:%b", tb_ni_r8, tb_rd_r8);
    // end

endmodule 