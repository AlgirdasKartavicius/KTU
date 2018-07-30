% Saulius Stankevicius IFF-4/2

function Interpoliavimas
clc, close all;

f=@(x)cos(2*x).*(sin(2*x) + 1.5) + cos(x);
f_sym = '(cos(2x)*(sin(2x)+1.5) + cos(x)';
minX = -2;
maxX = 3;
N = 10;
X = [minX:(maxX-minX)/(N-1):maxX]; % tolygiai paskirstytu interpoliavimo tasku abscises
k=[0:N-1];
XC=(maxX+minX)/2+(maxX-minX)/2*cos((2*k+1)*pi/(2*N)); % "Ciobysevo abscises"
x = min(X):(max(X)-min(X))/1000:max(X); % reiksmes vaizdavimui
M = ones(N);
MC = ones(N);

for j=1:N
    for k=1:N
        M(k,j) = X(k).^(j-1);
        MC(k,j) = XC(k).^(j-1);
    end
end

A = M\f(X).';   % vienanariu bazes koeficientai
AC = MC\f(XC).'; % vienanariu bazes koeficientai
Y = [];
YC = [];
Yn = [];
YCn = [];

for j=1:numel(x)
    y = 0;
    yc = 0;
    for k=1:N
        y = y + x(j)^(k-1)*A(k);
        yc = yc + x(j)^(k-1)*AC(k);
    end
    Y = [Y; y];
    YC = [YC; yc];
    Yn = [Yn; f(x(j))-y];
    YCn = [YCn; f(x(j))-yc];
end

legend1={['Duotoji funkcija: ', f_sym],...
    'Tolygiai pasiskirste mazgai',...
    'Interpoliavimas per tolygiai pasiskirsciusius mazgus',...
    'Netektis'};
legend2={['Duota funkcija', f_sym],...
    'Mazgai pagal Ciobysevo abscises',...
    'Interpoliavimas per Ciobysevo mazgus',...
    'Netektis'};
figure(1), hold on, grid on;
title('Mazgai pasiskirste tolygiai.');
plot(x,f(x),'k-'); % duotoji funkcija
plot(X,f(X),'bo','MarkerFaceColor','b','MarkerSize',6); % mazgai
plot(x, Y, 'b-'); % interpoliavimas
plot(x,Yn,'b--'), % netektis
legend(legend1);
figure(2), hold on, grid on;
title('Ciobysevo mazgai');
plot(x,f(x),'k-'); % duotoji funkcija
plot(XC, f(XC),'bo','MarkerFaceColor','b','MarkerSize',6) % mazgai
plot(x, YC, 'b-'); % interpoliavimas
plot(x,YCn,'b--'), % netektis
legend(legend2);

end