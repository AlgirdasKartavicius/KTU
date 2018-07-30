%
% Vienos lygties sprendimas: pusiaukirtos ir stygu metodai
% 
function Pvz_SMA_1_3_Viena_lygtis_bisection_chords
clc,close all

%------------------------   PRADINIAI DUOMENYS  ---------------------------

% f='2*x.*cos(2*x)-(x+1).^2'  % funkcijos simboline israiska
f='-2*x.^2+2'
% f='x^2'       % tokiai funkcijai siais metodais saknu nerasime

% range=[-10,10] % parenkame saknu atskyrimo intervala 
range=[-2.2,1.8]; 
% range=[-2.2,0.5];
% range=[-2.5,5];
eps=1e-9;  % parenkame tikslumo reiksme 
nitmax=100;% parenkame didziausia leistina iteraciju skaiciu
method='bisection';  % parenkame sprendimo metoda
method='chords';


% braizomas funkcijos grafikas
npoints=1000; x=range(1): (range(2)-range(1))/(npoints-1) :range(2);  
figure(1); grid on; hold on;
str=[f,'=0;   Method of ',method]; title(str);
plot(x,eval(f),'r-');
plot(range,[0 0],'b-');

%------------------------   SPRENDIMAS  -----------------------------------

xn=range(1);xn1=range(2);prec=1;
nit=0;
while prec > eps
    nit=nit+1;
    if nit > nitmax, fprintf('Virsytas leistinas iteraciju skaicius');break;end
    plot(xn,0,'mp');h = findobj(gca,'Type','line');h1=h(1); % paskutinio grafinio objekto valdiklis irasomas handle masyvo priekyje
    plot(xn1,0,'cp');h = findobj(gca,'Type','line');h2=h(1);
    
        % pasirenkame, ar spresti pusiaukirtos, ar stygu metodu:
        
        if strcmp(method,'bisection')    % pusiaukirtos metodas 
            xmid=(xn+xn1)/2;plot(xmid,0,'gs');h = findobj(gca,'Type','line');h3=h(1);
        elseif strcmp(method,'chords')   % stygu metodas 
            x=xn;fxn=eval(f);x=xn1;fxn1=eval(f);
            k=abs(fxn/fxn1);xmid=(xn+k*xn1)/(1+k);
            plot(xmid,0,'gs');plot([xn,xn1],[fxn,fxn1],'g-');h = findobj(gca,'Type','line');h3=h(1:2);
        else, fprintf('neaprasytas metodas \n');
        end
    x=xmid;fxmid=eval(f);
    
    % jeigu pradzioje tikriname kairi taska
    x=xn;fxn=eval(f);
    if sign(fxmid) == sign(fxn), xn=xmid;
    else, xn1=xmid;
    end
    
%     x=xn1;fxn1=eval(f);
%     if sign(fxmid) == sign(fxn1), xn1=xmid;
%     else, xn=xmid;
%     end
        
    pause(2)
    delete(h1);delete(h2);delete(h3);
    
    prec=abs(fxmid); 
    fprintf(1,'iteracija %d    tikslumas= %g \n',nit,prec);
end
plot(xmid,0,'k*');plot(xmid,0,'ko');
fprintf(1,'\n tikslumas pasiektas, saknis xmid=%g\n\n',xmid);


% ................................................................................
disp('.... Patikriname saknies reiksme, naudodami MATLAB funkcija fsolve: ....')
fprintf('\n')

    % fsolve iejimo pirmu parametru gali buti simboliu masyvas(char), kuriame irasyta lygties funkcijos israiska. 
    % Lygties funkcijos argumentas yra simbolis x. 
    % Antras parametras yra x reiksme. x gali buti vektorius.
    
 x0=-10; sprendinys = fsolve(char(f),x0); fprintf(1,'\npradinis artinys  x0=%g,  sprendinys=%g',x0,sprendinys);
 x0=5;   sprendinys = fsolve(char(f),x0); fprintf(1,'\npradinis artinys  x0=%g,  sprendinys=%g',x0,sprendinys);
 fprintf(1,'\n');
end
