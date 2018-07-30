function pagrindine
clc,close all

xmin=-2;xmax=3;  % duotas funkcijos apibrezimo intervalas 
N=11;   % interpoliavimo tasku skaicius
X=[xmin:(xmax-xmin)/(N-1):xmax];  % tolygiai paskirstytu interpoliavimo tasku abscises
k=[0:N-1];
XC=(xmax+xmin)/2+(xmax-xmin)/2*cos((2*k+1)*pi/(2*N)); % "Ciobysevo abscises"

Y=funkcija(X);     %  tolygiai paskirstytu interpoliavimo tasku ordinates
YC=funkcija(XC);   %  ordinates "Ciobysevo abscisiu" taskuose
x=min(X):(max(X)-min(X))/1000:max(X);   %x reiksmes vaizdavimui

leg={'duota funkcija',...
    'tolygiai isdestyti mazgai',...
    'interpoliavimas per tolygiai isdestytus mazgus',...
    'netiktis interpoliuojant per tolygiai isdestytus mazgus',...
    'Ciobysevo abscises',...
    'interpoliavimas per Ciobysevo mazgus',...
    'netiktis interpoliuojant per tolygiai Ciobysevo mazgus'};

figure(1), hold on, grid on,box on,axis equal, set(gcf,'Color','w'); 
plot(x,funkcija(x),'b-')   % vaizduojama duotoji funkcija (t.y. pagal kuria interpoliuojama) 
hg=legend(leg{1});
plot(X,Y,'ro','MarkerFaceColor','r','MarkerSize',8) % vaizduojami tolygiai isdestyti interpoliavimo taskai 
delete(hg);hg=legend(leg{1:2});

xx=zeros(N,N);
for j=1:N
    xx(:,j)=X.^(j-1);
end
fprintf('\nBaziniu funkciju reiksmes interpoliavimo mazguose(X,Y), matrica xx = \n');
for j=0:N-1
    fprintf('      \tX^%g', j);
end
fprintf('      \n____________________________________________________________________________________________      \n');
for i=1:N
    for j=1:N
        fprintf('\t%9.4f',xx(i,j));
    end
    fprintf('\n');
end

A=xx\Y'; %A=inv(xx)*Y'
fprintf('\n Is lygties A*xx=Y gauname interpoliacinio daugianario koeficientus A: \n');
for i=1:N
    fprintf('\t%9.4f', A(i));
end
fprintf('\n');
f=zeros(size(x));
for i=1:N
    f=f+A(i)*x.^(i-1);
end
figure(1);

plot(x,f,'r-')      % vaizduojama funkcija, interpoliuojanti tolygiai paskirstytuose mazguose 
plot(x,funkcija(x)-f,'r--'),      % vaizduojama netiktis duotos funkcijos atzvilgiu 
delete(hg);hg=legend(leg{1:4});

% Ciobysevo

xx=zeros(N,N);
for j=1:N
    xx(:,j)=XC.^(j-1);
end
fprintf('\nBaziniu funkciju reiksmes interpoliavimo mazguose(X,Y), matrica xx = \n');
for j=0:N-1
    fprintf('      \tX^%g', j);
end
fprintf('      \n____________________________________________________________________________________________      \n');
for i=1:N
    for j=1:N
        fprintf('\t%9.4f',xx(i,j));
    end
    fprintf('\n');
end

A=xx\YC'; %A=inv(xx)*Y'
fprintf('\n Is lygties A*xx=Y gauname interpoliacinio daugianario koeficientus A: \n');
for i=1:N
    fprintf('\t%9.4f', A(i));
end
fprintf('\n');
fc=zeros(size(x));
for i=1:N
    fc=fc+A(i)*x.^(i-1);
end
figure(1);

leg2={'duota funkcija',...
    'Ciobysevo abscises',...
    'interpoliavimas per Ciobysevo mazgus',...
    'netiktis interpoliuojant per tolygiai Ciobysevo mazgus'};
figure(2), hold on, grid on,box on,axis equal, set(gcf,'Color','w');
plot(x,funkcija(x),'b-') % vaizduojama duotoji funkcija (t.y. pagal kuria interpoliuojama)
plot(XC,YC,'go')   % vaizduojami interpoliavimo mazgai ties Ciobysevo abscisemis
plot(x,fc,'g-')   % vaizduojama funkcija, interpoliuojanti Ciobysevo mazguose 
plot(x,funkcija(x)-fc,'g--'),  % vaizduojama netiktis duotos funkcijos atzvilgiu
hg2=legend(leg2);

return
end

function fnk=funkcija(x)
% apskaiciuoja interpoliuojamos funkcijos reiksmes taskuose x
fnk=cos(2*x).*(sin(2*x)+1.5)+cos(x);
return
end