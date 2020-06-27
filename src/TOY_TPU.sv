module TOY_TPU #(
        parameter   SIZE_MATRIX   = 4,
        parameter   ROW_NUMBER    = 4,
        parameter   COLUMN_NUMBER = 4
    )(
        input   logic   clk
    );

    wire [7:0] top_in[0:COLUMN_NUMBER-1];
    wire [7:0] left_in[0:ROW_NUMBER-1];
    wire [7:0] down_out[0:COLUMN_NUMBER-1];

    logic [7:0] size_row_A;
    logic [7:0] size_column_B;
    logic [7:0] size_columnrow_AB;

    wire    [8:0] compute_complete;
    wire    [8:0] fetch_complete;

    logic reset;
    logic through;

    logic [7:0] A_cache[0:ROW_NUMBER-1][0:COLUMN_NUMBER-1];
    logic [7:0] B_cache[0:SIZE_MATRIX-1][0:COLUMN_NUMBER-1];

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
    
    always_comb begin
        compute_complete = size_columnrow_AB + size_row_A + size_column_B - 1;
        fetch_complete = compute_complete + size_row_A; //これは嘘
    end

    reg [31:0] clk_cnt = 32'h0000_0000;
    always_ff @(posedge clk) begin
        clk_cnt <= clk_cnt + 1;
        if(clk_cnt == compute_complete) begin
            through <= 1;
        end else if(clk_cnt == fetch_complete) begin
            done <= 1;
        end
    end

    genvar i;

    generate
        always_ff @(posedge clk) begin
            if(cnt == 1) begin
                reset = 0;
            end
        end
        for(i = 0; i < SIZE_MATRIX; i = i + 1) begin: GenerateInput
            always_ff @(posedge clk) begin
                if(((i+1) <= cnt) && (cnt <= (i+size_columnrow_AB))) begin
                    top_in[i]   = A_cache[i][cnt - (i+1)];
                    left_in[i]  = B_cache[i][cnt - (i+1)];
                end else begin
                    top_in[i]   = 0;
                    left_in[i]  = 0;
                end
            end
        end
        always_ff @(posedge clk) begin
            if(SIZE_MATRIX+size_columnrow_AB-1 < cnt) begin
                through = 1;
            end else begin
                through = 0;
            end
        end
    endgenerate
endmodule
