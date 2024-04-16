////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : tb_fifo_design.sv
//  Author        : Muhammad Saqib Saif
//
//  Copyright. All Rights Reserved.
//
//  No portions of this material may be reproduced in any form without
//  the written permission of:
//    Muhammad Saqib Saif
//
//  All information contained in this document is Sahil Semiconductor
//  company private, proprietary and trade secret.
//
//  Description
//  ===========
// Test bench under progress for Testing the design fifi and design module.
////////////////////////////////////////////////////////////////////////////////

module tb();
  localparam FIFO_DEPTH = 8;
  localparam FIFO_WIDTH = 3;

  bit [1:0] a    ;
  bit [1:0] b    ;
  bit [1:0] c    ;
  bit [3:0] e    ;
  bit [3:0] f    ;
  bit [3:0] g    ;
  bit       clk  ;
  bit       rst  ;
  bit       invld,vld;
  bit [1:0] cntrl;
  bit [FIFO_WIDTH-1:0] fifo_q[$];
  int rd_out_data_var;
  logic                  fifo_full;
  logic                  wr_en    ;
  logic [FIFO_WIDTH-1:0] wr_data  ;

  logic                  rd_en     ;
  logic                  rd_vld    ;
  logic                  fifo_empty;
  logic [FIFO_WIDTH-1:0] rd_data   ;



  fifo fifo_inst (
      .clk(clk),
      .rst(rst),
      .wr_en(wr_en),
      .wr_data(wr_data),
      .rd_en(rd_en),
      .rd_vld(rd_vld),
      .fifo_empty(fifo_empty),
      .fifo_full(fifo_full),
      .rd_data(rd_data)
    );
  design1 design_1(
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .c(c),
        .invld(invld),
        .vld(vld),
        .cntrl(cntrl),
        .e(e),
        .f(f),
        .g(g)
    );

    always #5 clk=~clk; 
    initial begin 
      $dumpfile("dump.vcd");
      $dumpvars;
    end 
    // ================== Design TB code ==================== // 
    initial begin 
      @(posedge clk);
        rst = 1 ;
      @(posedge clk);
        rst = 0;
      @(posedge clk);
      for(int i = 0 ;i<4;i++) begin
          @(posedge clk);
            a <= i ;
            b <= i+1;
            c <=  i+2;
            cntrl <= 0;
            invld <= 0;
        end
      @(posedge clk);
      invld <= 0;
      @(posedge clk);
      for(int i = 0 ;i<4;i++) begin
          @(posedge clk);
            a <= i ;
            b <= i+1;
            c <=  i+2;
            cntrl <= 1;
            invld <= 1;
        end
      @(posedge clk);
      invld <= 0;
	  // @(posedge clk);
   //      rst = 1 ;
   //    @(posedge clk);
   //      rst = 0;
   //    @(posedge clk);
      for(int i = 0 ;i<4;i++) begin
          @(posedge clk);
            a <= i ;
            b <= i+1;
            c <=  i+2;
            cntrl <= 2;
            invld <= 1;
       end
    end

    //  ==================== FIFO TEST BENCH ====================//  
    initial begin 
      rd_en = 0;
      wr_en = 0;
      wr_data = 0;
      #30;
      for(int i = 0 ;i<4;i++) begin
        dr_write_fifo(i);
        $display("PUSHING FIFO");
        fifo_q.push_front(i);
      end
      @(posedge clk);
      for(int i = 0 ;i<4;i++) begin
        dr_read_fifo();
        $display("Popping FIFO");
      end
      @(posedge clk);
      fork 
        begin 
          for(int i = 0 ;i<100;i++) begin
            dr_write_fifo(i);
            $display("PUSHING FIFO");
            fifo_q.push_front(i);
          end
          @(posedge clk);
        end
        begin 
          for(int i = 0 ;i<100;i++) begin
            if(i == 50) begin
              for(int i =0;i<10;i++) @(posedge clk);
            end
            else begin 
              dr_read_fifo();
              $display("Popping FIFO");
            end
          end
          @(posedge clk);
        end
      join
    end 
    initial begin  // watch dog timer 
      #5000;
      $finish; 
    end 

    always@(*) begin
      if(rd_vld) begin 
        rd_out_data_var = fifo_q.pop_back();
        if(rd_out_data_var == rd_data) begin 
          $display("transaction matched");
        end
        else begin 
          $display("transaction mmis matched expected = %d actual dut  = %d",rd_out_data_var,rd_data);          
        end
      end 
    end 

    task dr_read_fifo();
      rd_en <= 0;
      while(fifo_empty) begin 
        @(posedge clk);
      end 
      rd_en <= 1 ;
      @(posedge clk);
      rd_en <= 0;
    endtask : dr_read_fifo

    task dr_write_fifo(input int data);
      wr_en <= 0;
      while(fifo_full) begin 
        @(posedge clk);
      end 
      wr_en <= 1;
      wr_data <= data;
      @(posedge clk);
      wr_en <= 0;
    endtask : dr_write_fifo
endmodule 
