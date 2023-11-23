  task rdy_vld_driver_task ();
    tdata <= tdata;
    vld  <= 1'b1;
    @(posedge clk);

    while (~rdy) begin 
      @(posedge clk);
      #1;
    end     
    vld <= 1'b0;

  endtask : rdy_vld_driver_task  

  task rdy_vld_s_driver_task ();
    vld <= 1'b1;
    data <= data;
    side_info <= side_info;
    last <= last;
    @(posedge clk);
    while (~rdy) begin 
      @(posedge clk);
      #1;
    end     
    vld <= 1'b0;
  endtask : rdy_vld_S_driver_task  
