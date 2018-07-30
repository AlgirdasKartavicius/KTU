
% Choleckio skaidos algoritmo taikymas lygciu sistemos sprendimui

clc,clear all
% A=[ 1 -1  0  0;
%    -1  2 -1  0;
%    0  -1  2 -1;
%    0   0 -1  2]
% b=[2;0;0;0]

A=[3  8  3  4;
   2  6  7  9;
   4  6  5  1;
   1  2 -6 -5]
b=[2;3;-2;-1]
n=size(A,1)
Aprad=A;

% Choleckio L'*L skaida
for i=1:n
    A(i,i)=sqrt(A(i,i)-sum(A(1:i-1,i).^2));
    for j=i+1:n
        A(i,j)=(A(i,j)-A(1:i-1,i)'*A(1:i-1,j))/A(i,i);
    end
    A
end

% 1-as atvirkstinis zingsnis, sprendziama  L'y=b, y->b
for i=1:n
    b(i,:)=(b(i,:)-A(1:i-1,i)'*b(1:i-1))/A(i,i);
end
b

% 2-as atvirkstinis zingsnis   Ux=b,  x->b
for i=n:-1:1
    b(i)=(b(i)-A(i,i+1:n)*b(i+1:n))/A(i,i);
end

b
Aprad*b