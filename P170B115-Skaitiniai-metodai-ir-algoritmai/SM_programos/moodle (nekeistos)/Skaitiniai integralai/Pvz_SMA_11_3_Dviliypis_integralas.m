% Dvilypio integralo iliustracija ir apskaiciavimo formules

function main
clc,clear all,close all

syms x1 x2 
global X 
global F
    X=[x1; x2];
    F=cos(X(1)+0.5).*X(2)+0.1;
%         F=cos(X(1)+0.5)+X(2)*.0001+0.1;
%     F=0.1*X(1)^2+0.2*X(1)*X(2)+2;

x=[-1:0.1:1];y=[-1:0.1:1];
Z=pavirsius(@fnk,x,y);
figure(1),hold on,grid on,axis equal   
size(Z) 
mesh(x,y,Z','FaceAlpha',0.2); xlabel('x'),ylabel('y'); % braizomas pavirsius
fill3([x(1),x,x(end),x(1)],[-1,-ones(1,length(x)),-1,-1],[0,Z(:,1)',0,0],'r','FaceAlpha',0.6) % sonines sienos
fill3([x(1),x,x(end),x(1)],[1,ones(1,length(x)),1,1],[0,Z(:,end)',0,0],'r','FaceAlpha',0.6)
fill3([-1,-ones(1,length(x)),-1,-1],[y(1),y,y(end),y(1)],[0,Z(1,:),0,0],'r','FaceAlpha',0.6)
fill3([1,ones(1,length(x)),1,1],[y(1),y,y(end),y(1)],[0,Z(end,:),0,0],'r','FaceAlpha',0.6)
fill3([x(1),x(1),x(end),x(end)],[y(1),y(end),y(end),y(1)],[0,0,0,0],'b','FaceAlpha',0.6) % xOy plokstuma
view([1 1 1 ])
disp(' ---------------------------- ')
[Integralas,wwx,wwy,xx,yy]=Gauss_Legendre_2D(@fnk,-1,1,-1,1,4)
N=length(wwx);

figure(2),hold on,grid on,axis equal
mesh(x,y,Z','FaceAlpha',0.2); xlabel('x'),ylabel('y'); % braizomas pavirsius
fill3([x(1),x(1),x(end),x(end)],[y(1),y(end),y(end),y(1)],[0,0,0,0],'b','FaceAlpha',0.2) % xOy plokstuma
view([1 1 1 ])

for i=1:N
    for j=1:N
        zzz=eval(subs(subs(F,x1,sym(xx(i))),x2,sym(yy(j))));
        plot3([xx(i),xx(i)],[yy(j),yy(j)],[0,zzz],'r-*','MarkerSize',8,'Linewidth',2)
        text(xx(i),yy(j),0,sprintf('(%g, %g) \nw=%g',xx(i),yy(j),wwx(i)*wwy(j)),'FontSize',18);
    end
end

disp('Tiksli integralo reiksme:')
eval(int(int(F,x1,-1,1),x2,-1,1))


% P=[0.5;0.3];  % taskas
% fnk=subs(F,X,P)
% plot3(P(1),P(2),fnk,'k*')
% plot3(P(1),P(2),0,'r*')
% plot3([P(1),P(1)],[P(2),P(2)],[0,fnk],'r--')
% xx=axis;



return,end
% 
function [Integralas,wwx,wwy,xx,yy]=Gauss_Legendre_2D(f,ax,bx,ay,by,N)
% Nustatome skaitinio integravimo koeficientus:
N
switch N 
    case 1, ww=2,xx=0,
    case 2, ww=[1, 1],xx=[-0.5773502691896256 , 0.5773502691896258]
    case 3, ww=[ 0.5555555555555556  0.8888888888888888  0.5555555555555556],xx=[  -0.7745966692414833                   0  0.7745966692414834 ]
    case 4, ww=[ 0.3478548451374526  0.6521451548625477  0.6521451548625459  0.3478548451374538],xx=[  -0.8611363115940536  -0.3399810435848565  0.3399810435848563  0.8611363115940527 ]
    case 5, ww=[0.2369268850561889  0.4786286704993673  0.5688888888888882  0.4786286704993663  0.2369268850561894],xx=[   -0.9061798459386644  -0.5384693101056826                   0  0.5384693101056831  0.9061798459386636]
    case 6, ww=[0.1713244923791698  0.3607615730481396  0.4679139345726914  0.4679139345726882  0.3607615730481424  0.1713244923791686],xx=[  -0.9324695142031529  -0.6612093864662639  -0.238619186083197   0.238619186083197  0.6612093864662633  0.9324695142031541 ]
    case 7, ww=[ 0.1294849661688681  0.2797053914892803  0.3818300505051153  0.4179591836734723  0.3818300505051162  0.2797053914892796  0.1294849661688681],xx=[  -0.94910791234276  -0.7415311855993936  -0.4058451513773972                   0  0.4058451513773971  0.7415311855993942  0.9491079123427597 ]
    case 8, ww=[0.1012285362903742  0.2223810344533782  0.3137066458778863  0.3626837833783588  0.3626837833783699  0.3137066458778749  0.2223810344533868   0.101228536290371],xx=[ -0.9602898564975388  -0.7966664774136254  -0.5255324099163291  -0.1834346424956496  0.1834346424956498  0.5255324099163307  0.7966664774136224  0.9602898564975423 ]
    case 9, ww=[ 0.08127438836157266  0.1806481606948625  0.2606106964029297   0.312347077040007  0.3302393550012565  0.3123470770400061  0.2606106964029323  0.1806481606948581  0.08127438836157509 ],xx=[ -0.9681602395076281  -0.8360311073266339  -0.6133714327005906  -0.324253423403809                   0   0.324253423403809  0.6133714327005909  0.8360311073266343   0.968160239507626]
    otherwise, tt=[],xx=[]
end
wwx=ww*2/(bx-ax);xx=xx*(bx-ax)/2+(bx+ax)/2;
wwy=ww*2/(by-ay);yy=xx*(by-ay)/2+(by+ay)/2;

% Apskaiciuojame integrala
Integralas=0;
for i=1:N
    for j=1:N
    fff=f([xx(i),yy(j)]);
    Integralas=Integralas+wwx(i)*wwy(j)*fff;
    end
end

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

% ------------------------------------------
    function Z=pavirsius(funk,x,y)
    % fukcija suformuoja dvieju kintamuju funkcijos masyva vaizdavimui
        for i=1:length(x), for j=1:length(y), Z(i,j)=funk([x(i),y(j)]);end,end
    return,end
