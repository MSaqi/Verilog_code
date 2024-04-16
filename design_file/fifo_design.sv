////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : fifo_design.sv
//  Author        : Muhammad Saqib Saif
//
//  Copyright : All Rights Reserved.
//
//  No portions of this material may be reproduced in any form without
//  the written permission of:
//    Muhammad Saqib Saif
//
//  Description
//  ===========
// This file contains the underdeveloping FIFO design and A simple processor design combined in single file
////////////////////////////////////////////////////////////////////////////////

// Code your design here
module design1 (
    input bit clk,
    input bit rst,
    input bit [1:0] a,
    input bit [1:0] b,
    input bit [1:0] c,
    input bit invld,
    input bit [1:0] cntrl,     // 0 means ADD 1 means OR 2 means AND
    output bit [3:0] e,   // a,b
    output bit [3:0] f,  // b,c
    output bit [3:0] g,  // c,a
    output bit  vld
);
  always @(posedge clk) begin  // cntrl case 0 when needed only adders
    if (rst) begin
      e   <= 0;
      f   <= 0;
      g   <= 0;
      vld <= 0;
    end else if (cntrl == 0 && invld) begin  // this is the adder case
      vld <= 1'b1;
      e   <= a + b;
      f   <= b + c;
      g   <= c + a;
    end else if (cntrl == 1 && invld) begin  // OR gate case
      e   <= a | b;
      f   <= b | c;
      g   <= c | a;
      vld <= 1;
    end else if (cntrl == 2 && invld) begin  // AND Gate Case
      e   <= a & b;
      f   <= b & c;
      g   <= c & a;
      vld <= 1;
    end else begin  // Retain value with no valid update
      e   <= e;
      f   <= f;
      g   <= g;
      vld <= 0;
    end
  end
endmodule


module fifo #(
  parameter FIFO_DEPTH = 8,
  parameter FIFO_WIDTH = 3
) (
  input  logic                  clk       ,
  input  logic                  rst       ,
  input  logic                  wr_en     ,
  input  logic [FIFO_WIDTH-1:0] wr_data   ,
  input  logic                  rd_en     ,
  output logic                  rd_vld    ,
  output logic                  fifo_empty,
  output logic                  fifo_full ,
  output logic [FIFO_WIDTH-1:0] rd_data
);

  localparam FIFO_ADDR_WIDTH = $clog2(FIFO_DEPTH);

  logic [     FIFO_DEPTH-1:0][FIFO_WIDTH-1:0] fifo_memory;
  logic [FIFO_ADDR_WIDTH  :0]                 wr_addr    ; // 1 more bit than atual depth address so that we can have more addr variable increased value
  
  always_ff @ (posedge clk , negedge rst) begin // WRITE BLOCK 
    if(rst) begin
      wr_addr <= 0;      
      rd_data <= 0;
      rd_vld  <= 0;
      for (int i = 0; i < FIFO_DEPTH ;i++) begin 
        fifo_memory[i] <= 0;
      end 
    end 
    else if (wr_en && rd_en) begin 
      for (int i = 0; i < FIFO_DEPTH ;i++) begin 
        fifo_memory[i] <= fifo_memory[i+1];
      end
      fifo_memory[wr_addr - 1] <= wr_data;
      rd_data <= fifo_memory[0];
      wr_addr <= wr_addr;
      rd_vld <= 1;
    end  
    else if(wr_en && !rd_en) begin 
      fifo_memory[wr_addr] <= wr_data;
      wr_addr <= wr_addr + 1;
      rd_vld <= 0;
    end 
    else if (rd_en && !wr_en) begin 
      rd_data <= fifo_memory[0];
      wr_addr <= wr_addr - 1;
      rd_vld <= 1;
      for (int i = 0; i < FIFO_DEPTH ;i++) begin 
        fifo_memory[i] <= fifo_memory[i+1];
      end 
    end 
    else begin
      wr_addr <= wr_addr ;
      rd_vld  <= 0;
      rd_data <= rd_data ;
    end 
  end 
  always @ (*) begin   // FIFO Status for pusher 
    if(wr_addr >= FIFO_DEPTH) begin 
      fifo_full = 1;  
    end
    else fifo_full = 0;
  end 

  always @ (*) begin   // FIFO status for PoPER
    if(wr_addr == 0) begin 
      fifo_empty = 1;  
    end
    else fifo_empty = 0;
  end 
  
endmodule
