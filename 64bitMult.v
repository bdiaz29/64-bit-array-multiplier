`timescale 1ns / 1ps
//boolean expression full adder 
//S=a^b^cin
//cou=(a&b)|(b|cin)|(cin&a);
module bit64Mult(input [63:0] A,B,output reg [127:0] out,input clk);
integer i,j;
integer q,w,e,r;

//reg for and outputs
reg [0:0] nd [0:63][0:63];
reg [0:0] s [0:62][0:63];
reg [0:0] cin [0:63][0:63];
reg [0:0] cout [0:63][0:63];


always@(*)
begin
//assign the ANDs

for (j=0;j < 64; j = j + 1) 
begin
    for(i =0;i < 64; i = i + 1) 
        begin
            nd[i][j]=A[i]&B[j];
            end
        end

out[0]=nd[0][0];        
        
        //first layer
for(q=0;q<63;q=q+1)
begin
s[q][0]=nd[q+1][0]^nd[q][1]^0;
cout[q][0]=(nd[q+1][0]&nd[q][1])|(nd[q][1]&0)|(0&nd[q+1][0]);
end
out[1]=s[0][0];


//middle layer 
for (w =1;w < 63; w = w + 1) 
begin
    for(e =0;e < 63; e = e + 1)  
            begin
            if(e==62)
            begin
            s[e][w]=nd[e][w+1]^nd[e+1][w]^cout[e][w-1];
            cout[e][w]=(nd[e][w+1]&nd[e+1][w])|(nd[e+1][w]&cout[e][w-1])|(cout[e][w-1]&nd[e][w+1]);
            end
            else
            begin
            s[e][w]=nd[e][w+1]^s[e+1][w-1]^cout[e][w-1];
            cout[e][w]=(nd[e][w+1]&s[e+1][w-1])|(s[e+1][w-1]&cout[e][w-1])|(cout[e][w-1]&nd[e][w+1]);
            end
            if(e==0)
                begin
                out[w+1]=s[e][w];
                 end 
            end        
end

//right corner
s[0][63]=cout[0][62]^s[1][62]^0;
cout[0][63]=(cout[0][62]&s[1][62])|(s[1][62]&0)|(0&cout[0][62]);
out[64]=s[0][63];

//last layer
for(r=1;r<63;r=r+1)
begin
s[r][63]=s[r+1][62]^cout[r][62]^cout[r-1][63];
cout[r][63]=(s[r+1][62]&cout[r][62])|(cout[r][62]&cout[r-1][63])|(cout[r-1][63]&s[r+1][62]);
out[r+64]=s[r][63];
end

s[62][63]=nd[62][63]^cout[61][63]^cout[61][63];
cout[62][63]=(nd[62][63]&cout[61][63])|(cout[61][63]|cout[61][63])|(cout[61][63]&nd[62][63]);

out[126]=s[62][63];
out[127]=cout[62][63];
end
endmodule 