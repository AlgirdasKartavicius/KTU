%
% Daugianario_saknu_reziu_iverciai
% 
function Pvz_SMA_1_2_Daugianario_saknu_reziu_iverciai
clc, close all
syms f x

% daugianario sudarymas: ------
option=1;  % 1 - daugianaris, sugeneruojamas pagal duotas realias saknis;
           % 2 - argumento x funkcija, uzrasoma simboline israiska
           
switch option           
    case 1   % daugianaris
%         saknys=[ -1 ,0 ,2,  10] % duotos saknys
%         saknys=[ -1 ,1 ,0];
%         saknys=[2 1]
        saknys=[-5 2 1 7]
%         saknys=[-5 -3 -2 -1  1 2 3 4 6 7]
        f=1;
        for i=1:numel(saknys), f=f*(x-saknys(i)); end 
        f=expand(f)  % panariui isskleistas daugianaris
        
    case 2  % simboline israiska, argumentas x

        f=10*x^3- x+1;   % grubus ivertis geresnis uz tikslesni (kadangi B/a0 <1)
%         f=10*x^3+ x+1;   % grubus ivertis geresnis uz tikslesni (kadangi B/a0 <1)
%         f=10*x^4+ x^2+2; % saknu nera 
%         f=10*x^5+ x^3+2*x;
end

f=expand(f)   % daugianario skleistine
fneig=expand(subs(f,x,-x))   % daugianario skleistine pakeitus x-> -x

[CF1,orders]=coeffs(f,x) % daugianario f koeficientai ir juos atitinkantys x laipsniai

auksciausias_x_laipsnis=char(orders(1));      
nnn=strfind(auksciausias_x_laipsnis,'^');
n=str2num(auksciausias_x_laipsnis(nnn+1:end))  % auksciausias x laipsnio rodiklis daugianaryje (daugianario eile)

[CF1_neig,orders_neig]=coeffs(fneig,x) % daugianario fneig koeficientai ir juos atitinkantys x laipsniai

% suformuojama visu x laipsniu eile: 
for i=1:n+1, orders_full(i)=x^(n-i+1); end
orders

% koeficientu eile papildoma nuliniais nariais:
for i=1:n+1
    j=find(orders == orders_full(i));
    if j>0, CF(i)=CF1(j); 
            CF_neig(i)=CF1_neig(j);
    else,   CF(i)=0;
            CF_neig(i)=0; 
    end
end

% koeficientas prie auksciausio x laipsnio turi buti teigiamas:
CF=CF/CF(1);  % f(x) koeficientai 
CF_neig=CF_neig/CF_neig(1);  % f(-x) koeficientai
CF,CF_neig

% Saknu intervalo iverciai:

% ------------- Grubus ivertis:
CF_value=eval(CF)  % f(x) koeficientu simboliai paverciami skaiciais
R=max(abs(CF_value(2:end)))/CF_value(1)+1  % taikoma grubaus ivercio formule 

% grafinis funkcijos, saknu ir grubaus ivercio intervalo pavaizdavimas:
t=-R:R/500:R;
figure(1);grid on;hold on
plot(t,fnk(CF_value,t),'g-')
if option == 1, plot(saknys,0*saknys,'go');end
plot([-R,R],[0 0],'r*')

% ------------ Tikslesnis ivertis:
% teigiamoms saknims:

neig_ind=find(CF_value(2:end) < 0)
if ~isempty(neig_ind)
    B=max(abs(CF_value(neig_ind+1)))
    k=neig_ind(1)
    Rteig=1+(B/CF_value(1))^(1/k)
else
    Rteig=0
end
plot(min(R,Rteig),0,'bp') % pavaizduojamas teigiamu saknu virsutines ribos ivertis 

% neigiamoms saknims: 
CF_value_neig=eval(CF_neig)  % f(-x) koeficientu simboliai paverciami skaiciais
neig_ind1=find(CF_value_neig(2:end) < 0)
if ~isempty(neig_ind1)
    B=max(abs(CF_value_neig(neig_ind1+1)))
    k=neig_ind1(1)
    Rneig=1+(B/CF_value_neig(1))^(1/k)
else
    Rneig=0
end

plot(-min(R,Rneig),0,'bp')
switch option, case 1, legend('kreive f(x)','f(x)=0 saknys','grubus saknu intervalo ivertis','tikslesnis saknu intervalo ivertis');
               case 2,   legend('kreive f(x)','grubus saknu intervalo ivertis','tikslesnis saknu intervalo ivertis');
end
title([char(f),'=0'])

end

function p=fnk(CF,x)
% Apskaiciuoja daugianario reiksmes, kai argumentas yra x
% Kai x yra reiksmiu vektorius, p taip pat yra atitinkamu funkcijos reiksmiu vektorius
    p=0; n=length(CF)-1;
    for i=1:length(CF),  p=p+CF(i)*x.^(n-i+1);  end  % veiksmas < .^ > reiskia, kad laipsniu keliami visi vektoriaus x elementai  
return
end