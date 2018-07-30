% 
% Teiloro eilutes paaiskinimas
% 
function Teiloro_eilutes_paaiskinimas
clc, close all, clear all

sss={'k','ko','b-','r-','g-','m-','c-'}
syms x f fp fpc
% parenkame funkcija ir taska, kurio aplinkoje funkcija aproksimuojama Teiloro eilute
% f=x.*sin(x),x0=-10;   
% f=sin(x),x0=0
 f=10*x^10+5*x^3-2*x^2+x-5, x0=-2

figure(1);hold on;grid on;  % braizome funkcijos grafika
xrange=[-24:0.1:24]; % reziai
x=xrange; % buvusiam simboliniam kintamajam priskiriamos konkrecios reiksmes
ff=eval(f);
plot(x,ff,sss{1},'LineWidth',2);
axis([min(xrange) max(xrange) min(ff) max(ff)]) % koordinaciu asiu reziai


x=x0; f0=eval(f);
plot(x,f0,sss{2});
haprox=plot(xrange,f0*ones(1,length(xrange)),'b-');  % nulines eiles artinys (pastovi reiksme)
title(['f(x)=',char(f)]);leg={'duota funkcija','taskas','1 TE narys (nulines eiles aproksimacija)'};hleg=legend(leg);

pause % paziurejus i grafika, spausti klavisa 

N=50;  % iki kokios eiles braizyti Teiloro daugianariu kreives

for i=1:N    % aproksimacijos eiles ciklas
    f=diff(f)  % analizinis veiksmas: funkcija diferencijuojama
    
    x=x0; f1=eval(f)
    f0=f0+((xrange-x0)).^i./factorial(i).*f1;
    if i+3 > length(sss), sss=[sss,sss(4:end)]; end
    if 1,delete(haprox);haprox=plot(xrange,f0,sss{4});  %i+1 TE nariu artinys
        leg={leg{1:2},sprintf('%d TE nariai',i+1)};
        leg
        hleg=legend(leg);
    else, haprox=plot(xrange,f0,sss{i+3}); 
        leg={leg{1},sprintf('%d TE nariai',i+1)};delete(hleg);hleg=legend(leg);
    end
   pause % paziurejus i grafika, spausti klavisa
   figure(1)
end


    
    
    