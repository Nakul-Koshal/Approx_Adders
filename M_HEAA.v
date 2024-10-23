`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2024 00:55:20
// Design Name: 
// Module Name: M_HEAA
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Modified Hardware Efficient Approximate Adder
module M_HEAA
#(parameter N=16,P=8) //N is the size of whole adder where N-P is the length of accurate adder
(
input  [N-1:0]X,Y, //Inputs X & Y of size N
output [N:0]SUM    //Sum of size N
);

wire cout;     //Final carry-out
wire I0;       //Mux i/p wire
wire [N:P]c;   //Carry-in signals
wire [N-1:0]s; //Sum of all bits of inputs

// Carry input to the Accurate-part-adder
and and2(c[P],X[P-1],Y[P-1]);

// Inaccurate-part-adder
or  or1(I0,X[P-1],Y[P-1]);
or  or2(s[P-2],X[P-2],Y[P-2]);
mux mux1(.I1(1'b0),.I0(I0),.sel(c[P]),.Y(s[P-1]));

// Rest of the bits are set to 1
generate
genvar G;
for(G=P-3;G>=0;G=G-1)
begin: ALL_ONES
assign s[G]=1'b1;
end
endgenerate

// Accurate-part-adder
assign cout=c[N];
generate
genvar U;
for(U=P;U<N;U=U+1)
begin: ACCURATE
full_adder inst(.a(X[U]),.b(Y[U]),.cin(c[U]),.s(s[U]),.cout(c[U+1]));
end
endgenerate

// Final sum
assign SUM={cout,s};

endmodule

