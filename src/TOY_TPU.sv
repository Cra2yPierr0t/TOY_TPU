module TOY_TPU #(
        parameter   SIZE_MATRIX   = 4,
        parameter   ROW_NUMBER    = 4,
        parameter   COLUMN_NUMBER = 4
    )(
        input   logic   clk,
        input   logic   activate_plz
    );

    logic [7:0] top_in[0:COLUMN_NUMBER-1];
    logic [7:0] left_in[0:ROW_NUMBER-1];
    logic [7:0] down_out[0:COLUMN_NUMBER-1];

    logic [7:0] size_row_A;
    logic [7:0] size_column_B;
    logic [7:0] size_columnrow_AB;

    logic reset = 1; //tmp
    logic through = 0;

    logic [7:0] A_cache[0:ROW_NUMBER-1][0:COLUMN_NUMBER-1];
    logic [7:0] B_cache[0:ROW_NUMBER-1][0:COLUMN_NUMBER-1];
    logic [7:0] C_cache[0:ROW_NUMBER-1][0:COLUMN_NUMBER-1];

// verilator lint_off BLKANDNBLK
    logic [31:0] clk_cnt = 32'h0000_0000;
// verilator lint_on BLKANDNBLK

    logic activate_clk = 0;
    logic activate = 0;

    logic flag = 0;

    always_ff @(posedge clk) begin          //ここ最悪
        if(clk_cnt == 32'h0000_0000) begin
            activate = 0;
        end if(activate_plz) begin
            activate = 1;
        end else begin
            activate = activate;
        end
    end

    always_comb begin
        if(activate == 1) begin
            activate_clk = clk;
        end else begin
            activate_clk = 0;
        end
    end

    initial begin
        A_cache[0][0] = 1;
        A_cache[0][1] = 2;
        A_cache[0][2] = 3;
        A_cache[1][0] = 4;
        A_cache[1][1] = 5;
        A_cache[1][2] = 6;

        B_cache[0][0] = 7;
        B_cache[1][0] = 8;
        B_cache[2][0] = 9;

        size_row_A = 2;
        size_column_B = 1;
        size_columnrow_AB = 3;
    end

    array #(
            .ROW_NUMBER     (ROW_NUMBER     ),
            .COLUMN_NUMBER  (COLUMN_NUMBER  )
        ) array (
            .clk        (activate_clk),
            .reset      (reset      ),
            .through    (through    ),
            .top_in     (top_in     ),
            .left_in    (left_in    ),
            .down_out   (down_out   )
        );

    
    always_ff @(posedge activate_clk) begin
        if(size_column_B + size_columnrow_AB + SIZE_MATRIX + 1 < clk_cnt) begin
            clk_cnt <= 32'h0000_0000;
        end else begin
            clk_cnt <= clk_cnt + 1;
        end
    end

    genvar i;
    logic [7:0] C_cache_index;

    generate
        always_ff @(posedge activate_clk) begin
            if(clk_cnt == 1) begin
                C_cache_index <= 0;
                reset = 0;
            end
        end
        for(i = 0; i < SIZE_MATRIX; i = i + 1) begin: GenerateInput
            always_ff @(posedge activate_clk) begin
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

    always_ff @(posedge activate_clk) begin
        if((size_column_B + size_columnrow_AB < clk_cnt) && (clk_cnt <= size_column_B + size_columnrow_AB + SIZE_MATRIX - size_row_A + 1)) begin
            through <= 1;
            C_cache_index <= size_row_A - 1;
        end else if((size_column_B + size_columnrow_AB - size_row_A + SIZE_MATRIX + 1< clk_cnt) && (clk_cnt <= size_column_B + size_columnrow_AB + SIZE_MATRIX + 1)) begin
            through <= 1;
            C_cache[C_cache_index] <= down_out;
            C_cache_index <= C_cache_index - 1;
        end else begin
            through <= 0;
        end
    end
endmodule
