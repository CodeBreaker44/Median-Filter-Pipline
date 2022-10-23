module eightToOneMUX(out, in1,sl1,sl2,sl3);
output out;
input[0:7] in1;
input sl1,sl2,sl3;
reg out;

always @(sl1 or sl2 or sl3)
begin

case ({sl1,sl2,sl3})
3'b000 : out =in1[0]; 
3'b001 : out =in1[1]; 
3'b010 : out =in1[2];
3'b011 : out =in1[3];

3'b100 : out =in1[4]; 
3'b101 : out =in1[5]; 
3'b110 : out =in1[6];
3'b111 : out =in1[7];

endcase
end
endmodule

//-----------------------------------------

module m21( D0, D1, S, Y);
input D0, D1, S;
output reg Y;

always @(*)
begin

if(S) 
Y= D1;
else
Y=D0;

end
endmodule

//--------------------------------------------

module mainComparator(in1,in2,CO);
input [0:7]in1;
input [0:7]in2;
output CO;

wire w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12w,w13,w14,w15,w16,w17,w18,w19,w20,w21,w22,w23,w24,w25;
//mux<1>----------------------
or loki(w1,in1[0],~in2[0]);

and odin(w2,in1[1],~in2[1]);

or thor(w3,in1[1],~in2[1]);

m21 M1(w3,w2,w1,w4);

//mux<2> & mux<3>----------------------
and mimir(w5,in1[2],~in2[2]);
or magni(w6,in1[2],~in2[2]);//selection mux<3>
or modi(w7,in1[3],~in2[3]);
and hela(w8,in1[3],~in2[3]);

m21 M2(w7,w8,w5,w9);
m21 M3(w7,w8,w6,w10);

//mux<4> & mux<5>------------------------
and brok(w11,in1[4],~in2[4]);//selection mux<4>
or sindri(w12,in1[4],~in2[4]);//selction mux<5>
or bualder(w13,in1[5],~in2[5]);
and surtr(w14,in1[5],~in2[5]);

m21 M4(w13,w14,w11,w15);
m21 M5(w13,w14,w12,w16);

//mux<6> & mux<7>-------------------------
and frigg(w17,in1[6],~in2[6]);//selction mux<6>
or  freya(w18,in1[6],~in2[6]);//selection mux<7>
or  freyr(w19,in1[7],~in2[7]);
and tyr(w20,in1[7],~in2[7]);

m21 M6(w19,w20,w17,w21);
m21 M7(w19,w20,w18,w22);


//mux<8>------------------------------------
m21 M8(w10,w9,w4,w23);

//mux<9>------------------------------------
m21 M9(w22,w21,w15,w24);

//mux<10>-----------------------------------
m21 M10(w22,w21,w16,w25);
//mux<11> Output (CO)-----------------------
m21 M11(w25,w24,w23,CO);

endmodule
//----------------------------------------------

module cs(A,B,C,maxz,midz,minz);
input [0:7]A;
input [0:7]B;
input [0:7]C;


wire [0:7]y;
assign y = A|B|C;

output [0:7]maxz,minz,midz;

wire CO1,CO2,CO3;
wire maxy,midy,miny;

mainComparator A_B(A,B,CO1);
mainComparator A_C(A,C,CO2);
mainComparator B_C(B,C,CO3);

eightToOneMUX ty(maxy,y,CO1,CO2,CO3);
eightToOneMUX tz(midy,y,CO1,CO2,CO3);
eightToOneMUX tx(miny,y,CO1,CO2,CO3);

assign maxz = { {8{maxy}}, maxy};
assign minz = { {8{miny}}, miny};
assign midz = { {8{midy}}, midy};

endmodule

//----------------------------------------------------------

module medianFilter(P1,P2,P3,P4,P5,P6,P7,P8,P9,Median);
input [0:7]P1,P2,P3,P4,P5,P6,P7,P8,P9;
output [0:7]Median;


wire [0:7]D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12,D13,D14,D15,D16,D17,D18,D19,D20,D21;

cs cs1(P1,P2,P3,D1,D2,D3);
cs cs2(P4,P5,P6,D4,D5,D6);
cs cs3(P7,P8,P9,D7,D8,D9);
cs cs4(D1,D4,D7,D10,D11,D12);
cs cs5(D2,D5,D8,D13,D14,D15);
cs cs6(D3,D6,D9,D16,D17,D18);
cs cs7(D12,D14,D16,D19,Median,D21);

endmodule

//--------------------------------------------
module medianFilterPipeline(out,A,B,C,clk1);
output[0:31] out;
input [0:7]A;
input [0:7]B;
input [0:7]C;
reg [0:31] out;

input clk1;

reg [0:23]IF_reg;
reg [0:95]ID_EX_reg;
reg [0:31]M_reg;


always @ (posedge clk1)//stage 1 (IF Stage)
begin

IF_reg[0:7]   <= #8 A [0:7];
IF_reg[8:15]  <= #8 B [0:7];
IF_reg[16:23] <= #8 C [0:7];
end

wire [0:7]D1,D2,D3,D4,D5,D6,D7,D8,D9,D10,D11,D12;

cs cs1(IF_reg[0:7],IF_reg[8:15],IF_reg[16:23],D1,D2,D3);
cs cs2(IF_reg[0:7],IF_reg[8:15],IF_reg[16:23],D4,D5,D6);
cs cs3(IF_reg[0:7],IF_reg[8:15],IF_reg[16:23],D7,D8,D9);
cs cs4(IF_reg[0:7],IF_reg[8:15],IF_reg[16:23],D10,D11,D12);


always @ (posedge clk1) //Stgae 2 (ID/Ex) satge
begin

ID_EX_reg[0:7]   <= D1;
ID_EX_reg[8:15]  <= D2;
ID_EX_reg[16:23] <= D3;
ID_EX_reg[24:31] <= D4;
ID_EX_reg[32:39] <= D5;
ID_EX_reg[40:47] <= D6;
ID_EX_reg[48:55] <= D7;
ID_EX_reg[56:63] <= D8;
ID_EX_reg[64:71] <= D9;
ID_EX_reg[72:79] <= D10;
ID_EX_reg[80:87] <= D11;
ID_EX_reg[88:95] <= D12;
end

wire [0:7]op1,op2,op3,op4;

medianFilter M1 (ID_EX_reg[0:7],ID_EX_reg[8:15],ID_EX_reg[16:23],ID_EX_reg[24:31],ID_EX_reg[32:39],ID_EX_reg[40:47],ID_EX_reg[24:31],ID_EX_reg[32:39],ID_EX_reg[40:47],op1);

medianFilter M2(ID_EX_reg[48:55],ID_EX_reg[56:63],ID_EX_reg[64:71],ID_EX_reg[72:79],ID_EX_reg[80:87],ID_EX_reg[88:95],ID_EX_reg[72:79],ID_EX_reg[80:87],ID_EX_reg[88:95],op2);

medianFilter M3(ID_EX_reg[0:7],ID_EX_reg[8:15],ID_EX_reg[16:23],ID_EX_reg[0:7],ID_EX_reg[8:15],ID_EX_reg[16:23],ID_EX_reg[24:31],ID_EX_reg[32:39],ID_EX_reg[40:47],op3);

medianFilter M4(ID_EX_reg[48:55],ID_EX_reg[56:63],ID_EX_reg[64:71],ID_EX_reg[48:55],ID_EX_reg[56:63],ID_EX_reg[64:71],ID_EX_reg[72:79],ID_EX_reg[80:87],ID_EX_reg[88:95],op4);

always @ (posedge clk1)
begin 

M_reg[0:7] <= op1;
M_reg[8:15] <= op2;
M_reg[16:23] <= op3;
M_reg[24:31] <= op4;
out[0:7] <= M_reg[0:7];
out[8:15] <= M_reg[7:15];
out[16:23] <= M_reg[16:23];
out[24:31] <= M_reg[24:31];

 
end
endmodule



module stage1Test;//(IF Stage).

reg [0:7]A_t,B_t,C_t;


initial

begin


A_t <= 8'b10010010;
B_t <= 8'b01010100;
C_t <= 8'b11100000;

#1 $display("IF Stage :");
#1 $display ("A = %b ",A_t, "B = %b ",B_t, "C_t = %b ",C_t);
 
end
endmodule



module stage2Test;// (ID/EX Stage).

reg [0:7]A_t,B_t,C_t;
wire [0:7]Dt1,Dt2,Dt3,Dt4,Dt5,Dt6,Dt7,Dt8,Dt9,Dt10,Dt11,Dt12;

initial

begin


A_t <= 8'b10010010;
B_t <= 8'b01010100;
C_t <= 8'b11100000;

end

cs test1(A_t,B_t,C_t,Dt1,Dt2,Dt3);
cs test2(A_t,B_t,C_t,Dt4,Dt5,Dt6);
cs test3(A_t,B_t,C_t,Dt7,Dt8,Dt9);
cs test4(A_t,B_t,C_t,Dt10,Dt11,Dt12);

initial

begin

#5 $display("ID/EX Stage : ");
#1 $display("D1 = %b ", Dt1 , "D2 = %b ", Dt2, "D3 = %b ", Dt3);
#1 $display("D4 = %b ", Dt4 , "D5 = %b ", Dt5, "D6 = %b ", Dt6);
#1 $display("D7 = %b ", Dt7 , "D8 = %b ", Dt8, "D9 = %b ", Dt9);
#1 $display("D10 = %b ", Dt10 , "D11 = %b ", Dt11,"D12 = %b ", Dt12);

end

endmodule


module Stage3Test;//(M Stage)
reg [0:7]Dt1,Dt2,Dt3,Dt4,Dt5,Dt6,Dt7,Dt8,Dt9,Dt10,Dt11,Dt12;

wire [0:7]op1,op2,op3,op4;

initial

begin
Dt1  <= 8'b10101001;
Dt2  <= 8'b00100011;
Dt3  <= 8'b11101110;
Dt4  <= 8'b11101000;
Dt5  <= 8'b00101000;
Dt6  <= 8'b11111111;
Dt7  <= 8'b00000100;
Dt8  <= 8'b00111001;
Dt9  <= 8'b00111000;
Dt10 <= 8'b11100111;
Dt11 <= 8'b10100010;
Dt12 <= 8'b11001111;
end

medianFilter test1(Dt1,Dt2,Dt3,Dt4,Dt5,Dt6,Dt4,Dt5,Dt6,op1);
medianFilter test2(Dt7,Dt8,Dt9,Dt10,Dt11,Dt12,Dt10,Dt11,Dt12,op2);
medianFilter test3(Dt1,Dt2,Dt3,Dt1,Dt2,Dt3,Dt4,Dt5,Dt6,op3);
medianFilter test4(Dt7,Dt8,Dt9,Dt7,Dt8,Dt9,Dt10,Dt11,Dt12,op4);


initial

begin

#15 $display("M Satge : ");
#1 $display("op1 = %b ",op1,"op2 = %b ",op2,"op3 = %b ",op3,"op4 = %b",op4);
end


endmodule

//--------------------------------------
module fullPipelineTest;

wire [0:31]out_t;
reg [0:7]A_t,B_t,C_t;
reg clk=0;

initial

begin


A_t <= 8'b10010010;
B_t <= 8'b01010100;
C_t <= 8'b11100000;
#1 clk = ~clk;
end 



medianFilterPipeline test1(out_t,A_t,B_t,C_t,clk);

initial

begin
  //$dumpfile("dump.vcd"); $dumpvars;

#25 $display("Full Pipeline result : ");
#1 $display("A_t = %b ", A_t, "B_t = %b ",B_t,"C_t = %b", C_t);
#1 $display("Out = %b ",out_t);
  //$finish;
end

endmodule