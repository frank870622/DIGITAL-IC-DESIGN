`timescale 1ns/10ps
module CS(Y, X, reset, clk);

input clk, reset; 
input  [7:0] X;
output 	reg [9:0] Y;

reg [2:0]count;

reg [7:0] Xs[7:0];
reg [7:0] Xavgi;
reg [10:0] Xall;
reg [7:0] Xappr;
reg [7:0] Xdiff;


always@ (posedge clk) 
begin
  if (reset == 1)
  begin
    Xs[0] <= 0;
    Xs[1] <= 0;
    Xs[2] <= 0;
    Xs[3] <= 0;
    Xs[4] <= 0;
    Xs[5] <= 0;
    Xs[6] <= 0;
    Xs[7] <= 0;
    Y <= 0;
    count <= 0;
  end
  else
  begin
    Xs[count] <= X;
    if(count >= 7)
    begin
      count <= 0;
    end
    else
    begin
      count <= count + 1;
    end
    Y <= ((Xappr * 9) + Xall) >> 3;
    
  end 
end


always @(*)
begin

  Xall = ((((X + Xs[0]) + (Xs[1] + Xs[2])) + ((Xs[3] + Xs[4]) + (Xs[5] + Xs[6]))) + (Xs[7]));
  Xavgi = Xall / 9;
  Xappr = 0;
  Xdiff = Xavgi;

  if((X <= Xavgi) && (Xdiff > Xavgi - X))
    begin
      Xdiff = Xavgi - X;
      Xappr = X;
    end
  if((Xs[0] <= Xavgi) && (Xdiff > Xavgi - Xs[0]))
  begin
    Xdiff = Xavgi - Xs[0];
    Xappr = Xs[0];
  end
  if((Xs[1] <= Xavgi) && (Xdiff > Xavgi - Xs[1]))
  begin
    Xdiff = Xavgi - Xs[1];
    Xappr = Xs[1];
  end
  if((Xs[2] <= Xavgi) && (Xdiff > Xavgi - Xs[2]))
  begin
    Xdiff = Xavgi - Xs[2];
    Xappr = Xs[2];
  end
  if((Xs[3] <= Xavgi) && (Xdiff > Xavgi - Xs[3]))
  begin
    Xdiff = Xavgi - Xs[3];
    Xappr = Xs[3];
  end
  if((Xs[4] <= Xavgi) && (Xdiff > Xavgi - Xs[4]))
  begin
    Xdiff = Xavgi - Xs[4];
    Xappr = Xs[4];
  end
  if((Xs[5] <= Xavgi) && (Xdiff > Xavgi - Xs[5]))
  begin
    Xdiff = Xavgi - Xs[5];
    Xappr = Xs[5];
  end
  if((Xs[6] <= Xavgi) && (Xdiff > Xavgi - Xs[6]))
  begin
    Xdiff = Xavgi - Xs[6];
    Xappr = Xs[6];
  end
  if((Xs[7] <= Xavgi) && (Xdiff > Xavgi - Xs[7]))
  begin
    Xdiff = Xavgi - Xs[7];
    Xappr = Xs[7];
  end
end

endmodule