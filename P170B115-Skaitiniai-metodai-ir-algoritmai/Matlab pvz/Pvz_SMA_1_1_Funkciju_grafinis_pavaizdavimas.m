%
% Funkciju grafinis pavaizdavimas 

function Pvz_SMA_1_1_Funkciju_grafinis_pavaizdavimas
clc, close all
syms x f
option=1;  % 1 - daugianaris, sugeneruojamas pagal duotas realias saknis;
           % 2 - argumento x funkcija, uzrasoma simboline israiska
           
switch option           
    case 1   % daugianaris
%         roots=[ -1 ,0 ,2,  10]  % duotos saknys
%         roots=[2 1]
        roots=[-5 2]
%                 roots=[1 1]
%         roots=[-5 -3 -2 -1  1 2 3 4 6 7]
        f=1;
        for i=1:numel(roots), f=f*(x-roots(i)); end 
        f=expand(f)  % panariui isskleistas daugianaris
        f=strrep(char(f),'^','.^')
        
    case 2  % simboline israiska, argumentas x

        f='sin(x).*(x.^2-1).*(x+3)-0.9'
end

xmin=-10; xmax=10; nst=30; % vaizdavimo reziai ir tasku skaicius

x=[xmin :(xmax-xmin)/nst : xmax];
figure(1);grid on;hold on;plot(x,eval(f),'b-');
title([char(f),'=0']);
end
