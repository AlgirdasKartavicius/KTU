% Lagranzo_interpoliavimas_1D_pagal_duota_funkcija
% Programa demonstruoja, kaip skiriasi interpoliavimo kokybe, 
% kai interpoliavimui parenkame N tolygiai paskirstytu tasku, 
% ir kai interpoliavimo taskais parenkame "Ciobysevo abscises"

function pagrindine
clc,close all


xmin=2;xmax=10;  % duotas funkcijos apibrezimo intervalas 
N=9;   % interpoliavimo tasku skaicius
X=[xmin:(xmax-xmin)/(N-1):xmax];  % tolygiai paskirstytu interpoliavimo tasku abscises
k=[0:N-1];
XC=(xmax+xmin)/2+(xmax-xmin)/2*cos((2*k+1)*pi/(2*N)); % "Ciobysevo abscises"
Y=funkcija(X);     %  tolygiai paskirstytu interpoliavimo tasku ordinates
YC=funkcija(XC);   %  ordinates "Ciobysevo abscisiu" taskuose
x=min(X):(max(X)-min(X))/1000:max(X);   %x reiksmes vaizdavimui



n = length(X);
D(:,1)=Y';
DC(:,1)=YC';

for j=2:n
    for i=j:n
        D(i,j)= ( D(i-1,j-1)-D(i,j-1)) / (X(i-j+1)-X(i));      
        DC(i,j)= ( DC(i-1,j-1)-DC(i,j-1)) / (XC(i-j+1)-XC(i));
    end
end
D
DC
A = diag(D)';   % Niutono baz?s reikšm?s kai interpoliavimo taškai pasiskirst? tolygiai
AC = diag(DC)';  % Niutono baz?s reikšm?s kai interpoliavimo taškai ?ebyševo

Df(1,:) = repmat(1, size(x));
C(1,:) = repmat(A(1), size(x));

DCf(1,:) = repmat(1, size(x));
CC(1,:) = repmat(AC(1), size(x));
for j = 2 : n
   Df(j,:)=(x - X(j-1)) .* Df(j-1,:);
   C(j,:) = A(j) .* Df(j,:);
   
   DCf(j,:)=(x - XC(j-1)) .* DCf(j-1,:);
   CC(j,:) = AC(j) .* DCf(j,:);
end
   % polinomo reiksmes apskaiciuojamos kiekviename braizymo taske,
   % pagal masyvo x koordinates
F=sum(C);
FC=sum(CC);

%piesinys = 'tolygiu';
piesinys = 'ciobysevo';

switch piesinys
    case 'tolygiu'
% V raid?
leg={'duota funkcija',...
   'tolygiai isdestyti mazgai',...
   'interpoliavimas per tolygiai isdestytus mazgus',...
    'netiktis interpoliuojant per tolygiai isdestytus mazgus',...
  };
figure(1), hold on, grid on,box on,axis equal, set(gcf,'Color','w'); 
plot(x,funkcija(x),'b-')   % vaizduojama duotoji funkcija (t.y. pagal kuria interpoliuojama) 
hg=legend(leg{1});pause
plot(X,Y,'ro','MarkerFaceColor','r','MarkerSize',8) % vaizduojami tolygiai isdestyti interpoliavimo taskai 
delete(hg);hg=legend(leg{1:2});pause

plot(x,F,'r-')      % vaizduojama funkcija, interpoliuojanti tolygiai paskirstytuose mazguose 
plot(x,funkcija(x)-F,'r--'),      % vaizduojama netiktis duotos funkcijos atzvilgiu 
delete(hg);hg=legend(leg{1:4});pause
legend(leg, 'Location', 'northwest');
    case 'ciobysevo'
leg2={'duota funkcija',...
    'Ciobysevo abscises',...
    'interpoliavimas per Ciobysevo mazgus',...
    'netiktis interpoliuojant per ?iobyševo mazgus'};
figure(1), hold on, grid on,box on,axis equal, set(gcf,'Color','w'); 
plot(x,funkcija(x),'b-')   % vaizduojama duotoji funkcija (t.y. pagal kuria interpoliuojama) 
plot(XC,YC,'go','MarkerFaceColor','g','MarkerSize',6)  % vaizduojami interpoliavimo mazgai ties Ciobysevo abscisemis
hg=legend(leg2{1:2});pause
plot(x,FC,'g-')   % vaizduojama funkcija, interpoliuojanti Ciobysevo mazguose 
plot(x,funkcija(x)-FC,'g--'),  % vaizduojama netiktis duotos funkcijos atzvilgiu
delete(hg);hg=legend(leg2{1:4});

legend(leg2, 'Location', 'northwest');
end
return
end



function fnk=funkcija(x)
% apskaiciuoja interpoliuojamos funkcijos reiksmes taskuose x
ln = @(x)(log(x));
fnk=(ln(x)./(sin(2*x)+1.5))+x;
return
end
