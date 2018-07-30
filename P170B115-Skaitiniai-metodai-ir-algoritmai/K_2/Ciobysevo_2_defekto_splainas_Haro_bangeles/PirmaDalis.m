% Lagranzo_interpoliavimas_1D_pagal_duota_funkcija
% Programa demonstruoja, kaip skiriasi interpoliavimo kokybe, 
% kai interpoliavimui parenkame N tolygiai paskirstytu tasku, 
% ir kai interpoliavimo taskais parenkame "Ciobysevo abscises"
 
function PirmaDalis
clc, clear all, close all
xmin=-2;xmax=3;  % duotas funkcijos apibrezimo intervalas 
N=9;   % interpoliavimo tasku skaicius
X=[xmin:(xmax-xmin)/(N-1):xmax];  % tolygiai paskirstytu interpoliavimo tasku abscises
k=N-1:-1:0;
XC=(xmax+xmin)/2+(xmax-xmin)/2*cos((2*k+1)*pi/(2*N)); % "Ciobysevo abscises"
 
Y=funkcija(X);     %  tolygiai paskirstytu interpoliavimo tasku ordinates
YC=funkcija(XC);   %  ordinates "Ciobysevo abscisiu" taskuose
x=min(X):(max(X)-min(X))/1000:max(X);   %x reiksmes vaizdavimui
n=length(X);
leg={'duota funkcija',...
    'tolygiai isdestyti mazgai',...
    'interpoliavimas per tolygiai isdestytus mazgus',...
    'netiktis interpoliuojant per tolygiai isdestytus mazgus',...
    'Ciobysevo abscises',...
    'interpoliavimas per Ciobysevo abscises',...
    'netiktis interpoliuojant per Ciobysevo abscises'};
 
figure(1), hold on, grid on,box on,axis equal, set(gcf,'Color','w'); 
plot(x,funkcija(x),'b-')   % vaizduojama duotoji funkcija (t.y. pagal kuria interpoliuojama) 
hg=legend(leg{1});pause
plot(X,Y,'ro','MarkerFaceColor','r','MarkerSize',8) % vaizduojami tolygiai isdestyti interpoliavimo taskai 
delete(hg);hg=legend(leg{1:2});pause
 T = zeros(n, n);
 TC = zeros(n, n);
for i=1:N
    T(i,1)=1;
    T(i,2)=X(i);
    TC(i,1)=1;
    TC(i,2)=XC(i);
    for j=3:N,
        T(i,j)=2*X(i)*T(i,j-1)-T(i,j-2);
        TC(i,j)=2*XC(i)*TC(i,j-1)-TC(i,j-2);
    end
end
 
a=flipud(T\Y');
ac=flipud(TC\YC');
F=klensou(a,x);
FC=klensou(ac,x);
 
plot(x,F,'r-')      % vaizduojama funkcija, interpoliuojanti tolygiai paskirstytuose mazguose 
plot(x,funkcija(x)-F,'r--'),      % vaizduojama netiktis duotos funkcijos atzvilgiu 
delete(hg);hg=legend(leg{1:4});pause
 
plot(XC,YC,'go','MarkerFaceColor','g','MarkerSize',8)   % vaizduojami interpoliavimo mazgai ties Ciobysevo abscisemis
delete(hg);hg=legend(leg{1:5});pause
plot(x,FC,'g-')   % vaizduojama funkcija, interpoliuojanti Ciobysevo mazguose 
plot(x,funkcija(x)-FC,'g--'),  % vaizduojama netiktis duotos funkcijos atzvilgiu
delete(hg);hg=legend(leg);
 
return
end
 
function px=klensou(a,x)
n=numel(a);
bk2=0;
bk1=0;
for k=1:n
   bk=a(k)+2*x.*bk1-bk2;
   bk2=bk1;
   bk1=bk;
end;
px=bk-x.*bk2;
return;
end
 
function fnk=funkcija(x)
% apskaiciuoja interpoliuojamos funkcijos reiksmes taskuose x
 
fnk=cos(2*x)./(sin(2*x)+1.5)-x./5;
return
end
