function Lab_ode45
clc, clear all,
close all
global g h0 rh c rc R Aw;
t0=0;
rc = 0.09;
h0=0.25;
g=9.8;
rh=0.005;
c=0.6;
Tmax=140;
R=@(h)0.3*sqrt(h)+0,005;
Aw1=@(h)pi*(0.3*sqrt(h)+0.005)^2;
Aw2=@(h)pi*rc.^2;
for i=1:2
    if i==1
        Aw=Aw1;
    else
        Aw=Aw2;
    end    
 		[T,Y]=ode45(@funkcija, [0 Tmax], h0);
    	figure(i); hold on;
plot(T,Y(:,1));
grid minor;
end;
xlabel('Laikas, s'); ylabel('skyscio lygis, m');
function f=funkcija(t,h)
f=-c*pi*rh^2*sqrt(2*g*h)/Aw(h); 
end
end 
