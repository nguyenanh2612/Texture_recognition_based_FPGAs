module bram_to_median_9_controller(
    input  logic i_clk, i_rst,                     // Clock and Reset
    output logic o_state,                          // Test state
    output logic o_enable_9x9                      // Enable calculate median 3x3
);

/************************************ Signals ******************************************************/
    // State definitions
    typedef enum bit{
        WAIT,                                      // Delay for 81 clocks
        EN
    } state_e;  

    // State variables
    state_e cur_state, next_state; 

    // Counter signals
    logic [6:0] counter;                           // Counter variable
    logic counter_enable;                          // Enable counter decrement

/************************************* Initial value **********************************************/ 
    initial begin
        cur_state = WAIT;
        counter = 7'd81;
    end

/************************************* Update current state ***************************************/ 
    always_ff @(posedge i_clk or posedge i_rst) begin : Update_current_state
        if (i_rst) begin 
            cur_state <= WAIT; 
        end else begin 
            cur_state <= next_state; 
        end 
    end

/************************************* State diagram *********************************************/ 
    always_comb begin : State_diagram
        // Default values
        next_state = cur_state;
        counter_enable = 1'b0;

        case (cur_state)
        WAIT: begin 
            if (counter == 6'd0) begin
                next_state = EN;                 // Transition to EN
            end else begin
                counter_enable = 1'b1;           // Enable counter decrement
            end
        end
        EN: begin
            next_state = WAIT;                   // Transition to WAIT
        end 
        endcase
    end

/************************************* Counter logic *********************************************/ 
    always_ff @(posedge i_clk or posedge i_rst) begin : counter_logic
        if (i_rst) begin
            counter <= 7'd80;                     // Reset counter
        end else if (cur_state != next_state) begin
            if (next_state == WAIT) begin 
                counter <= 7'd78;
            end 
        end else if (counter_enable && counter > 0) begin
            counter <= counter - 7'd1;             // Decrement counter
        end
    end

/************************************* Output signal *******************************************/ 
    assign o_enable_9x9 = (cur_state == EN); 
    assign o_state      = cur_state; 

endmodule
