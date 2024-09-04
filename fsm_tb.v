`timescale 1ns / 1ps

module fsm_tb(

    );

        reg clk,resetn;
        reg pkt_valid;
        reg parity_done;
        reg soft_reset_0,soft_reset_1,soft_reset_2;
        reg fifo_empty_0,fifo_empty_1,fifo_empty_2;
        reg fifo_full;
        reg low_pkt_valid;
        reg [1:0]data_in;

        wire busy;
        wire detect_add;
        wire ld_state,lfd_state,laf_state,full_state;
        wire write_en_reg,rst_int_reg;


        fsm uut (
            .clk(clk),
            .resetn(resetn),
            .pkt_valid(pkt_valid),
            .parity_done(parity_done),
            .soft_reset_0(soft_reset_0),
            .soft_reset_1(soft_reset_1),
            .soft_reset_2(soft_reset_2),
            .fifo_empty_0(fifo_empty_0),
            .fifo_empty_1(fifo_empty_1),
            .fifo_empty_2(fifo_empty_2),
            .fifo_full(fifo_full),
            .low_pkt_valid(low_pkt_valid),
            .data_in(data_in),
            .busy(busy),
            .detect_add(detect_add),
            .lfd_state(lfd_state),
            .ld_state(ld_state),
            .laf_state(laf_state),
            .full_state(full_state),
            .write_en_reg(write_en_reg),
            .rst_int_reg(rst_int_reg)
        );

        //clk
        initial
        begin
            clk = 1'b0;
            forever #5 clk = ~clk;
        end

        task initilize;
            begin
                resetn = 1'b0;
                soft_reset_0 = 1'b1;
                soft_reset_1 = 1'b1;
                soft_reset_2 = 1'b1;
                @ (negedge clk);
                resetn = 1'b1;
                pkt_valid = 1'b0;
                parity_done = 1'b0;
                soft_reset_0 = 1'b0;
                soft_reset_1 = 1'b0;
                soft_reset_2 = 1'b0;
                fifo_empty_0 = 1'b0;
                fifo_empty_1 = 1'b0;
                fifo_empty_2 = 1'b0;
                fifo_full = 1'b0;
                low_pkt_valid = 1'b1;
                data_in = 1'b0;
            end
        endtask


        task task1;
            begin
                @(negedge clk);
                pkt_valid = 1'b1;
                data_in = 2'b01;
                fifo_empty_1 = 1'b1;
                repeat (2) @(negedge clk);
                fifo_full = 1'b0;
                pkt_valid = 1'b0;
                repeat (2) @(negedge clk);
                fifo_full = 1'b0;
            end
        endtask

        task task2;
            begin
                @(negedge clk);
                pkt_valid = 1'b1;
                data_in = 2'b01;
                fifo_empty_1 = 1'b1;
                repeat (2) @(negedge clk);
                fifo_full = 1'b1;
                @(negedge clk);
                fifo_full = 1'b0;
                @(negedge clk);
                parity_done = 1'b0;
                low_pkt_valid = 1'b1;
                repeat (2) @(negedge clk);
                fifo_full = 1'b0;
            end
        endtask

        task task3;
            begin
                @(negedge clk);
                pkt_valid = 1'b1;
                data_in = 2'b01;
                fifo_empty_1 = 1'b1;
                repeat (2) @(negedge clk);
                fifo_full = 1'b1;
                @(negedge clk);
                fifo_full = 1'b0;
                @(negedge clk);
                parity_done = 1'b0;
                low_pkt_valid = 1'b0;
                @(negedge clk);
                fifo_full = 1'b0;
                pkt_valid = 1'b0;
                repeat (2) @(negedge clk);
                fifo_full = 1'b0;
            end
        endtask

        task task4;
            begin
                @(negedge clk);
                pkt_valid = 1'b1;
                data_in = 2'b01;
                fifo_empty_1 = 1'b1;
                repeat (2) @(negedge clk);
                fifo_full = 1'b0;
                pkt_valid = 1'b0;
                repeat (2) @(negedge clk);
                fifo_full = 1'b1;
                @(negedge clk);
                fifo_full = 1'b0;
                @(negedge clk);
                parity_done = 1'b1;
            end
        endtask

        task task5;
            begin
                @(negedge clk);
                pkt_valid = 1'b1;
                data_in = 2'b01;
                fifo_empty_1 = 1'b0;
                @(negedge clk);
                fifo_empty_1 = 1'b1;
                data_in = 2'b01;
                repeat (2) @ (negedge clk);
                fifo_full = 1'b0;
                pkt_valid = 1'b0;
                @(negedge clk);
                repeat (2) @ (negedge clk);
                fifo_full = 1'b0;
            end
        endtask

        initial
        begin
            initilize;
            task1;
            repeat (4) @(negedge clk);
            task2;
            repeat (4) @(negedge clk);
            task3;
            repeat (4) @(negedge clk);
            task4;
            repeat (4) @(negedge clk);
            task5; 
            #20;
            $finish;
        end

endmodule
