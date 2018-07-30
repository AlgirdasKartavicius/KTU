
% QR-algoritmas (Hausholderio atspindziai)

clc
A=[1 1 1 1;
   1 -1 -1 1;
   2 1 -1 2;
   3 1 2 -1]
b=[2;0;9;7]
% b=[2 1;0  2;9 3;7 3]
n=size(A,1),  nb=size(b,2)
A1=[A,b]


z=A1(:,1);
zp=zeros(size(z));
zp(1)=sign(z(1))*norm(z);
zp

omega=(z-zp); omega=omega/norm(omega)
Q=eye(n)-2*omega*omega'
Q*A1


