module array_top(
    input logic clk
    );

    logic [31:0] cnt = 32'h0000_0000;
    logic [31:0] cnt_w;

    logic         reset = 1;
    logic         through = 0;
    logic   [7:0] top_in[0:3];
    logic   [7:0] left_in[0:3];
    logic   [7:0] down_out[0:3];

    logic [7:0] top_data[0:3][0:3];
    logic [7:0] left_data[0:3][0:3];

    array #(
            .ROW_NUMBER     (4),
            .COLUMN_NUMBER  (4)
        ) array (
            .clk        (clk        ),
            .reset      (reset      ),
            .through    (through    ),
            .top_in     (top_in     ),
            .left_in    (left_in    ),
            .down_out   (down_out   )
        );

    always_comb begin
        cnt_w = cnt + 1;
    end

    always_ff @(posedge clk) begin
        cnt = cnt_w;
        if(cnt == 1) begin
            reset = 0;
        end
        if((1 <= cnt) && (cnt <= 4)) begin
            top_in[0] = top_data[0][cnt - 1];
            left_in[0] = left_data[0][cnt - 1];
        end else begin
            top_in[0] = 0;
            left_in[0] = 0;
        end
        if((2 <= cnt) && (cnt <= 5)) begin
            top_in[1] = top_data[1][cnt - 2];
            left_in[1] = left_data[1][cnt - 2];
        end else begin
            top_in[1] = 0;
            left_in[1] = 0;
        end
        if((3 <= cnt) && (cnt <= 6)) begin
            top_in[2] = top_data[2][cnt - 3];
            left_in[2] = left_data[2][cnt - 3];
        end else begin
            top_in[2] = 0;
            left_in[2] = 0;
        end
        if((4 <= cnt) && (cnt <= 7)) begin
            top_in[3] = top_data[3][cnt - 4];
            left_in[3] = left_data[3][cnt - 4];
        end else begin
            top_in[3] = 0;
            left_in[3] = 0;
        end
        if(11 < cnt) begin
            through = 1;
        end else begin
            through = 0;
        end
    end

    initial begin
        top_data[0][0] = 8;
        top_data[0][1] = 9;
        top_data[0][2] = 1;
        top_data[0][3] = 2;
        top_data[1][0] = 1;
        top_data[1][1] = 7;
        top_data[1][2] = 1;
        top_data[1][3] = 5;
        top_data[2][0] = 1;
        top_data[2][1] = 1;
        top_data[2][2] = 3;
        top_data[2][3] = 4;
        top_data[3][0] = 2;
        top_data[3][1] = 3;
        top_data[3][2] = 1;
        top_data[3][3] = 1;

        left_data[0][0] = 1;
        left_data[0][1] = 3;
        left_data[0][2] = 5;
        left_data[0][3] = 7;
        left_data[1][0] = 0;
        left_data[1][1] = 1;
        left_data[1][2] = 9;
        left_data[1][3] = 3;
        left_data[2][0] = 2;
        left_data[2][1] = 8;
        left_data[2][2] = 4;
        left_data[2][3] = 4;
        left_data[3][0] = 8;
        left_data[3][1] = 2;
        left_data[3][2] = 8;
        left_data[3][3] = 5;
    end
endmodule
