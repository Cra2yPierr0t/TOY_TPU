module TOY_TPU #(
        parameter   SIZE_MATRIX   = 4,
        parameter   ROW_NUMBER    = 4,
        parameter   COLUMN_NUMBER = 4
    )(
        input   logic   clk
    );

    logic [7:0] top_in[0:COLUMN_NUMBER-1];
    logic [7:0] left_in[0:ROW_NUMBER-1];
    logic [7:0] down_out[0:COLUMN_NUMBER-1];

    logic [7:0] size_row_A;
    logic [7:0] size_column_B;
    logic [7:0] size_columnrow_AB;

    logic reset;
    logic through;

    logic [7:0] A_cache[0:ROW_NUMBER-1][0:COLUMN_NUMBER-1];
    logic [7:0] B_cache[0:ROW_NUMBER-1][0:COLUMN_NUMBER-1];
    logic [7:0] C_cache[0:ROW_NUMBER-1][0:COLUMN_NUMBER-1];

    array #(
            .ROW_NUMBER     (ROW_NUMBER     ),
            .COLUMN_NUMBER  (COLUMN_NUMBER  )
        ) array (
            .clk        (clk        ),
            .reset      (reset      ),
            .through    (through    ),
            .top_in     (top_in     ),
            .left_in    (left_in    ),
            .down_out   (down_out   )
        );
    
    reg [31:0] clk_cnt = 32'h0000_0000;
    always_ff @(posedge clk) begin
        if(size_column_B + size_columnrow_AB + SIZE_MATRIX < clk_cnt) begin
            clk_cnt = 32'h0000_0000;
        end else begin
            clk_cnt <= clk_cnt + 1;
        end
    end

    genvar i;
    logic [7:0] C_cache_index;

    generate
        always_ff @(posedge clk) begin
            if(clk_cnt == 1) begin
                reset = 0;
            end
        end
        for(i = 0; i < SIZE_MATRIX; i = i + 1) begin: GenerateInput
            always_ff @(posedge clk) begin
                if(((i+1) <= clk_cnt) && (clk_cnt <= (i+size_columnrow_AB))) begin
                    left_in[i]  = A_cache[i][clk_cnt - (i+1)];
                    top_in[i]   = B_cache[clk_cnt - (i+1)][i];
                end else begin
                    left_in[i]  = 0;
                    top_in[i]   = 0;
                end
            end
        end
    endgenerate

    always_ff @(posedge clk) begin
        if((size_column_B + size_columnrow_AB < clk_cnt) && (clk_cnt <= size_column_B + size_columnrow_AB + SIZE_MATRIX - size_row_A)) begin
            through <= 1;
            C_cache_index <= 0;
        end else if((size_column_B + size_columnrow_AB - size_row_A + SIZE_MATRIX < clk_cnt) && (clk_cnt <= size_column_B + size_columnrow_AB + SIZE_MATRIX)) begin
            through <= 1;
            C_cache[C_cache_index] <= down_out;
            C_cache_index <= C_cache_index + 1;
        end else begin
            through <= 0;
        end
    end
endmodule
