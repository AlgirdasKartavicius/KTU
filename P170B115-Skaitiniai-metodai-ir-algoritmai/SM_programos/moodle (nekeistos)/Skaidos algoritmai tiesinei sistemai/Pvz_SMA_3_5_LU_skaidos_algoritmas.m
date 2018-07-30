
% LU skaidos algoritmas

clc
A=[1 1 1 1;
   1 -1 -1 1;
   2 1 -1 2;
   3 1 2 -1]
b=[2;0;9;7]
n=size(A,1)
L=diag(ones(n,1))
U=zeros(n,n)


U(1,:)=A(1,:);
for i=1:n-1
    for j=i+1:n
        r=A(j,i)/A(i,i);
         
        U(j,i:n)=A(j,i:n)-A(i,i:n)*r;
        L(j,i)=r;        
        
        A(j,i+1:n)=A(j,i+1:n)-A(i,i+1:n)*r;  % gaunami "0" zemiau pagrindines istrizaines
        A(j,i)=r; % irasoma o gauto "0" vieta (prisimename, is kokio skaiciaus buvo padauginta vedanciojo elemento eilute)
       
    end
    A
end
U
L
L*U
