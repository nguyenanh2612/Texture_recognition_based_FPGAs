module bram (
    input logic i_clk, 
    input logic in_rst, 
    input logic [7:0] i_data,                  // 8 bits data per pixel
    input logic i_wren,                        // write enable signal
    output logic [7:0] o_data [5:0] [8:0]      // output 8 shift registers, which have 9 pixels per shift register
);

    // Define 8 shift registers, each with 9 pixels of 8-bit data
    logic [7:0] shift_registers [7:0] [8:0];  
    logic [7:0] pixel0;

    // write 
    always_ff @( posedge i_clk or negedge in_rst ) begin
        if (~in_rst) begin
            for (int i = 0; i < 8; i++) begin
                for (int j = 0; j < 9; j++) begin
                    shift_registers[i][j] <= 8'd0;
                end
            end
        end else if (i_wren) begin
            for (int i = 7; i >= 0; i--) begin 
                for (int j = 8; j > 0; j--) begin
                    shift_registers [i][j - 1] <= shift_registers[i][j];
                end
                if (i > 0) begin
                    pixel0 <= shift_registers[i - 1][0]; 
                end else begin
                    pixel0 <= i_data;
                end

                shift_registers[i][8] <= pixel0; 
            end
        end
    end

    // Take out data
    always_comb begin
        for (int i = 0; i < 6; i++) begin : shift_out
            for (int j = 0; j < 9; j++) begin : inner_shift_out
                o_data[i][j] = shift_registers[i][j];
            end
        end
    end

endmodule 