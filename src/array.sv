module array #(
        parameter ROW_NUMBER = 256,
        parameter COLUMN_NUMBER = 256 
    )(
        input   logic       clk,
        input   logic       reset,
        input   logic       through,
        input   logic [7:0] top_in[0:COLUMN_NUMBER-1],
        input   logic [7:0] left_in[0:ROW_NUMBER-1],
        output  logic [7:0] down_out[0:COLUMN_NUMBER-1]
    );


    genvar row, column, i;

    logic [7:0]  w_column[0:ROW_NUMBER][0:COLUMN_NUMBER];
    logic [7:0]  w_row[0:ROW_NUMBER][0:COLUMN_NUMBER];

    generate
        for(row = 0; row < ROW_NUMBER; row = row + 1) begin: GenerateArray
            for(column = 0; column < COLUMN_NUMBER; column = column + 1) begin: GenerateVector
                PE PE(.clk      (clk    ),
                      .reset    (reset  ),
                      .through  (through),
                      .top_in   (w_column[row][column]  ),
                      .left_in  (w_row[row][column]     ),
                      .down_out (w_column[row+1][column]),
                      .right_out(w_row[row][column+1]   )
                    );
            end
        end

        for(i = 0; i < ROW_NUMBER; i = i + 1) begin: AssignIO
            assign w_column[0][i]   = top_in[i];
            assign w_row[i][0]      = left_in[i];
            assign down_out[i]      = w_column[ROW_NUMBER][i];
        end
    endgenerate
endmodule
