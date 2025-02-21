module sorted_3_elements #(
    parameter WIDTH = 8
) (
    input logic [WIDTH-1:0] i_element_0, i_element_1, i_element_2,
    output logic [WIDTH-1:0] o_element_0, o_element_1, o_element_2
);
    logic [WIDTH-1:0] sorted [2:0];
    logic [WIDTH-1:0] temp;

    always_comb begin
        // Initial assignment
		  temp = 8'd0; 
        sorted[0] = i_element_0;
        sorted[1] = i_element_1;
        sorted[2] = i_element_2;

        // Sort elements 0 and 1
        if (sorted[0] > sorted[1]) begin
            temp = sorted[0];
            sorted[0] = sorted[1];
            sorted[1] = temp;
        end

        // Sort elements 1 and 2
        if (sorted[1] > sorted[2]) begin
            temp = sorted[1];
            sorted[1] = sorted[2];
            sorted[2] = temp;
        end

        // Final check for elements 0 and 1 (in case the sort of elements 1 and 2 affected the order)
        if (sorted[0] > sorted[1]) begin
            temp = sorted[0];
            sorted[0] = sorted[1];
            sorted[1] = temp;
        end
    end

    // Assign sorted elements to outputs
    assign o_element_0 = sorted[0];
    assign o_element_1 = sorted[1];
    assign o_element_2 = sorted[2];

endmodule
