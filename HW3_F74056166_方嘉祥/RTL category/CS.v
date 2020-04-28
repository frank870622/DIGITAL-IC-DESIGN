`timescale 1ns/10ps
module CS(Y, X, reset, clk);

input clk, reset; 
input  [7:0] X;
output 	reg [9:0] Y;

integer i;
reg [4:0]count;

reg [9:0] Xs[7:0];
wire [9:0] Xavgi;
wire [9:0] diff[8:0];

assign Xavgi = ((((X + Xs[0]) + (Xs[1] + Xs[2])) + ((Xs[3] + Xs[4]) + (Xs[5] + Xs[6]))) + (Xs[7]))/9;
assign diff[0] = (X > Xavgi)? X:Xavgi - X;
assign diff[1] = (Xs[0] > Xavgi)? Xs[0]:Xavgi - Xs[0];
assign diff[2] = (Xs[1] > Xavgi)? Xs[1]:Xavgi - Xs[1];
assign diff[3] = (Xs[2] > Xavgi)? Xs[2]:Xavgi - Xs[2];
assign diff[4] = (Xs[3] > Xavgi)? Xs[3]:Xavgi - Xs[3];
assign diff[5] = (Xs[4] > Xavgi)? Xs[4]:Xavgi - Xs[4];
assign diff[6] = (Xs[5] > Xavgi)? Xs[5]:Xavgi - Xs[5];
assign diff[7] = (Xs[6] > Xavgi)? Xs[6]:Xavgi - Xs[6];
assign diff[8] = (Xs[7] > Xavgi)? Xs[7]:Xavgi - Xs[7];


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

    if((((diff[0] <= diff[1]) && (diff[0] <= diff[2])) && ((diff[0] <= diff[3]) && (diff[0] <= diff[4]))) &&
      (((diff[0] <= diff[5]) && (diff[0] <= diff[6])) && ((diff[0] <= diff[7]) && (diff[0] <= diff[8]))))
    begin
      Y <= (((((X + X) + (Xs[0] + X)) + ((Xs[1] + X) + (Xs[2] + X))) + (((Xs[3] + X) + (Xs[4] + X)) +
        ((Xs[5] + X) + (Xs[6] + X)))) + (Xs[7] + X)) / 8;
    end
    else if((((diff[1] <= diff[0]) && (diff[1] <= diff[2])) && ((diff[1] <= diff[3]) && (diff[1] <= diff[4]))) &&
            (((diff[1] <= diff[5]) && (diff[1] <= diff[6])) && ((diff[1] <= diff[7]) && (diff[1] <= diff[8]))))
    begin
      Y <= (((((X + Xs[0]) + (Xs[0] + Xs[0])) + ((Xs[1] + Xs[0]) + (Xs[2] + Xs[0]))) + (((Xs[3] + Xs[0]) + (Xs[4] + Xs[0])) +
        ((Xs[5] + Xs[0]) + (Xs[6] + Xs[0])))) + (Xs[7] + Xs[0])) / 8;
    end
    else if((((diff[2] <= diff[0]) && (diff[2] <= diff[1])) && ((diff[2] <= diff[3]) && (diff[2] <= diff[4]))) &&
            (((diff[2] <= diff[5]) && (diff[2] <= diff[6])) && ((diff[2] <= diff[7]) && (diff[2] <= diff[8]))))
    begin
      Y <= (((((X + Xs[1]) + (Xs[0] + Xs[1])) + ((Xs[1] + Xs[1]) + (Xs[2] + Xs[1]))) + (((Xs[3] + Xs[1]) + (Xs[4] + Xs[1])) +
        ((Xs[5] + Xs[1]) + (Xs[6] + Xs[1])))) + (Xs[7] + Xs[1])) / 8;
    end
    else if((((diff[3] <= diff[0]) && (diff[3] <= diff[1])) && ((diff[3] <= diff[2]) && (diff[3] <= diff[4]))) &&
            (((diff[3] <= diff[5]) && (diff[3] <= diff[6])) && ((diff[3] <= diff[7]) && (diff[3] <= diff[8]))))
    begin
      Y <= (((((X + Xs[2]) + (Xs[0] + Xs[2])) + ((Xs[1] + Xs[2]) + (Xs[2] + Xs[2]))) + (((Xs[3] + Xs[2]) + (Xs[4] + Xs[2])) +
        ((Xs[5] + Xs[2]) + (Xs[6] + Xs[2])))) + (Xs[7] + Xs[2])) / 8;
    end
    else if((((diff[4] <= diff[0]) && (diff[4] <= diff[1])) && ((diff[4] <= diff[2]) && (diff[4] <= diff[3]))) &&
            (((diff[4] <= diff[5]) && (diff[4] <= diff[6])) && ((diff[4] <= diff[7]) && (diff[4] <= diff[8]))))
    begin
      Y <= (((((X + Xs[3]) + (Xs[0] + Xs[3])) + ((Xs[1] + Xs[3]) + (Xs[2] + Xs[3]))) + (((Xs[3] + Xs[3]) + (Xs[4] + Xs[3])) +
        ((Xs[5] + Xs[3]) + (Xs[6] + Xs[3])))) + (Xs[7] + Xs[3])) / 8;
    end
    else if((((diff[5] <= diff[0]) && (diff[5] <= diff[1])) && ((diff[5] <= diff[2]) && (diff[5] <= diff[3]))) &&
            (((diff[5] <= diff[4]) && (diff[5] <= diff[6])) && ((diff[5] <= diff[7]) && (diff[5] <= diff[8]))))
    begin
      Y <= (((((X + Xs[4]) + (Xs[0] + Xs[4])) + ((Xs[1] + Xs[4]) + (Xs[2] + Xs[4]))) + (((Xs[3] + Xs[4]) + (Xs[4] + Xs[4])) +
        ((Xs[5] + Xs[4]) + (Xs[6] + Xs[4])))) + (Xs[7] + Xs[4])) / 8;
    end
    else if((((diff[6] <= diff[0]) && (diff[6] <= diff[1])) && ((diff[6] <= diff[2]) && (diff[6] <= diff[3]))) &&
            (((diff[6] <= diff[4]) && (diff[6] <= diff[5])) && ((diff[6] <= diff[7]) && (diff[6] <= diff[8]))))
    begin
      Y <= (((((X + Xs[5]) + (Xs[0] + Xs[5])) + ((Xs[1] + Xs[5]) + (Xs[2] + Xs[5]))) + (((Xs[3] + Xs[5]) + (Xs[4] + Xs[5])) +
        ((Xs[5] + Xs[5]) + (Xs[6] + Xs[5])))) + (Xs[7] + Xs[5])) / 8;
    end
    else if((((diff[7] <= diff[0]) && (diff[7] <= diff[1])) && ((diff[7] <= diff[2]) && (diff[7] <= diff[3]))) &&
            (((diff[7] <= diff[4]) && (diff[7] <= diff[5])) && ((diff[7] <= diff[6]) && (diff[7] <= diff[8]))))
    begin
      Y <= (((((X + Xs[6]) + (Xs[0] + Xs[6])) + ((Xs[1] + Xs[6]) + (Xs[2] + Xs[6]))) + (((Xs[3] + Xs[6]) + (Xs[4] + Xs[6])) +
        ((Xs[5] + Xs[6]) + (Xs[6] + Xs[6])))) + (Xs[7] + Xs[6])) / 8;
    end
    else
    begin
      Y <= (((((X + Xs[7]) + (Xs[0] + Xs[7])) + ((Xs[1] + Xs[7]) + (Xs[2] + Xs[7]))) + (((Xs[3] + Xs[7]) + (Xs[4] + Xs[7])) +
        ((Xs[5] + Xs[7]) + (Xs[6] + Xs[7])))) + (Xs[7] + Xs[7])) / 8;
    end
  end 
end
//--------------------------------------
//  \^o^/   Write your code here~  \^o^/
//--------------------------------------
/*
always @(posedge clk)
begin
  Xavgi = ((((X + Xs[0]) + (Xs[1] + Xs[2])) + ((Xs[3] + Xs[4]) + (Xs[5] + Xs[6]))) + (X))/9;

  diff[0] = (X > Xavgi)? X:Xavgi - X;
  for(i=1; i<9; i=i+1)
  begin
    diff[i] = (Xs[i-1] > Xavgi)? Xs[i-1]:Xavgi - Xs[i-1];
  end
  
end



*/
endmodule