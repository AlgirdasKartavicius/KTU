% 
% MATLAB funkciju taikymas lygciu sprendimui
% 
function MATLAB_funkciju_taikymas
clc, close all, clear all

% parenkame funkcija ir pradini artini:

figure(1);hold on;grid on,

% option='fsolve';
% option='fzero';
% option='roots_daugianaris';
option='roots_Taylor';


switch option
    case 'fzero'
       x0=4;   % pradinis artinys 
       saknis=fzero(@funk,x0) 
       % grafinis vaizdavimas :
       x=[-15:0.01:15]; plot(x,funk(x));plot(x0,0,'bo');plot(saknis,0,'rp');       
       
    case 'fsolve'  
       x0=-10;   % pradinis artinys  
       saknis=fsolve(@funk,x0)
       % grafinis vaizdavimas :
       x=[-15:0.01:15]; plot(x,funk(x));plot(x0,0,'bo');plot(saknis,0,'rp');
              
    case 'roots_daugianaris'
        
        koef=[15 5 1 -8 1]  % daugianaris aprasomas koeficientu vektoriumi,
                            % pradedant nuo auksciausio laipsnio
        
        % uzrasome daugianario israiska simboliais komandu lange:                     
        n=length(koef)-1; % daugianario eile
        sss=[];
        for i=n:-1:1 
            if koef(n-i+1) ~= 0, sss=[sss,sprintf('%+d*x^%d',koef(n-i+1),i)];end
        end
        if koef(end) ~=0, sss=[sss,sprintf('%d',koef(end))];end
        sss=[sss,'=0'];
        if sss(1)== '+'; sss(1)=' '; end
        disp(sss)
        
        saknys=roots(koef)
        
        %grafinis vaizdavimas :
        x=[-10:0.01:10];fff=0;
        for i=0:n, fff=fff+koef(n-i+1)*x.^i;  end
         plot(x,fff,'b-'); % braizoma kreive
        for i=1:length(saknys) % vaizduojamos realios saknys
            if isreal(saknys(i)), plot(saknys(i),0,'rp');end
        end 
        
    case 'roots_Taylor'
         
        x0=pi/2;
        syms x f fp f1 

        f=x*sin(x)  % funkcijos israiska simboliais
        x0=0    % pradinis artinys, TE pradinis taskas
        N=11;  % iki kokios eiles naudoti TE narius
  
        fp=subs(f,'x',x0);    % pirmas TE narys 
        f1=f; % prisimename pradine funkcijos israiska
        for i=1:N                   % TE aproksimavimo ciklas
            f=diff(f)        % analizinis diferencijavimas
            fp=fp+subs(f,'x',x0)/factorial(i)*(x-x0)^i;  % TE suma 
        end       
        disp(fp)            % uzrasome daugianario israiska simboliais komandu lange
        koef=sym2poly(fp)   % daugianario koeficientu vektorius pradedant nuo auksciausio laipsnio
        saknys=roots(koef)

        %grafinis vaizdavimas :
        x=[-13:0.001:13];fff=eval(subs(fp,'x',x)); plot(x,fff,'b-'); % braizoma kreive
        for i=1:length(saknys) % vaizduojamos realios saknys
            if isreal(saknys(i)), plot(saknys(i),0,'rp');end
        end 
        plot(x,eval(f1),'g-'); % vaizduojama pradine funkcija
        
    end
end

function rez=funk(x)
         rez=x.*sin(x);
return
end


    
    
    