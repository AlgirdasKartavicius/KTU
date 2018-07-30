% Apskaiciuoja Gauso-Lezandro formuliu integravimo taskus ir svorio
% koeficientus

clc,clear all
format long
syms x G base

N=2 % integravimo formules tasku skaicius (tikslumo eile bus 2*N-1)

% baziniai vienanariai
base(1)=sym(1);  for j=2:2*N, base(j)=sym(x^(j-1)); end
fprintf(1,'%s',char(base))


% Vienanariu integralai("momentai"):
m=int(base,-1,1)

for i=1:N,  A(i,1:N)=m(i:i+N-1); end  % L.s.matrica
A
b=-m(N+1:2*N)'  % L.s. desines puses vektorius
c=A\b
coef=[1,c([N:-1:1])'] % Lezandro daugianario koeficientai 
% optimalus integravimo taskai 
xx=sort(roots(eval(coef)))
fprintf(1,' %18.16g ',xx)

% Svorio koeficientu apskaiciavimas

    for j=1:N
        % Lagranzo daugianaris:
        L=1;  for k=1:N, if k ~= j, L=L*(x-xx(k))/(xx(j)-xx(k)); end, end
        w(j)=int(L,sym(-1),sym(1)); % Lagranzo daugianario integralas 
    end
    fprintf(1,'\n \n optimalus integravimo taskai:\n ')
    fprintf(1,' %18.16g ',xx)
    fprintf(1,'\nsvorio koeficientai:\n ')
    fprintf(1,' %18.16g ',eval(w))

