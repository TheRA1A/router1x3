`timescale 1ns / 1ps

module fifo_tb(

    );

    reg clk,resetn,soft_reset;
    reg read_en,write_en;
    reg lfd_state;
    reg [7:0]data_in;
    wire [7:0]data_out;
    wire empty,full;
    
    fifo uut (
        .clk(clk),
        .resetn(resetn),
        .soft_reset(soft_reset),
        .read_en(read_en),
        .write_en(write_en),
        .lfd_state(lfd_state),
        .data_in(data_in),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    integer k;

    task initialize;
        begin
            resetn = 1'b0;
            soft_reset = 1'b1;
            {read_en,write_en} = 2'b00;
            repeat (2) @ (negedge clk);
            resetn = 1'b1;
            soft_reset = 1'b0;
        end
    endtask 

    task write;
        reg [7:0]payload_data,parity,header;
        reg [5:0]payload_len;
        reg [1:0]add;
        begin
            @(negedge clk);
            lfd_state = 1'b1;
            @(negedge clk);
            payload_len = 6'd14;
            add = 2'b01;
            header = {payload_len,add};
            data_in = header;
            lfd_state = 1'b0;
            write_en = 1'b1;
            for (k = 0; k < payload_len; k = k + 1)
            begin
                @(negedge clk);
                payload_data = {$random} % 256;
                data_in = payload_data;
            end
            @(posedge clk);
            parity = {$random} % 256;
            data_in = parity;
        end
    endtask

     initial
     begin
         clk = 1'b0;
         forever #5 clk = ~clk;
     end

     initial
     begin
         initialize;
         #2;
    //    {read_en,write_en} = 2'b01;
        write;
        #10;
        {read_en,write_en} = 2'b10;
        
        #200;
        $finish;

     end
    

endmodule
