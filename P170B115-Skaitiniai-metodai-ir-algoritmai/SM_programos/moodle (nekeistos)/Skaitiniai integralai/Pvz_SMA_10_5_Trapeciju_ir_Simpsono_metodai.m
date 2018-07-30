% Niutono-Koteso formules
% Trapeciju metodas
function main
clc,clear all,close all

syms f x
% f=sin(2*x-2)
f=sin(2*x)+sqrt(abs(x));

a=-1;b=1;
nnn=1000;xxx=[a:(b-a)/(nnn-1):b]; % vaizdavimo tasku skaicius ir abscises
n=51;X=[a:(b-a)/(n-1):b]; % integravimo tasku skaicius ir abscises
F=eval(subs(f,x,sym(X)));
Int_Trap=Trapezoidal(F,a,b)
Int_Simps=Simpson(F,a,b)
figure(1),hold on, grid on
plot(xxx,eval(subs(f,x,sym(xxx))));

format long
Integr_tikslus=eval(int(f,a,b))
return,end

function Int_Trap=Trapezoidal(fff,a,b)
n=length(fff);Int_Trap=(sum(fff)+sum(fff(2:n-1)))*(b-a)/(2*(n-1));
return,end

function Int_Simps=Simpson(fff,a,b)
nn=length(fff);
if floor(nn/2)==nn/2, 'Simpsono formuleje tasku skaicius n turi buti nelyginis', return,end
Int_Simps=(sum(fff)+sum(fff(2:nn-1))+2*sum(fff(2:2:nn-1)))*(b-a)/(3*(nn-1));


return,end

