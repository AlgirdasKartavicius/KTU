%
% Eulerio metodas
%
function Euler
clc, clear all,
close all
global m m1 m2 h0 tg g;
m1 = 100;
m2 = 15;
m = m1 + m2;
k1 = 0.5;
k2 = 10;
tg = 40;
h0 = 3000;
g = 9.8;
spalva='k'
t0=0;v0=0;
dt=0.1;
tmax=170;
% figure(100), hold on, grid on,
% plot(t0,v0,'ro')
nnn=100;
nsteps=tmax/dt;
xxx=t0+(0:dt/(nnn-1):dt);
figure(1), hold on, grid on, %axis(range);
t=t0;v=v0;
plot(t,v,'ro');
pntt=t;pntv=v;
H  = [nsteps, 2];
h = h0;
for i=1:nsteps
    dv=DV1(t,v);
    H(i,1) = t;
    h = h + dt*dv(2);
    H(i,2)=h;
%     H(i,2) = h0 - ((abs(dv(1) + dv(2))) * t);
    v=v+dt*dv(1);
    t=t+dt;
    plot(t,v,[spalva,'.'],'MarkerSize',8)
    plot([pntt,t],[pntv,v],[spalva,'-']);
    pntt=t;pntv=v;
    xxx=xxx+dt;
end
H
figure(2), hold on, grid on, %axis(range);
plot(H(:,1),H(:,2),[spalva,'.'],'MarkerSize',8)
return
function dv1=DV1(t,v)
% dy=k*y*(n+1-y);
if t <= tg
    kpas = k1;
else
    kpas = k2;
end
dv1=[g - kpas*v(1)*abs(v(1))/m; -v(1)];
return,end
end