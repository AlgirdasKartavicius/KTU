% Niutono-Koteso formules: tyrimas

function main
clc,clear all,close all

syms f x
% Integruojama funkcija
% f=sin(2*x-2)+1
f=sin(2*x)+sqrt(abs(x))+0.5;
a=-1;b=1; % intervalas
nnn=1000;xxx=[a:(b-a)/(nnn-1):b]; % vaizdavimo tasku skaicius ir abscises
n=15;
dX=(b-a)/(n-1); X=[a:dX:b]; % integravimo tasku skaicius ir abscises
N=8  % formules tasku skaicius

if floor((n-1)/(N-1))~=(n-1)/(N-1), fprintf(1,'Formuleje intervalu skaicius turi buti kartotinis %d',N-1), return,end 

F=eval(subs(f,x,sym(X)));

format long
Integralas=Newton_Cotes(F,a,b,N)

figure(1),hold on, grid on, plot(xxx,eval(subs(f,x,sym(xxx))), 'Linewidth',2);

Integr_tikslus=eval(int(f,a,b))

% Braizome interpoliuojancias funkcijas intervaluose, pagal kuriuos skaiciavome integrala:
for i=1:N-1:n-N+1
    am=a+(i-1)*dX;bm=a+(i+N-2)*dX; % intervalas
    mmm=100;sss=[am:(bm-am)/(mmm-1):bm]; % vaizdavimo tasku skaicius ir abscises 
    yyy=0;
    for j=1:N % Lagranzo interpoliavimas
        L=Lagrange(X(i:i+N-1),j,sss); yyy=yyy+L*F(i+j-1);
    end
    plot(sss,yyy,'r-'), plot(X,F,'r*'), plot([sss(1),sss(1)],[0,yyy(1)],'r-'),plot([sss(end),sss(end)],[0,yyy(end)],'r-')
end


return,end

function Integralas=Newton_Cotes(fff,a,b,N)
n=length(fff);

% Nustatome skaitinio integravmo koeficientus:
switch N 
    case 1, 'turi buti N > 2',
    case 2, coef=[ 1/2, 1/2]
    case 3, coef=[ 1/3, 4/3, 1/3]
    case 4, coef=[ 3/8, 9/8, 9/8, 3/8]
    case 5, coef=[ 14/45, 64/45, 8/15, 64/45, 14/45]
    case 6, coef=[ 95/288, 125/96, 125/144, 125/144, 125/96, 95/288]
    case 7, coef=[ 41/140, 54/35, 27/140, 68/35, 27/140, 54/35, 41/140]
    case 8, coef=[ 5257/17280, 25039/17280, 343/640, 20923/17280, 20923/17280, 343/640, 25039/17280, 5257/17280]
    case 9, coef=[ 3956/14175, 23552/14175, -3712/14175, 41984/14175, -3632/2835, 41984/14175, -3712/14175, 23552/14175, 3956/14175]
    otherwise, coef=[]
end

if floor((n-1)/(N-1))~=(n-1)/(N-1), fprintf(1,'Formuleje intervalu skaicius turi buti kartotinis %d',N-1), return,end

% Apskaiciuojame integrala
Integralas=0;
for i=1:N, i:N-1:n-N+i,Integralas=Integralas+coef(i)*sum(fff(i:N-1:n-N+i));  end
Integralas=Integralas*(b-a)/(n-1);

return,end

function L=Lagrange(X,j,x)
    n=length(X);L=1;
    for k=1:n, if k ~= j, L=L.*(x-X(k))/(X(j)-X(k)); end, end
return, end

