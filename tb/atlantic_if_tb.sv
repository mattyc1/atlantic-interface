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

    always #5 clk = ~clk;

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


    task check_read_cycle(
        logic [31:0] expected_data,
        logic expected_sop,
        logic expected_eop,
        logic expected_empty
    );
        if (expected_data !== read_data) begin
            $error("FAIL: EXPECTED: %h | RECEIVED: %h", expected_data, read_data);
        end else begin
            $display("PASS: READ DATA MATCHES");
        end
        
        if (expected_sop !== sop_out) begin
            $error("FAIL: EXPECTED: %b | RECEIVED: %b", expected_sop, sop_out);
        end else begin
            $display("PASS: SOP DATA MATCHES");
        end

        if (expected_eop !== eop_out) begin
            $error("FAIL: EXPECTED: %b | RECEIVED: %b", expected_eop, eop_out);
        end else begin
            $display("PASS: EOP DATA MATCHES");
        end

        if (expected_empty !== empty) begin
            $error("FAIL: EXPECTED: %b | RECEIVED: %b", expected_empty, empty);
        end else begin
            $display("PASS: EMPTY DATA MATCHES");
        end

    endtask

    initial begin
        $dumpfile("sim/atlantic_if_tb.vcd");
        $dumpvars(0, atlantic_if_tb);

        clk = 0;
        reset = 1;
        read_en = 0;
        write_en = 0;
        write_data = '0;
        sop = 0;
        eop = 0;
    
        #10;
        reset = 0;

        // write 1 packet, read 1 packet back
        @(posedge clk);
        write_en = 1;
        write_data = 32'hA0B0C0D0;
        sop = 1;
        eop = 1;

        @(posedge clk);
        write_en = 0;
        read_en = 1;

        @(posedge clk)
        read_en = 0;

        #1;
        check_read_cycle(32'hA0B0C0D0, 1, 1, 1);

        #20

        $finish;
    end

endmodule
