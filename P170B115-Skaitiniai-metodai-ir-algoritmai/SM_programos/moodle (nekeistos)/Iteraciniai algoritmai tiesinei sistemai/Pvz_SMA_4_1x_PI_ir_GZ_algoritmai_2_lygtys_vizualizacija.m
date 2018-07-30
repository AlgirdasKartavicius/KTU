
% Paprastuju iteraciju ir Gauso-Zeidelio algoritmai
% vizualizacija 2 lygciu atveju

clc, clear all, close all
A=[ 1 -1 ;
   -1  2]
b=[2;0.5]
% A=[ 5 11; 
%  2 6 ] % coefficient matrix
% b=[50; 75] % right-hand side vector
n=size(A,1)
Aprad=A;

% grafinis pavaizdavimas:
fh=figure(1);  set(fh,'Color',[1 1 1])
for iii=1:2
    subplot(1,2,iii);hold on; grid on
    range=[-1 1 -1 1 -1 1]*5;axis equal; axis(range);  view([1 -0.5 1]);
    xlabel('x1');ylabel('x2');zlabel('f');
end

   

% method='simple_iterations';
method='Gauss-Seidel_iterations';
alpha=[1; 1];  % laisvai parinkti metodo parametrai

Atld=diag(1./diag(A))*A-diag(alpha)
btld=diag(1./diag(A))*b

% lygciu plokstumos: -------------
rr1=[1 2 2 1];rr2=[3 3 4 4];
zz=[btld,btld,btld,btld]-Atld*[range(rr1);range(rr2)];
subplot(1,2,1);
fill3(range(rr1),range(rr2),zz(1,:),   [0.5 0.5 1],'FaceAlpha',0.5);
fill3(range(rr1),range(rr2),range(rr1),[0.5 0.5 1],'FaceAlpha',0.2);
fill3(range(rr1),range(rr2),zeros(1,4),[0.5 1 0.5],'FaceAlpha',0.1);
subplot(1,2,2);
fill3(range(rr1),range(rr2),zz(2,:),   [1 0.5 0.5],'FaceAlpha',0.5);
fill3(range(rr1),range(rr2),range(rr2),[1 0.5 0.5],'FaceAlpha',0.2);
fill3(range(rr1),range(rr2),zeros(1,4),[0.5 1 0.5],'FaceAlpha',0.1);

% -----------------

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
  
      pp=x1;
    for iii=1:2
        subplot(1,2,iii);
        plot3([x(1),x(1)],[x(2),x(2)],[0,pp(1)],'-.b');
        plot3([x(1) ,pp(1)],[x(2) ,x(2)],[pp(1),pp(1)],'-b');plot3([pp(1)],[x(2)],[pp(1)],'*b');
        plot3([pp(1),pp(1)],[x(2),pp(2)],[pp(1),pp(1)],'-b');
        plot3([x(1),x(1)],[x(2),x(2)],[0,pp(2)],'-.r');
        plot3([x(1),x(1)],[x(2),pp(2)],[pp(2),pp(2)],'-r');plot3([x(1)],[pp(2)],[pp(2)],'*r');
        plot3([x(1),pp(1)],[pp(2),pp(2)],[pp(2),pp(2)],'-r');
        plot3(x(1),x(2),0,'pg');  
    end
pause 
  
  prec(it)=norm(x1-x)/(norm(x)+norm(x1));
  fprintf(1,'iteracija Nr. %d,  tikslumas  %g\n',it,prec(it))
  if prec(it) < eps, break, end
  x=x1;
end
x
disp('patikrinimas')
Aprad*x-b
figure(2);semilogy([1:length(prec)],prec,'r.');grid on,hold on
