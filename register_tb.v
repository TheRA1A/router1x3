`timescale 1ns / 1ps

module register_tb(

    );

    reg clk,resetn;
    reg pkt_valid;
    reg fifo_full;
    reg ld_state,full_state,laf_state,lfd_state,detect_add,rst_int_reg;
    reg [7:0]data_in;

    wire parity_done;
    wire low_pkt_valid;
    wire err;
    wire [7:0]data_out;

    register uut (
        .clk(clk),
        .resetn(resetn),
        .pkt_valid(pkt_valid),
        .fifo_full(fifo_full),
        .ld_state(ld_state),
        .full_state(full_state),
        .laf_state(laf_state),
        .lfd_state(lfd_state),
        .detect_add(detect_add),
        .rst_int_reg(rst_int_reg),
        .data_in(data_in),
        .parity_done(parity_done),
        .low_pkt_valid(low_pkt_valid),
        .err(err),
        .data_out(data_out)
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
            @(negedge clk);
            resetn = 1'b1;
            {pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state}=0;
            data_in = 2'b00;
        end
    endtask

    integer i;

    task packet;
        reg [7:0]payload_data,parity,header;
        reg [5:0]payload_len;
        reg [1:0]add;
        begin
            @(negedge clk);
            pkt_valid = 1'b1;
            detect_add = 1'b1;
            add = 2'b01;
            payload_len = 6'd20;
            parity = 8'h00;
            header = {payload_len,add};
            data_in = header;
            parity = parity ^ data_in;
            @(negedge clk);
            detect_add = 1'b0;
            lfd_state = 1'b1;
            ld_state = 1'b1;
            fifo_full = 1'b0;
            laf_state = 1'b0;
            for (i = 0; i < payload_len; i = i + 1)
            begin
                @(negedge clk);
                lfd_state = 1'b0;
                ld_state = 1'b1;
                payload_data = {$random} % 256;
                data_in = payload_data;
                parity = parity ^ data_in;
                if (i == 16)
                    fifo_full = 1'b1;
            end
            @(negedge clk);
            pkt_valid = 1'b0;
            data_in = parity;
            @(negedge clk);
            ld_state = 1'b0;
        end
    endtask

    initial
    begin
        initialize;
        @(posedge clk);
        packet;
        #50;
        $stop;
    end

endmodule
