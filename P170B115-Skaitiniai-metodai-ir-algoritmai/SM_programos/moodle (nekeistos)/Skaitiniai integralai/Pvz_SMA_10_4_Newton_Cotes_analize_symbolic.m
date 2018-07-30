
% Tikrinama iki kokio daugianario laipsnio integravimo formules
% yra tikslios 

clc,clear all
syms dx x G base

N=5 % didziausias integravimo formules tasku skaicius
NN=2*N-1 % didziausias tiriamo daugianario laipsnis
for i=2:N
    ii=2*i-1;
    fprintf(1,'\n\n\n integravimo tasku skaicius %d ',i);
    base(1)=sym(1);  for j=2:ii, base(j,1)=sym(x^(j-1)); end
    fprintf(1,'\n bazines funkcijos:\n ')
    fprintf(1,'%s ',char(base))
    for j=1:i
        base1=subs(base,x,sym((j-1)*dx));
        G(1:ii,j)=base1(1:ii);
    end
%     G
    fprintf(1,'\n')
    m=int(base,sym(0),sym((i-1)*dx));
    fprintf(1,'integralu reiksmes:\n ')
    fprintf(1,'%s ',char(m))
    fprintf(1,'\n %d eiles skaitinio integravimo formules koeficientai:',i-1);
    w=inv(G(1:i,1:i))*m(1:i)/dx;
    fprintf(1,'%s ',char(w));
    
    fprintf(1,'\n Patikrinimas su isplesta baziniu funkciju aibe\n')
    fprintf(1,'%s ',char(G*w*dx-m))
    
end