function Ode
global g m k1 k2;
k1 = 0.015;
k2 = 0.05;
g = -9.81;
m = 0.5;
v0 = 50;
h0 = 30;

v=v0;

Tmax = 10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%sprendimas ode45 funkcija
[T,X]=ode45(@fun,[0 Tmax],[h0; v]);
acc = diff(X(:,2))./diff(T);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); hold on; grid on;
xlabel('t');
ylabel('aukstis (m)');
plot(T,X(:,1),'.-');
figure(2); hold on; grid on;
xlabel('t');
ylabel('greitis (m/s)');
plot(T,X(:,2), 'r.-');
figure(3); hold on; grid on;
xlabel('t');
ylabel('pagreitis (m/s^2)');
plot(T(2:end), acc, 'm.-');
legend1={'Aukstis',...
    'Greitis',...
    'Pagreitis'};
%legend(legend1);
    function hv=fun(t,y)
        if(y(2) > 0)
            dv=((m*g)-(k1*y(2).^2))./m;
        else
            dv=((m*g)+(k2*y(2).^2))./m;
        end
        hv=[y(2); dv];
    end
end