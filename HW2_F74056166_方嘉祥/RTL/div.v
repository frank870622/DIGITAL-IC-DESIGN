`timescale 1ns / 10ps
module div(out, in1, in2, dbz);
parameter width = 8;
input  	[width-1:0] in1; // Dividend
input  	[width-1:0] in2; // Divisor
output reg [width-1:0] out; // Quotient
output reg dbz;

integer i;
reg[15:0] dividend;
reg[15:0] divisor;

always@(*)
begin
  if (in2 == 8'd0)
    begin
      dbz = 1;
    end
  else
    begin
      dbz = 0;
      dividend = {8'd0, in1};
      divisor = {in2, 8'd0};
      
      for(i = 0; i <= 8; i = i + 1)
        begin
          if(dividend >= divisor)
            begin
              dividend = dividend - divisor;
              out = out << 1;
              out[0] = 1;
              divisor = divisor >> 1;
            end
          else
            begin
              out = out << 1;
              out[0] = 0;
              divisor = divisor >> 1;
            end
        end
    end
end

endmodule