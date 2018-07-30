% Skaitinio diferencijavimo formules: tyrimas cikle

function main
clc,clear all,close all

global F X
syms F X
F=sin(2*X-2)+cos(5*X)+1;
% F=sin(X)
%  F=sin(2*X)+sqrt(abs(X-0.1))+0.5;

DF=diff(F,X)

a=-5;b=5; nnn=25 % intervalas
dx=(b-a)/(nnn-1);
nnn=1000;xxx=[a:dx:b]; % vaizdavimo tasku skaicius ir abscises

maxN=9

N=5  % formules tasku skaicius    
figure(5),hold on, grid on, plot(xxx,eval(subs(F,X,sym(xxx))),'b-*');

fff=eval(subs(F,X,sym(xxx)));
[DFnum,ww]=Diferencijavimas(fff,N);
DFnum=DFnum/((N-1)*dx)

plot(xxx,DFnum,'r-*','Linewidth',2);title(sprintf('N=%d',5));
plot(xxx,eval(subs(DF,X,sym(xxx))),'g-')
legend('duota funkcija','diferencijuota skaitiskai','diferencijuota analitiskai')

return,end
% 
function [Isvestine,ww]=Diferencijavimas(f,N)
% Nustatome diferencijavimo koeficientus:
switch N 
    case 3, ww=[-3, 4, -1;
                -1, 0, 1;
                 1, -4, 3];
    case 5, ww=[-25/3, 16, -12, 16/3, -1;
                 -1, -10/3, 6, -2, 1/3;
            1/3, -8/3, 0, 8/3, -1/3;
            -1/3, 2, -6, 10/3, 1;
            1, -16/3, 12, -16, 25/3];
    case 7, ww=[-147/10, 36, -45, 40, -45/2, 36/5, -1;
            -1, -77/10, 15, -10, 5, -3/2, 1/5;
            1/5, -12/5, -7/2, 8, -3, 4/5, -1/10;
            -1/10, 9/10, -9/2, 0, 9/2, -9/10, 1/10;
            1/10, -4/5, 3, -8, 7/2, 12/5, -1/5;
            -1/5, 3/2, -5, 10, -15, 77/10, 1;
            1, -36/5, 45/2, -40, 45, -36, 147/10];
    case 9, ww=[-761/35, 64, -112, 448/3, -140, 448/5, -112/3, 64/7, -1;
            -1, -446/35, 28, -28, 70/3, -14, 28/5, -4/3, 1/7;
            1/7, -16/7, -38/5, 16, -10, 16/3, -2, 16/35, -1/21;
            -1/21, 4/7, -4, -18/5, 10, -4, 4/3, -2/7, 1/35;
            1/35, -32/105, 8/5, -32/5, 0, 32/5, -8/5, 32/105, -1/35;
            -1/35, 2/7, -4/3, 4, -10, 18/5, 4, -4/7, 1/21;
            1/21, -16/35, 2, -16/3, 10, -16, 38/5, 16/7, -1/7;
            -1/7, 4/3, -28/5, 14, -70/3, 28, -28, 446/35, 1;
            1, -64/7, 112/3, -448/5, 140, -448/3, 112, -64, 761/35];
    otherwise, tt=[],xx=[],'duotas lyginis formules tasku skaicius' 
end

% Apskaiciuojame funkcija ir isvestine
n=length(f);
mid=(N+1)/2-1;
for i=1:n 
    
    
    if i<mid+1,         Isvestine(i)=ww(i,1:N)*f(1:N)' ;
    elseif i > n-mid,   Isvestine(i)=ww(N+i-n,1:N)*f(n-N+1:n)';
    else ,              Isvestine(i)=ww(mid+1,1:N)*f(i-mid:i+mid)';
    end
end


return,end

function L=Lagrange(X,j,x)
    n=length(X);L=1;
    for k=1:n, if k ~= j, L=L.*(x-X(k))/(X(j)-X(k)); end, end
return, end

% ------------------------------------------
    function fff=fnk(x)
    %   Si funkcija reikalinga, kad butu galima jos varda perduoti 
    %   kitai funkcijai faktiniu parametru sarase 
    global X F
    fff=eval(subs(F,sym(X),sym(x)));
    return, end