`timescale 1ns / 1ps



module mux
(
input I1,I0,sel,
output Y
);

assign Y = sel?I1:I0;

endmodule
