module TOY_TPU(
        input   logic   clk
    );

    wire [7:0] top_in[0:255];
    wire [7:0] left_in[0:255];
    wire [7:0] down_out[0:255];

    logic [7:0] size_row_A;
    logic [7:0] size_column_B;
    logic [7:0] size_columnrow_AB;

    wire    [8:0] compute_complete;
    wire    [8:0] fetch_complete;

    logic reset;
    logic through;

    array array(
            .clk        (clk        ),
            .reset      (),
            .through    (),
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
endmodule
