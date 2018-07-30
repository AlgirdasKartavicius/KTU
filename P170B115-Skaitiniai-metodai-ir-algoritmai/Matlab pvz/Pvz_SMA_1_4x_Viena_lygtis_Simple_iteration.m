%
% Vienos lygties sprendimas: paprastuju iteraciju metodas
% 
function Pvz_SMA_1_4_Viena_lygtis_simple_iteration
clc,close all

%------------------------   PRADINIAI DUOMENYS  ----------------------------

range=[-3,8] % parenkame saknu atskyrimo intervala



% x0=-1.3    % parenkame pradini artini
x0=0
x0=0.0001
x0=-1.7

eps=1e-4   % parenkame sprendinio tikslumo reiksme

nitmax=100 % parenkame didziausia leistina iteraciju skaiciu

method='simple_iteration'  % parenkame metoda

alpha=10 % parenkame daugiklio reiksme
% alpha=2
% alpha=-10000
% alpha=-7
% alpha=-2
% alpha=-10

% braizomas funkcijos grafikas
npoints=1000; x=range(1): (range(2)-range(1))/(npoints-1) :range(2);  fff=f(x);
figure(1); grid on; hold on; axis equal;axis([range(1),range(2),-1,7]);
line([range(1),range(2)],[0,0],'Color','k');
plot(x,fff,'b-','LineWidth',3);
% splot(range,range,'b-');

%------------------------   SPRENDIMAS  -----------------------------------

xn=x0;prec=1e20; nit=0; % pradinis artinys, pradine tikslumo reiksme ir iteracijos numeris
while prec > eps  % iteracijos
    nit=nit+1;
    if nit > nitmax, fprintf('Virsytas leistinas iteraciju skaicius. Tikslumas nepasiektas');return;end

    if strcmp(method,'simple_iteration')
            fn=f(xn)/alpha+xn;
            plot([xn,xn,xn+f(xn)/alpha],[0,f(xn),0],'r-','LineWidth',2);
            plot(xn,f(xn),'mp');
            xn=fn;
    else, fprintf('neaprasytas metodas \n');
    end
     
        pause
        
    prec=abs(f(xn));
    fprintf(1,'iteracija %d  x= %g  prec= %g \n',nit,xn,prec);
end
plot(xn,fn,'k*');plot(xn,fn,'ko');

fprintf(1,'\n tikslumas pasiektas, saknis xmid=%g\n\n',xn);

end


function fff=f(x)
    fff= 1.5*x.^2-1 % +0.1*sin(100*x);
%     fff=64*x.^4-576*x.^3+10*x.^2+9*x;
return
end