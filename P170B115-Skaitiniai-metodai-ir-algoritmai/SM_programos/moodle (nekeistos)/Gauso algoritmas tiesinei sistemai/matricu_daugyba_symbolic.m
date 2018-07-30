
%    matricu daugyba

syms a11 a12 a13 a21 a22 a23 a31 a32 a33 x1 x2 b1 b2
syms d11 d12 d13 d21 d22 d23 d31 d32 d33
A=[a11 a12; a21 a22]
x=[x1;x2]
b=[b1;b2]
A*x

A1=[a11 a12 a13;a21 a22 a23]
D1=[d11 d12 d13;d21 d22 d23;d31 d32 d33]
A1*D1
D1*A1


