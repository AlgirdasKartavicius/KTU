clc, clear all
A=[3  8  3  4;
   2  6  7  9;
   4  6  5  1;
   1  2 -6 -5]
b=[2;3;-2;-1]
n=size(A,1)
Aprad=A;

alpha=[-10; 1; 10; 10];  % laisvai parinkti metodo parametrai
Atld=diag(1./diag(A))*A-diag(alpha)
btld=diag(1./diag(A))*b

nitmax=1000;
eps=1e-12;
x=zeros(n,1);x1=zeros(n,1);
fprintf(1,'\n sprendimas iteracijomis:'); 
for it=1:nitmax
  x1=(btld-Atld*x)./alpha; 
  prec(it)=norm(x1-x)/(norm(x)+norm(x1));
  fprintf(1,'iteracija Nr. %d,  tikslumas  %g\n',it,prec(it))
  if prec(it) < eps, break, end
  x=x1;
end
x
disp('patikrinimas')
Aprad*x-b

semilogy([1:length(prec)],prec,'r.');grid on,hold on

