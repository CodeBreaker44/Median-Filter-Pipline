module eightToOneMUXTest;
wire out_t;
reg [0:7] in_t;
reg sl1_t,sl2_t,sl3_t;


eightToOneMUX loki(out_t,in_t,sl1_t,sl2_t,sl3_t);
initial
begin

sl1_t <= 0;
sl2_t <= 0;
sl3_t <= 0;
in_t <=  8'b11010101;

#1 $display ("input = %b ", in_t, "Output = %b ",out_t);
end
endmodule

//-----------------------------------------

module m21Test;
reg D0_t,D1_t,s_t;
wire y_t;

m21 thor(D0_t,D1_t,s_t,y_t);

initial
begin

D0_t <= 0;
D1_t <= 1;
s_t  <= 0;

#1 $display("Input = %b ", D0_t,D1_t, "Output = %b ", y_t);

end
endmodule

//-------------------------------------------

module mainComparatorTest;
reg [0:7]in1_t,in2_t;
wire CO_t;

mainComparator Odin(in1_t,in2_t,CO_t);

initial
begin

in1_t <= 8'b00110010;
in2_t <= 8'b11100110;

#1 $display("Input1 = %b ", in1_t, "Input2 = %b ", in2_t, "CO = %b ", CO_t);

end
endmodule

//-------------------------------------------

module csTest;
reg [0:7]A_t,B_t,C_t;
wire [0:7]max_t,min_t,mid_t;

cs mimir(A_t,B_t,C_t,max_t,min_t,mid_t);

initial
begin

A_t <= 8'b11110000;
B_t <= 8'b00100101;
C_t <= 8'b10010110;

#1 $display("max_t = %b ",max_t, "mid_t = %b ",mid_t,"min_t = %b ",min_t);


end
endmodule

//--------------------------------------------

module medianFilterTest;
reg [0:7]t1,t2,t3,t4,t5,t6,t7,t8,t9;
wire [0:7]median_t;


medianFilter Hela(t1,t2,t3,t4,t5,t6,t7,t8,t9,median_t);
initial
begin
t1 <= 8'b10101000;
t2 <= 8'b11000100;
t3 <= 8'b11001110;
t4 <= 8'b11110000;
t5 <= 8'b11101110;
t6 <= 8'b11100110;
t7 <= 8'b11011001;
t8 <= 8'b11100101;
t9 <= 8'b00010001;

#1 $display("Medain = %b ", median_t);

end
endmodule
