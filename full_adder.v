`timescale 1ns / 1ps



module full_adder
(
input a,b,cin,
output s,
output cout
);

assign s    = a^b^cin;
assign cout = (a&b)|(b&cin)|(cin&a);

endmodule
