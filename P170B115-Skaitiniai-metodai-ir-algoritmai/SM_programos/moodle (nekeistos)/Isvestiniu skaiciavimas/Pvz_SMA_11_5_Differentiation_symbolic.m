% Skaitinio diferencijavimo formuliu isvedimas
clc,clear all
syms dx x L a

N=9 % didziausias diferencijavimo formules tasku skaicius
for i=3:2:N
    fprintf(1,'******************************    N=%d\n',i)
    xx=[a:dx:a+(i-1)*dx]
    for j=1:i
        % Lagranzo daugianaris:
        L=1;
        for k=1:i, if k ~= j, L=L*(x-xx(k))/(xx(j)-xx(k)); end, end
        dL(j)=diff(L,x);
    end
    fprintf(1,'\nDiferencijavimo formules:');
    for j=1:i, 
        DL(j,1:i)=subs(dL,x,a+(j-1)*dx);
        fprintf(1,'\n%s',[char(DL(j,1:i)*((i-1)*dx)),sprintf('/(%d*dx)',i-1)]);
%         fprintf(1,'\n%s',char(DL(j,1:i)*((i-1)*dx)));
    end
    fprintf(1,'\n')

end