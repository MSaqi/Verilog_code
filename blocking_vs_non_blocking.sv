// Testbench
module test;
    bit clk = 0;
    bit [31:0] a = 1;
    bit [31:0] b = 2;
    bit [31:0] c = 3;


    always #1 clk<=~clk;
    initial begin
        #10;
        $display("Hello, World");
        $finish ;
    end
    initial begin 
      $display("NON-BLOCKING ASSIGNMENT");
        a<=b;
        $display("a = %d  b = %d c = %d",a,b,c);
        c<=a;
        $display("a = %d  b = %d c = %d",a,b,c);
      @(posedge clk);
      $display("a = %d  b = %d c = %d",a,b,c);
    end 
    initial begin 
      @(posedge clk);
      $display("BLOCKING ASSIGNMENT");
        a=b;
        $display("a = %d  b = %d c = %d",a,b,c);
        c=a;
        $display("a = %d  b = %d c = %d",a,b,c);
      @(posedge clk);
      $display("a = %d  b = %d c = %d",a,b,c);
    end 
endmodule
