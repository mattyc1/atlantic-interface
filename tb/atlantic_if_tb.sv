module atlantic_if_tb;

    logic clk;
    logic reset;
    logic read_en;
    logic write_en;
    logic [31:0] write_data;
    logic sop;
    logic eop;
    logic [31:0] read_data;
    logic empty;
    logic full;
    logic sop_out;
    logic eop_out;

    atlantic_if dut (
        .clk(clk),
        .reset(reset),
        .read_en(read_en),
        .write_en(write_en),
        .write_data(write_data),
        .sop(sop),
        .eop(eop),
        .read_data(read_data),
        .empty(empty),
        .full(full),
        .sop_out(sop_out),
        .eop_out(eop_out)
    );


    initial begin
        clk = 0;
        reset = 1;
        read_en = 0;
        write_en = 0;
        write_data = 0;
        sop = 0;
        eop = 0;

        #10 reset = 0;
    end

endmodule