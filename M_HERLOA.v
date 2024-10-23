`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.09.2024 23:33:09
// Design Name: 
// Module Name: M_HERLOA
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

// Modified Hybrid Error Reduction Lower-part-Or-Adder
module M_HERLOA
#(parameter N=16,P=8,M=4) //N is the size of whole adder where N-P is the length of accurate adder
(
input  [N-1:0]X,Y, //Inputs X & Y of size N
output [N:0]SUM    //Sum of size N
);

wire cout;       //Final carry-out
wire [5:0]a;     //Intermediate wires used in MSB's of LOA 
wire [P-3:0]b;   //Intermediate wires used in LOA 
wire [N:P]c;     //Carry-in signals
wire [N-1:0]s;   //Sum of all bits of inputs

// Lower-part-adder
xor  xor1 (a[0],X[P-1],Y[P-1]);
and  and1 (a[1],X[P-2],Y[P-2]);
or   or1  (s[P-1],a[0],a[1]);
and  and2 (a[2],a[0],a[1]); //Generating signal from MSB's of LOA that will propogate to the rest of LOA
not  not1 (a[3],a[0]);
nand nand1(a[4],a[3],a[1]);
or   or2  (a[5],X[P-2],Y[P-2]);
and  and3 (s[P-2],a[4],a[5]);

// Carry input to the Accurate part of adder
and  andcin (c[P],X[P-1],Y[P-1]);

// Rest of the Lower-part-Or-Adder
generate
genvar G;
for(G=P-3;G>=M;G=G-1)
begin: LOA
or or_gen1(b[G],X[G],Y[G]);
or or_gen2(s[G],b[G],a[2]);
end
endgenerate

// Rest of the bits are set to 1
assign SUM[M-1:0]=4'b1111;
generate
genvar E;
for(E=M-1;E>=0;E=E-1)
begin: ALL_ONES
assign s[E]=1'b1;
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
