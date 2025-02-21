module bram_to_median_7_controller(
    input  logic            i_clk,                     // Global clock
    input  logic            i_rst,                     // Global reset
    output logic [2:0]      o_state,                   // Test state
    output logic            o_enable_7x7               // Enable calculate median 3x3
);

/************************************ Signals ******************************************************/
    // State definitions
    typedef enum bit [2:0] {
        IDLE,                                      
        EN_FIRST_COL, 
        EN_COL, 
        EN_NEW_ROW, 
        WAIT_NEW_MATRIX
    } state_e;  

    // State variables
    state_e cur_state, next_state; 

    // Counter signals
    logic [6:0] counter;                           // Counter variable
    logic [1:0] counter_row;                       // Counter the row of matrix output median
    logic counter_enable;                          // Enable counter decrement

/************************************* Update current state ***************************************/ 
    always_ff @(posedge i_clk or posedge i_rst) begin : Update_current_state
        if (i_rst) begin 
            cur_state <= IDLE;  
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
        IDLE: begin
            if (counter == 6'd0) begin
                next_state = EN_FIRST_COL;       // Transition to EN_FIRST_COL
            end else begin
                counter_enable = 1'b1;           // Enable counter decrement
            end
        end
        EN_FIRST_COL: begin
            next_state = EN_COL;                 // Transition to EN_COL
        end
        EN_COL: begin
            if (counter == 6'd0) begin
                next_state = EN_NEW_ROW;         // Transition to EN_NEW_ROW
            end else begin
                counter_enable = 1'b1;           // Enable counter decrement
            end  
        end 
        EN_NEW_ROW: begin
            if (counter_row == 2'd2) begin
                next_state = WAIT_NEW_MATRIX;    // Transition to WAIT_NEW_MATRIX
            end else begin
                if (counter == 6'd0) begin
                    next_state = EN_FIRST_COL;   // Transition to EN_NEW_ROW
            end else begin
                    counter_enable = 1'b1;       // Enable counter decrement
            end  
            end
        end
        WAIT_NEW_MATRIX: begin 
            if (counter == 6'd0) begin
                next_state = EN_FIRST_COL;       // Transition to EN_FIRST_COL
            end else begin
                counter_enable = 1'b1;           // Enable counter decrement
            end  
        end 
        endcase
    end

/************************************* Counter logic *********************************************/ 
    always_ff @(posedge i_clk or posedge i_rst) begin : counter_logic
        if (i_rst) begin
            counter <= 7'd71;                     // Reset counter
        end else if (cur_state != next_state) begin
            // Load new counter value on state transition
            case (next_state)
            IDLE:               counter <= 7'd71;          // Delay for IDLE
            EN_COL:             counter <= 7'd1;           // Delay for EN_COL
            EN_NEW_ROW:         counter <= 7'd5;           // Delay for EN_New_ROW
            WAIT_NEW_MATRIX:    counter <= 7'd59;          // Delay for WAIT_NEW_MATRIX
            default: counter <= 6'd0;
            endcase
        end else if (counter_enable && counter > 0) begin
            counter <= counter - 7'd1;             // Decrement counter
        end
    end

    always_ff @(posedge i_clk or posedge i_rst) begin : counter_row_logic
        if (i_rst) begin
            counter_row <= 2'd0; 
        end else if ((cur_state == EN_NEW_ROW) && (next_state == EN_FIRST_COL || next_state == WAIT_NEW_MATRIX)) begin
            counter_row <= counter_row + 2'd1; 
        end else if (cur_state == WAIT_NEW_MATRIX && next_state == EN_FIRST_COL) begin
            counter_row <= 2'd0; // Reset counter_row when going back to IDLE
        end
    end

/************************************* Output signal *******************************************/ 
    assign o_enable_7x7 = (cur_state == EN_FIRST_COL || cur_state == EN_COL); 
    assign o_state      = cur_state; 

endmodule
