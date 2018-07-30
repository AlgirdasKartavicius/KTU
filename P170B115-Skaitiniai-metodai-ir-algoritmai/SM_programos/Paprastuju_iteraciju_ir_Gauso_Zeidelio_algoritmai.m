
% Paprastuju iteraciju ir Gauso-Zeidelio algoritmai

clc, clear all
A=[3  8  3  4;
   2  6  7  9;
   4  6  5  1;
   1  2 -6 -5]
b=[2;3;-2;-1]
n=size(A,1)
Aprad=A;


method='simple_iterations';
% % method='Gauss-Seidel_iterations';
alpha=[100; 100; 100; 100];  % laisvai parinkti metodo parametrai

Atld=diag(1./diag(A))*A-diag(alpha)
btld=diag(1./diag(A))*b

nitmax=1000;
eps=1e-12;
x=zeros(n,1);x1=zeros(n,1);
fprintf(1,'\n sprendimas iteracijomis:'); 
for it=1:nitmax
  if strcmp(method,'Gauss-Seidel_iterations')
    for i=1:n
        x1(i)=(btld(i)-Atld(i,:)*x1)/alpha(i);
    end
  elseif strcmp(method,'simple_iterations')
       x1=(btld-Atld*x)./alpha; 
  else, 
    'neaprasytas metodas', return,
  end
  prec(it)=norm(x1-x)/(norm(x)+norm(x1));
  fprintf(1,'iteracija Nr. %d,  tikslumas  %g\n',it,prec(it))
  if prec(it) < eps, break, end
  x=x1;
end
x
disp('patikrinimas')
Aprad*x-b

semilogy([1:length(prec)],prec,'r.');grid on,hold on
