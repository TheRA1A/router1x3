`timescale 1ns / 1ps

module synchronizer_tb(

    );

    reg clk,resetn;
    reg read_en_0,read_en_1,read_en_2;
    reg full_0,full_1,full_2;
    reg empty_0,empty_1,empty_2;
    reg detect_add,write_en_reg;
    reg [1:0]data_in;

    wire valid_out_0,valid_out_1,valid_out_2;
    wire soft_reset_0,soft_reset_1,soft_reset_2;
    wire fifo_full;
    wire [2:0] write_en;

    synchronizer uut (
        .clk(clk),
        .resetn(resetn),
        .read_en_0(read_en_0),
        .read_en_1(read_en_1),
        .read_en_2(read_en_2),
        .full_0(full_0),
        .full_1(full_1),
        .full_2(full_2),
        .empty_0(empty_0),
        .empty_1(empty_1),
        .empty_2(empty_2),
        .detect_add(detect_add),
        .write_en_reg(write_en_reg),
        .data_in(data_in),
        .valid_out_0(valid_out_0),
        .valid_out_1(valid_out_1),
        .valid_out_2(valid_out_2),
        .soft_reset_0(soft_reset_0),
        .soft_reset_1(soft_reset_1),
        .soft_reset_2(soft_reset_2),
        .fifo_full(fifo_full),
        .write_en(write_en)
    ); 

    // clk setup

    initial
    begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Initialize Task
    
    task initialize;
        begin
            resetn = 1'b0;
            detect_add = 1'b0;
            write_en_reg = 1'b0;
            data_in = 2'b00;
            empty_0 = 1'b1;
            empty_1 = 1'b1;
            empty_2 = 1'b1;
            read_en_0 = 1'b0;
            read_en_1 = 1'b0;
            read_en_2 = 1'b0;
            repeat (2) @(negedge clk);
            resetn = 1'b1;
        end
    endtask
    
    // Task for checking counter_0

    task counter_0 (input [1:0]data, input full,empty );
        begin
            @(negedge clk)
            begin
                detect_add = 1'b1;
                write_en_reg = 1'b1;
                data_in = data;
                full_0 = full;
                empty_0 = empty;
            end
         end
    endtask

    // Task for checking counter_1

    task counter_1 (input [1:0]data, input full,empty );
        begin
            @(negedge clk)
            begin
                detect_add = 1'b1;
                write_en_reg = 1'b1;
                data_in = data;
                full_1 = full;
                empty_1 = empty;
            end
        end
    endtask

    // Task for checking counter_2

    task counter_2 (input [1:0]data, input full,empty );
        begin
            @(negedge clk)
            begin
                detect_add = 1'b1;
                write_en_reg = 1'b1;
                data_in = data;
                full_2 = full;
                empty_2 = empty;
            end
         end
    endtask


    initial
    begin
        initialize;

        counter_0(2'b00,1'b0,1'b0);
        repeat (32)  @ (posedge clk);

        detect_add = 1'b0;
        write_en_reg = 1'b0;

        repeat (10) @ (posedge clk);

        counter_1(2'b01,1'b0,1'b0);
        repeat (32)  @ (posedge clk);

        detect_add = 1'b0;
        write_en_reg = 1'b0;
        
        repeat (10) @ (posedge clk);

        counter_2(2'b10,1'b0,1'b0);
        repeat (32)  @ (posedge clk);

        detect_add = 1'b0;
        write_en_reg = 1'b0;
        
         
        initialize;

        counter_0(2'b00,1'b0,1'b0);
        repeat (32)  @ (posedge clk);

        detect_add = 1'b0;
        write_en_reg = 1'b0;
        
        repeat (10) @ (posedge clk);

        counter_1(2'b01,1'b0,1'b0);
        repeat (32)  @ (posedge clk);

        detect_add = 1'b0;
        write_en_reg = 1'b0;
        
        repeat (10) @ (posedge clk);

        counter_2(2'b10,1'b0,1'b0);
        repeat (32)  @ (posedge clk);

        detect_add = 1'b0;
        write_en_reg = 1'b0;

        repeat (10) @ (posedge clk);

    end

    // Waitintg for valid_out signal
    initial
    begin
        wait (valid_out_0);
        repeat (5) @ (posedge clk);
        read_en_0 = 1'b1;

        wait (valid_out_1);
        repeat (4) @ (posedge clk);
        read_en_1 = 1'b1;

        wait (valid_out_2);
        repeat (12) @ (posedge clk);
        read_en_2 = 1'b1;
        
        initialize;

        wait (valid_out_0);
        repeat (31) @ (posedge clk);
        read_en_0 = 1'b1;

        wait (valid_out_1);
        repeat (40) @ (posedge clk);
        read_en_1 = 1'b1;

        wait (valid_out_2);
        repeat (37) @ (posedge clk);
        read_en_2 = 1'b1;


        
    end

    // initial
    // begin
    //     
    //     repeat (20) @ (posedge clk);
    //     full_0 = 1'b1;
    //     repeat (100) @ (posedge clk);
    //
    //     full_1 = 1'b1;
    //
    //     repeat (50) @ (posedge clk);
    //
    //     full_2 = 1'b1;
    //
    //     repeat (1) @ (posedge clk);
    //
    // end

    initial
    begin
        wait (write_en == 3'b001);
        repeat (5) @ (posedge clk);
        full_0 = 1'b1;
        @(posedge clk);
        full_0 = 1'b0;
        @(posedge clk);

        full_1 = 1'b1;
        @(posedge clk);
        full_1 = 1'b0;
        @(posedge clk);

        full_2 = 1'b1;
        @(posedge clk);
        full_2 = 1'b0;
        @(posedge clk);


        wait (write_en == 3'b010);
        repeat (5) @ (posedge clk);
        full_0 = 1'b1;
        @(posedge clk);
        full_0 = 1'b0;
        @(posedge clk);

        full_1 = 1'b1;
        @(posedge clk);
        full_1 = 1'b0;
        @(posedge clk);

        full_2 = 1'b1;
        @(posedge clk);
        full_2 = 1'b0;
        @(posedge clk);

        wait (write_en == 3'b100);
        repeat (5) @ (posedge clk);
        full_0 = 1'b1;
        @(posedge clk);
        full_0 = 1'b0;
        @(posedge clk);

        full_1 = 1'b1;
        @(posedge clk);
        full_1 = 1'b0;
        @(posedge clk);

        full_2 = 1'b1;
        @(posedge clk);
        full_2 = 1'b0;
        @(posedge clk);
    end


    initial
    begin
        repeat (300) @ (posedge clk);
        $finish;
    end




















endmodule
