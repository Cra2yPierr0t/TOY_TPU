module PE(
    input   logic       clk,
    input   logic       reset,
    input   logic       through,
    input   logic [7:0] top_in,
    input   logic [7:0] left_in,
    output  logic [7:0] down_out,
    output  logic [7:0] right_out
    );

    logic   [7:0] top_in_r;
    logic   [7:0] left_in_r;

    //logic   [7:0] w_mem;    //wire to local memory
    logic   [7:0] mem;      //local memory

    always_comb begin
        if(through) begin
            down_out = mem;
        end else begin
            down_out = top_in_r;
            right_out = left_in_r;
        end
    end

    always_ff @(posedge clk) begin
        if(reset) begin
            mem         = 8'h00;
        end else if(through) begin  //through memory content to down
            mem         = top_in;
        end else begin
            {top_in_r, left_in_r} = {top_in, left_in};
            mem = (top_in * left_in) + mem;          
        end
    end
endmodule
