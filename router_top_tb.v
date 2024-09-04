`timescale 1ns / 1ps

module router_top_tb(

    );

    reg clk,resetn;
    reg read_en_0,read_en_1,read_en_2;
    reg pkt_valid;
    reg [7:0]data_in;

    wire [7:0]data_out_0,data_out_1,data_out_2;
    wire valid_out_0,valid_out_1,valid_out_2;
    wire err,busy;

    router_top uut (
        .clk(clk),
        .read_en_0(read_en_0),
        .read_en_1(read_en_1),
        .read_en_2(read_en_2),
        .pkt_valid(pkt_valid),
        .data_in(data_in),
        .data_out_0(data_out_0),
        .data_out_1(data_out_1),
        .data_out_2(data_out_2),
        .valid_out_0(valid_out_0),
        .valid_out_1(valid_out_1),
        .valid_out_2(valid_out_2),
        .err(err),
        .busy(busy)
    );

    // clk

    initial
    begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task initialize;
        begin
            resetn = 1'b0;
            read_en_0 = 1'b0;
            read_en_1 = 1'b0;
            read_en_2 = 1'b0;
            pkt_valid = 1'b0;
            data_in = 8'b0;
            @(negedge clk);
            resetn = 1'b1;
        end
    endtask

    integer i;

    task packet_write (input [1:0]a, input [5:0]len);
        reg [7:0]header,parity,payload;
        reg [5:0]payload_len;
        reg [1:0]add;
        reg read_en;
        begin
            @(negedge clk);
            pkt_valid = 1'b1;
            add = a;
            payload_len = len;
            header = {payload_len,add};
            data_in = header;
            parity = 8'h00;
            parity = parity ^ data_in;
            @(negedge clk);
            for (i = 0; i < payload_len; i = i + 1)
            begin
                @(negedge clk);
                payload = {$random} % 256;
                data_in = payload;
                parity = parity ^ data_in;
            end
            @(negedge clk);
            pkt_valid = 1'b0;
            data_in = parity;
        end
    endtask


    initial
    begin
        initialize;

        packet_write(2'b00, 6'd5);
        repeat (2) @ (negedge clk);

        packet_write(2'b01, 6'd20);
        repeat (2) @ (negedge clk);

        packet_write(2'b10, 6'd20);
        repeat (2) @ (negedge clk);

        #500;
        $finish;
    end

    // initial
    // begin
    //     wait (valid_out_0);
    //     repeat (2) @(negedge clk) read_en_0 = 1'b1;
    // end
    //
    // initial
    // begin
    //     wait (valid_out_1);
    //     repeat (2) @ (negedge clk) read_en_1 = 1'b1;
    // end
    //
    // initial
    // begin
    //     wait (valid_out_2);
    //     repeat (2) @ (negedge clk) read_en_2 = 1'b1;
    // end

    // initial
    // fork
    //     wait (valid_out_0) repeat (10) @(negedge clk) read_en_0 = 1'b1;
    //     wait (valid_out_1) repeat (2) @(negedge clk) read_en_1 = 1'b1;
    //     wait (valid_out_2) repeat (2) @(negedge clk) read_en_2 = 1'b1;
    // join
    
    initial
    fork
        wait (valid_out_0)
        begin
            repeat (2) @ (negedge clk);
            read_en_0 = 1'b1;
        end

        wait (valid_out_1)
        begin
            repeat (2) @ (negedge clk);
            read_en_1 = 1'b1;
        end

        wait (valid_out_2)
        begin
            repeat (20) @ (negedge clk);
            read_en_2 = 1'b1;
        end
    join

endmodule
