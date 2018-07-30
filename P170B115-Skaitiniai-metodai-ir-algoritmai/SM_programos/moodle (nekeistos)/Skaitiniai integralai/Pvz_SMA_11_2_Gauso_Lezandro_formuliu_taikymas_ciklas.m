% Gauso_Lezandro formules: tyrimas cikle

function main
clc,clear all,close all

global F X
syms F X
F=sin(2*X-3)+1;
%  F=sin(2*X)+sqrt(abs(X))+0.5;
 
a=-1;b=1; % intervalas
nnn=1000;xxx=[a:(b-a)/(nnn-1):b]; % vaizdavimo tasku skaicius ir abscises

maxN=9
for iii=2:maxN  %*************************************************

N=iii  % formules tasku skaicius    

format long
[Integralas(iii-1),ww,xx]=Gauss_Legendre(@fnk,a,b,N)

figure(iii),hold on, grid on, plot(xxx,fnk(xxx), 'Linewidth',2);title(sprintf('N=%d',N));

Integr_tikslus=eval(int(F,a,b))

% Braizome interpoliuojancias funkcijas, pagal kurias skaiciavome integrala:
FF=fnk(xx);
    nnn=100;sss=[a:(b-a)/(nnn-1):b]; % vaizdavimo tasku skaicius ir abscises 
    yyy=0;
    for j=1:iii % Lagranzo interpoliavimas
        L=Lagrange(xx,j,sss); 
        yyy=yyy+L*subs(F,sym(X),xx(j));
    end
    plot(sss,yyy,'r-'), plot(xx,FF,'r*'), plot([sss(1),sss(1)],[0,yyy(1)],'r-'),plot([sss(end),sss(end)],[0,yyy(end)],'r-')


end  %*************************************************

figure(10), hold on, grid on, plot([2,maxN],Integr_tikslus*[1,1],'b-');plot([2:maxN],Integralas,'r-*'); 
legend({'tiksli integralo reiksme','skaitiskai apskaiciuotos reiksmes skirtingomis G-L formulemis' })
% figure(11), hold on, grid on,;plot([2:maxN],Integralas-Integr_tikslus,'r-*'); 
% legend({'skaitiskai apskaiciuotu reiksmius skirtingomis G-L formulemis paklaidos' })

return,end
% 
function [Integralas,ww,xx]=Gauss_Legendre(f,a,b,N)
% Nustatome skaitinio integravimo koeficientus:
N
switch N 
    case 1, ww=0,xx=2,
    case 2, ww=[1, 1],
            xx=[-0.5773502691896256 , 0.5773502691896258]
    case 3, ww=[ 0.5555555555555556  0.8888888888888888  0.5555555555555556],
            xx=[  -0.7745966692414833                   0  0.7745966692414834 ]
    case 4, ww=[ 0.3478548451374526  0.6521451548625477  0.6521451548625459  0.3478548451374538],
            xx=[  -0.8611363115940536  -0.3399810435848565  0.3399810435848563  0.8611363115940527 ]
    case 5, ww=[0.2369268850561889  0.4786286704993673  0.5688888888888882  0.4786286704993663  0.2369268850561894],    
            xx=[   -0.9061798459386644  -0.5384693101056826                   0  0.5384693101056831  0.9061798459386636]
    case 6, ww=[0.1713244923791698  0.3607615730481396  0.4679139345726914  0.4679139345726882  0.3607615730481424  0.1713244923791686],
            xx=[  -0.9324695142031529  -0.6612093864662639  -0.238619186083197   0.238619186083197  0.6612093864662633  0.9324695142031541 ]
    case 7, ww=[ 0.1294849661688681  0.2797053914892803  0.3818300505051153  0.4179591836734723  0.3818300505051162  0.2797053914892796  0.1294849661688681],
            xx=[  -0.94910791234276  -0.7415311855993936  -0.4058451513773972                   0  0.4058451513773971  0.7415311855993942  0.9491079123427597 ]
    case 8, ww=[0.1012285362903742  0.2223810344533782  0.3137066458778863  0.3626837833783588  0.3626837833783699  0.3137066458778749  0.2223810344533868   0.101228536290371],
            xx=[ -0.9602898564975388  -0.7966664774136254  -0.5255324099163291  -0.1834346424956496  0.1834346424956498  0.5255324099163307  0.7966664774136224  0.9602898564975423 ]
    case 9, ww=[ 0.08127438836157266  0.1806481606948625  0.2606106964029297   0.312347077040007  0.3302393550012565  0.3123470770400061  0.2606106964029323  0.1806481606948581  0.08127438836157509 ],
            xx=[ -0.9681602395076281  -0.8360311073266339  -0.6133714327005906  -0.324253423403809                   0   0.324253423403809  0.6133714327005909  0.8360311073266343   0.968160239507626]
    otherwise, tt=[],xx=[]
end
ww=ww*2/(b-a);xx=xx*(b-a)/2+(b+a)/2;

% Apskaiciuojame integrala
fff=f(xx)
Integralas=sum(ww.*fff)

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