localparam DATA_WIDTH = 32; // 32 bits per packet
localparam DEPTH = 16; // 16 packets

typedef struct packed {
    logic [DATA_WIDTH-1:0] data;
    logic                  sop;
    logic                  eop;
} fifo_entry_t;

module fifo (
    input logic clk,
    input logic reset,
    input logic read_en,
    input logic write_en,
    input logic [DATA_WIDTH-1:0] write_data,
    input logic sop,
    input logic eop,


    output logic [DATA_WIDTH-1:0] read_data,
    output logic empty,
    output logic full
);
    logic [DATA_WIDTH - 1:0] memory [0:DEPTH - 1]; // 31:0 bits allocated for 15 indices 0 - 15
    logic [$clog2(DEPTH)-1:0] write_pointer;
    logic [$clog2(DEPTH)-1:0] read_pointer;
    logic [$clog2(DEPTH):0] counter;

    always_ff @ (posedge clk or posedge reset) begin
        if (reset) begin
            write_pointer <= 0;
            read_pointer <= 0;
            counter <= 0;
        end
        else if (write_en && !full) begin
            memory[write_pointer] <= write_data;
            
            if (write_pointer == DEPTH - 1) begin
                write_pointer <= 0;
            end
            else begin
                write_pointer <= write_pointer + 1;
            end
            counter <= counter + 1;
        end
        else if (read_en && !empty) begin
            read_data <= memory[read_pointer];

            if (read_pointer == DEPTH - 1) begin
                read_pointer <= 0;
            end
            else begin
                read_pointer <= read_pointer + 1;
            end
            counter <= counter - 1;
        end
    end

    always_comb begin
        if (counter == DEPTH) begin
            full = 1;
        end
        else begin
            full = 0;
        end

        if (counter == 0) begin
            empty = 1;
        end
        else begin
            empty = 0;
        end
    end
endmodule





