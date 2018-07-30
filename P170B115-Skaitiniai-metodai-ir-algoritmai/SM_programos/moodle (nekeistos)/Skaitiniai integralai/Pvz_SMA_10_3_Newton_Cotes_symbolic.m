clc,clear all
syms dx x G base

N=9 % didziausias integravimo formules tasku skaicius

for i=2:N
    base(1)=sym(1);  for j=2:i, base(i)=sym(x^(i-1)); end
    base
    for j=1:i
        base1=subs(base,x,sym((j-1)*dx));
        G(j,1:i)=base1(1,1:i);
    end
    G
    fprintf(1,'%d eiles skaitinio integravimo formule',i-1);
    int(base,sym(0),sym((i-1)*dx))*inv(G)/dx
    
end