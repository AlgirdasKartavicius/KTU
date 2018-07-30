
% Integravimo svoriu apskaiciavimas Lagranzo daugianariu integralais

clc,clear all
syms dx x L a

N=9 % didziausias integravimo formules tasku skaicius
for i=2:N
    for j=1:i
        % Lagranzo daugianaris:
        xx=[a:dx:a+(i-1)*dx];  % taskai kas dx 
        L=1;
        for k=1:i, if k ~= j, L=L*(x-xx(k))/(xx(j)-xx(k)); end, end
        coef(j)=int(L,sym(xx(1)),sym(xx(i))); % Lagranzo daugianario integralas 
    end
    coef/dx
end
