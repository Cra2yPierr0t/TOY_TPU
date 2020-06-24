module array(
    input   logic       clk,
    input   logic       reset,
    input   logic       through,
    input   logic [7:0] top_in[0:255],
    input   logic [7:0] left_in[0:255],
    output  logic [7:0] down_out[0:255]
    );

    parameter ROW_NUMBER = 255;
    parameter COLUMN_NUMBER = 255;
    genvar row, column, i;

    wire [7:0]  w_column[0:ROW_NUMBER][0:COLUMN_NUMBER+1];
    wire [7:0]  w_row[0:ROW_NUMBER+1][0:COLUMN_NUMBER];

    generate
        for(row = 0; row < ROW_NUMBER+1; row = row + 1) begin: GenerateArray
            for(column = 0; column < COLUMN_NUMBER; column = column + 1) begin: GenerateVector
                PE PE(.clk      (clk    ),
                      .reset    (reset  ),
                      .through  (through),
                      .top_in   (w_column[row][column]  ),
                      .left_in  (w_row[row][column]     ),
                      .down_out (w_column[row][column+1]),
                      .right_out(w_row[row+1][column]   )
                    );
            end
        end

        for(i = 0; i < ROW_NUMBER+1; i = i + 1) begin: AssignIO
            assign w_row[0][i]     = top_in[i];
            assign w_column[i][0]  = left_in[i];
            assign down_out[i]     = w_row[ROW_NUMBER+1][i];
        end
    endgenerate
endmodule
