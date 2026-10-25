/* verilator lint_off UNUSEDSIGNAL */
module atlantic_if_tb;
    // inputs
    logic clk;
    logic reset;
    logic read_en;
    logic write_en;
    logic [31:0] write_data;
    logic sop;
    logic eop;

    // outputs
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

    always #5 clk = ~clk;


    initial begin
        $dumpfile("sim/atlantic_if_tb.vcd");
        $dumpvars(0, atlantic_if_tb);

        clk = 0;
        reset = 1;
        read_en = 0;
        write_en = 0;
        write_data = 0;
        

        #10 reset = 0;

        @(posedge clk);
        sop = 1;
        eop = 0;
        write_data = 32'h12345678;
        write_en = 1;



        $finish;
    end

endmodule
