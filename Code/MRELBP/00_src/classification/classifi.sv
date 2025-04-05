module classifi(
    input logic i_clk,
    input logic i_rst,
    input logic i_enable,
    input logic [59:0] i_din,
    output logic [4:0] o_dout
);
    // Parameters and registers
    logic [59:0] average [4:0];
    logic [59:0] min;
    logic [59:0] cal_temp;
    logic [4:0] in_region;
    logic [2:0] min_locate;
    
    // Blanket
    logic [59:0]MIN_LABEL_1 = 60'hffffffffed5c28f;
    logic [59:0]MAX_LABEL_1 = 60'h00000000248f5c3;
    // Canvas
    logic [59:0]MIN_LABEL_2 = 60'hffffffffef3d70a;
    logic [59:0]MAX_LABEL_2 = 60'h0000000019147ae;
    // Ceiling 
    logic [59:0]MIN_LABEL_3 = 60'hffffffffe370a3d;
    logic [59:0]MAX_LABEL_3 = 60'h000000000e8f5c3;
    // Cushion
    logic [59:0]MIN_LABEL_4 = 60'hffffffffa866666;
    logic [59:0]MAX_LABEL_4 = 60'h000000000ad70a4;
    // Floor
    logic [59:0]MIN_LABEL_5 = 60'hffffffffa4c28f6;
    logic [59:0]MAX_LABEL_5 = 60'h000000000751eb8;

    // Pre-compute averages
    assign average[0] = (MAX_LABEL_1 + MIN_LABEL_1) / 2;
    assign average[1] = (MAX_LABEL_2 + MIN_LABEL_2) / 2;
    assign average[2] = (MAX_LABEL_3 + MIN_LABEL_3) / 2;
    assign average[3] = (MAX_LABEL_4 + MIN_LABEL_4) / 2;
    assign average[4] = (MAX_LABEL_5 + MIN_LABEL_5) / 2;

    always_comb begin
        in_region[0] = (signed'(i_din) >= signed'(MIN_LABEL_1) && signed'(i_din) <= signed'(MAX_LABEL_1)) ? 1'b1 : 1'b0;
        in_region[1] = (signed'(i_din) >= signed'(MIN_LABEL_2) && signed'(i_din) <= signed'(MAX_LABEL_2)) ? 1'b1 : 1'b0;
        in_region[2] = (signed'(i_din) >= signed'(MIN_LABEL_3) && signed'(i_din) <= signed'(MAX_LABEL_3)) ? 1'b1 : 1'b0;
        in_region[3] = (signed'(i_din) >= signed'(MIN_LABEL_4) && signed'(i_din) <= signed'(MAX_LABEL_4)) ? 1'b1 : 1'b0;
        in_region[4] = (signed'(i_din) >= signed'(MIN_LABEL_5) && signed'(i_din) <= signed'(MAX_LABEL_5)) ? 1'b1 : 1'b0;
    end

    // Compute minimum difference
    always @(*) begin
        min = 60'hFFFFFFFFFFFFFFF; // Maximum possible value
        min_locate = 3'dx;         // Default location
        for (int i = 0; i < 5; i++) begin
            if (in_region[i]) begin
                if (min == 60'hFFFFFFFFFFFFFFF) begin
                    min = i_din - average[i];
                    min_locate = i[2:0]; 
                end else begin
                    cal_temp = i_din - average[i]; 
                    if (cal_temp[59] & ~min[59]) begin
                        min = cal_temp; 
                        min_locate = i[2:0]; 
                    end else if (cal_temp[59] & min[59] | ~cal_temp[59] & ~min[59]) begin
                        if (min >= cal_temp) begin
                            min = cal_temp; 
                            min_locate = i[2:0];
                        end
                    end 
                end
            end
        end
    end

    // Output result
    always_ff @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            o_dout <= 5'd0;
        end else if (i_enable) begin
            o_dout <= 5'd0;      // Clear output
            o_dout[min_locate] <= 1'b1; // Set classified region
        end
    end

endmodule