%
% Viena lygtis: paprastuju iteraciju, Niutono ir kirstiniu metodai
% 

function Viena_lygtis_Simple_iteration_Newton_Secant
clc, close all

%------------------------   PRADINIAI DUOMENYS  ---------------------------

syms f x 

f=(0.5*x.^2-1)*1 % parenkame funkcija
% f=1.5.*x^2-1
% f=atan(x)
% f=-0.5*x
% f=1.5.*x^2

x0=-1.8; % parenkame pradini artini
x01=-1.1;  % kirstiniu metodui parenkame antra pradini artini  
deltax=0.01; % parenkame pradine zingsnio reiksme (reikalinga tik kirstiniu metodui)
nitmax=100; % parenkame didziausia leistina iteraciju skaiciu
if x0 ~= 0, range=3*[-abs(x0),abs(x0)]; % parenkame intervala vaizdavimui
else, range=[-3,0];
end

eps=1e-9;  % Parenkame tiksluma

% method='simple iterations'; alpha=-1;  %-1
 method='Newton'; beta=0.5 ; %0.5
% method='secants'; 

if strcmp(method,'Newton'),df=diff(f,x), end  % Taikant Niutono metoda, reiks ne tik funkcijos, 
                                              % taciau ir jos isvestines israiskos
if strcmp(method,'secants'),
    x=x01;fxn1=eval(f);x=x0;fxn=eval(f);
    dfxn=(fxn1-fxn)/(x01-x0); end  % Taikant kirstiniu metoda, reiks apskaiciuoti , 
                                   % pradines kirstines krypti pagal du pradinius artinius

% braizomas funkcijos grafikas:
npoints=1000; xrange=range(1): (range(2)-range(1))/(npoints-1) :range(2);  
figure(1); grid on; hold on; axis equal; str=[char(f),'=0;   Method of ',method];title(str);
x=xrange; % simbolinis x keiciamas reiksmemis is parinkto funkcijos vaizdavimo intervalo 
if strcmp(method,'simple iterations') || strcmp(method,'Newton') || strcmp(method,'secants'),plot(x,eval(f),'r-');plot(range,[0 0],'b-');plot(x0,0,'mp');h = findobj(gca,'Type','line');h1=h(1);
else, fprintf('neaprasytas metodas \n'); 
end

        input('Press Enter'), figure(1); % skaiciavimas stabdomas iki bus paspaustas Enter klavisas

%------------------------   SPRENDIMAS  -----------------------------------
xn=x0;prec=1;nit=0;
if strcmp(method,'secants'), 
    xn1=x01; 
    plot([xn,xn,xn1,xn1],[0,fxn,fxn1,0],'k-');
end % antras pradinis artinys
while prec > eps    % iteracijos 
    nit=nit+1;
    if nit > nitmax, fprintf('Virsytas leistinas iteraciju skaicius');break;end

    switch method
        
        case 'simple iterations'
            x=xn;fxn=eval(f);
            fn=fxn+alpha*xn;
            plot([xn,xn,xn+fxn/alpha],[0,fxn,0],'k-');
            plot(xn,fxn,'mp');
            xn=fn/alpha;
            delete(h1);plot(xn,xn,'mp');h = findobj(gca,'Type','line');h1=h(1);
            
        case 'Newton' 
            x=xn;fxn=eval(f);dfxn=eval(df);
            xn1=xn-beta*fxn/dfxn;   % daugikliu alpha galima apriboti x prieaugi, tikintis
                                     % geresnio konvergavimo   
            plot([xn,xn,xn1],[0,fxn,0],'k-');
            delete(h1);plot(xn1,0,'mp');h = findobj(gca,'Type','line');h1=h(1);
            xn=xn1;
            
        case 'secants' 
            xn1=xn-fxn/dfxn;
            plot([xn,xn,xn1],[0,fxn,0],'k-');
            delete(h1);plot(xn1,0,'mp');h = findobj(gca,'Type','line');h1=h(1);
            x=xn1;fxn1=eval(f);dfxn=(fxn1-fxn)/(xn1-xn);
            xn=xn1;
            fxn=fxn1;
            
        otherwise, fprintf('neaprasytas metodas \n');
            
        end
     
%         pause(1)
        input('Press Enter'), figure(1); % skaiciavimas stabdomas iki bus paspaustas Enter klavisas
        
    x=xn;fxn=eval(f);prec=abs(fxn);
    fprintf(1,'iteracija %d  x= %g  prec= %g \n',nit,xn,prec);
end
plot(xn,fxn,'k*');plot(xn,fxn,'ko');
xn
nit

end


