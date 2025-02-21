module bitonic_sort_2 #(
    parameter WIDTH = 8
) (
    input logic [WIDTH-1:0] i_number_a, i_number_b, 
    output logic [WIDTH-1:0] o_min,o_max
);
    always_comb begin
        if (i_number_a <= i_number_b) begin
            o_min = i_number_a; 
            o_max = i_number_b; 
        end else begin
            o_min = i_number_b; 
            o_max = i_number_a; 
        end
    end
endmodule 