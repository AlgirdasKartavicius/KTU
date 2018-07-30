
% Lygciu sistemos sprendimas taikant LU skaida

clc
A=[1 1 1 1;
   1 -1 -1 1;
   2 1 -1 2;
   3 1 2 -1]

b=[2;0;9;7]
n=size(A,1)
Aold=A
% LU skaida

for i=1:n-1
    for j=i+1:n
        r=A(j,i)/A(i,i);
        A(j,i+1:n)=A(j,i+1:n)-A(i,i+1:n)*r;  % gaunami "0" zemiau pagrindines istrizaines
        A(j,i)=r; % irasoma o gauto "0" vieta (prisimename, is kokio skaiciaus buvo 
                  % padauginta i (t.y.vedanciojo elemento) eilute, pridedant ja prie kiekvienos j lygties)
    end
end

% 1-as atvirkstinis zingsnis, sprendziama  Ly=b, y->b

for i=2:n
    b(i,:)=b(i,:)-A(i,1:i-1)*b(1:i-1);
end

% 2-as atvirkstinis zingsnis   Ux=b,  x->b
 
for i=n:-1:1
    b(i)=(b(i)-A(i,i+1:n)*b(i+1:n))/A(i,i);
end

b
Aold*b

