typedef struct packet {
    logic [DATA_WIDTH-1:0] data;
    logic                  sop;
    logic                  eop;
} fifo_entry_t;

const DATA_WIDTH = 32; // 32 bits per packet
const DEPTH = 16; // 16 packets


// full
// empty
// write pointer
// read pointer
// write data
// counter to store if empty or full
// read enable
// write enable


module fifo (
    input logic clk,
    input logic reset,
    input logic read_en,
    input logic write_en,
    input logic [DATA_WIDTH-1:0] write_data,

    output logic [DATA_WIDTH-1:0] read_data,
    output logic empty,
    output logic full,
)(
    logic [DATA_WIDTH-1:0] memory [$clog2(DEPTH)-1:0];
    logic [$clog2(DEPTH)-1:0] write_pointer;
    logic [$clog2(DEPTH)-1:0] read_pointer;
    logic [$clog2(DEPTH)-1:0] counter;

    always_ff @ (posedge clk or posedge reset) begin
        if (reset) begin
            write_pointer <= 0;
            read_pointer <= 0;
            counter <= 0;
        end
        else if (write_en && !full) begin
            memory[write_pointer] <= write_data;
            write_pointer <= write_pointer + 1;
            counter <= counter + 1;
        end
        else if (read_en && !empty) begin
            read_data <= memory[write_pointer];
            read_pointer <= read_pointer + 1;
            counter <= counter - 1;
        end
    end

// full/empty logic
// counter == depth -> full
// counter == 0 -> empty
)
endmodule





