`timescale 1ns / 1ps

module fifo_8x64_tb;

reg clk;
reg rst;
reg wr_en;
reg rd_en;
reg [7:0] data_in;
wire [7:0] data_out;
wire full;
wire empty;

// Instantiate the FIFO module
fifo #(.D_W(8), .DEPTH(64)) uut 
(
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);

// Clock generation
always #5 clk = ~clk; // Generate a clock with a period of 10 ns

integer file;
initial begin
    file = $fopen("test/fifo/output_data.txt", "w");
    if (file == 0) begin
        $display("Failed to open file.");
        $finish;
    end
end


// Test sequence
initial begin
    // Initialize inputs
    clk = 0;
    rst = 1;
    wr_en = 0;
    rd_en = 0;
    data_in = 0;
    
    // Reset the FIFO
    #10;
    rst = 0;
    
    // Write data into the FIFO
    repeat (65) begin
        #10;
        if (!full) begin
            wr_en = 1;
            data_in = data_in + 1; // Increment data for each write
        end else wr_en = 0; // If FIFO is full, stop writing
    end
    wr_en = 0; // Ensure write enable is disabled
    
    // Read data from the FIFO
    repeat (65) begin
        #10;
        if (!empty) rd_en = 1; // If FIFO is not empty, enable read
        else rd_en = 0; // If FIFO is empty, stop reading
    end
    rd_en = 0; // Ensure read enable is disabled
    
    // Complete simulation
    #100;
    $finish;
end

// In the part of your testbench where you want to record data_out
always @(posedge clk) begin
    if (rd_en) begin
        $fwrite(file, "%d\n", data_out); // Writing data_out to file
    end
end


initial begin
    // Initialize VCD dump
    $dumpfile("test/fifo/fifo_tb.vcd");
    $dumpvars(0, fifo_8x64_tb);
end

initial begin
    #10000; // Adjust the time according to your simulation
    $fclose(file);
    $finish;
end

endmodule
