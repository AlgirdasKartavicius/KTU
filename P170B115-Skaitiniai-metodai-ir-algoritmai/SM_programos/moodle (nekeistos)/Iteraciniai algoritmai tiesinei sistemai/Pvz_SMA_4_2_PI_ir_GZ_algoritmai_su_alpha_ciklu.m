
% Paprastuju iteraciju ir Gauso-Zeidelio algoritmai su alpha ciklu

clc, clear all
A=[ 1 -1  0  0;
   -1  2 -1  0;
   0  -1  2 -1;
   0   0 -1  2]
b=[2;0;0;0]
A=[
 5 11 7 0;
 2 6 17 2;
 2 1  5 1;
 4 12 1 7;
] % coefficient matrix
b=[50; 75; 30; 171] % right-hand side vector
A=[3  8  3  4;
   2  6  7  9;
   4  6  5  1;
   1  2 -6 -5]
b=[2;3;-2;-1]
n=size(A,1)
Aprad=A;


for alpha1=[-100,-10,1,10,100]
    for alpha2=[-100,-10,1,10,100]
        for alpha3=[-100,-10,1,10,100]
            for alpha4=[-100,-10,1,10,100]

method='simple_iterations';
method='Gauss-Seidel_iterations';
alpha=[alpha1; alpha2; alpha3; alpha4];  % laisvai parinktas metodo parametras
disp(alpha')

Atld=diag(1./diag(A))*A-diag(alpha);
btld=diag(1./diag(A))*b;

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
%   fprintf(1,'iteracija Nr. %d,  tikslumas  %g\n',it,prec(it))
  if prec(it) < eps, alpha,x,disp('patikrinimas'),Aprad*x-b, return, end
  x=x1;
end
'metodas diverguoja'

            end
        end
    end
end
semilogy([1:length(prec)],prec,'r.');grid on,hold on
