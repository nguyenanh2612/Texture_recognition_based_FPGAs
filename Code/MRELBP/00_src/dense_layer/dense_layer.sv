module dense_layer(
    input logic i_clk,              // Clock
    input logic i_rst,              // Reset
    input logic i_start,            // Start signal
    input logic [23:0] i_ni_rd,     // Input data
    input logic signed [23:0] i_weight,    // Weight data

    output logic o_done,            // Done signal
    output logic signed [55:0] o_dout     // Output data
);
    
    int count = 1; // Counter for the number of weights
    logic signed [47:0] product;
    logic signed [47:0] ni_rd_ext;


    assign ni_rd_ext = {24'd0,i_ni_rd}; // Extend input data to 48 bits
    assign product = $signed(ni_rd_ext) * i_weight; // Multiply input data with weight


    always_ff @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            o_done <= 1'b0;
            o_dout <= 56'b0;
        end else begin
            if (i_start & count < 257) begin
                o_dout <= o_dout + {{8{product[47]}},product};
                count <= count + 1;
            end else if (count == 257) begin
                o_done <= 1'b1;
            end
        end
    end
endmodule