function main
clc,close all,clear all
n=1000; n=round(n/2)*2+1 % tasku skaicius, nelyginis
m=(n+1)/2    % m - harmoniku skaicius
% m=100
T=10;

dazniu_slenkstis=600;
ampl_slenkstis=0.2;

dt=T/n
N=1000 % vaizdavimo tasku skaicius
dttt=T/N

t=[0:dt:T-dt];
ttt=[-T:dttt:2*T];

% Mano funkcijos
G=@(t)sign(2*pi*t/T).*cos(2*pi*3*t/T)+0.1; % Signalas
R=@(t)0.05*cos(2*pi*130*t/T)+0.18*cos(2*pi*40*t/T); % Triuksmas
F=@(t)G(t)+R(t); % Gautas signalas

fff=fnk(T,t); % apskaiciuojame ir pavaizduojame duota tasku seka 
figure(1),hold on,grid on,plot(t,fff,'b.-','MarkerSize',8);
legend(sprintf('Vienas funkcijos periodas n=%d tasku',n))
title('Duotoji funkcija')

ac0=dot(fff,fC(0,T,t))/n;
for i=1:m-1
    ac(i)=dot(fff,fC(i,T,t))*2/n;
    as(i)=dot(fff,fS(i,T,t))*2/n;
end
ac,as

figure(2),hold on
bar(0:m-1,[ac0,sqrt(ac.^2+as.^2)],0.01)
xx=axis; 
plot(xx(1:2),ampl_slenkstis*[1 1],'m--','LineWidth',3); % braizo ampl slenkscio linija
plot(dazniu_slenkstis*[1 1],xx(3:4),'g--','LineWidth',3); % braizo dazniu slenkscio linija
title('Furje amplitudziu spektras pagal kompleksinio skaiciaus moduli ')
legend({'amplitudziu spektras';'amplitudes slenkstis';'dazniu slenkstis'})


fffz=ac0*fC(0,T,ttt)
frequencies=[1:m-1];
frequencies=frequencies(find(frequencies < dazniu_slenkstis))
for i=frequencies
    if sqrt(ac(i)^2+as(i)^2) > ampl_slenkstis
        fffz=fffz+ac(i)*fC(i,T,ttt)+as(i)*fS(i,T,ttt);    
    end
end

fSignalas = G(ttt);
figure(3),hold on,grid on, plot(ttt,fffz,'r'); % Aproksimuota funkcija
%plot(t,fff,'b-','LineWidth',1); % Signalas su triuksmu
plot(ttt,fffz-fSignalas,'b--'); % Netiktis
xlim([0; 10]);
title(sprintf('Pagal Furje spektra atkurta funkcija'))

% Mano funkciju atvaizdavimas
fF=F(t);
figure(4),hold on,grid on,plot(t,fF,'b.-','MarkerSize',8);
title(sprintf('Signalo ir triuksmo suma'))
fG=G(t);
figure(5),hold on,grid on,plot(t,fG,'b.-','MarkerSize',8);
title(sprintf('Signalo funkcija'))
fR=R(t);
figure(6),hold on,grid on,plot(t,fR,'b.-','MarkerSize',8);
title(sprintf('Triuksmo funkcija'))

return
end

function c=fC(i,T,t), if i==0,c=1*cos(0*t); else, c=cos(2*pi*i/T*t); end, return, end
function s=fS(i,T,t), s=sin(2*pi*i/T*t); return, end

%------------------------------------------------------------------------------------------------------
function rez=fnk(T,t), rez=sign(2*pi*t/T).*cos(2*pi*3*t/T)+0.1 + 0.05*cos(2*pi*130*t./T)+0.18*cos(2*pi*40*t./T); return, end
