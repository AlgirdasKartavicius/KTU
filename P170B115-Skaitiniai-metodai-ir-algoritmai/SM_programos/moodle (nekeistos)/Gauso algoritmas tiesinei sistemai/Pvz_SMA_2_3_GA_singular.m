
% Gauso algoritmas su vedancio elemento parinkimu, kai matrica singuliari
% Randamas vienas sprendinys, parenkant laisvus kintamuosius =1
clc
fprintf(1,'koeficientu matrica :')
% A=[ 1  1  1  1;
%     1  1 -1  1;
%     1  1 -1  1;
%    -1 -1  1 -1]
A=[  1     1     1     1 ;
     1     1    -1     1 ;
     1     1    -2     4 ;
    -1     -1    1     4 ;
    ]
fprintf(1,'laisvuju nariu vektorius :')
% b=[2;7;14;-7] %  sprendiniu nera
b=[2;9.14286;14;-7] % be galo daug sprendiniu
n=size(A,1);  
fprintf(1,' Lygciu skaicius %d  \n',n);
fprintf(1,' matrica A ir vektorius b sublokuojami :')
A1=[A,b]

%  Naudojant A ir b atskirai, veiksmus su b atlikti pirma, kol dar nepakites A

fprintf(1,' *******    Tiesioginis zingsnis: ********** \n')
for i=1:n-1
    [a,iii]=max(abs(A1(i:n,i))); % parenkamas vedantis elementas:
        if a == 0, 
            fprintf(1,'!!!!!!  vedantis elementas = %g,  ciklas praleidziamas \n',a)
            continue 
        end
    fprintf(1,'vedantis elementas %g,  lygties nr. %d \n',a,iii+i-1)
        if iii > 1  % eilutes sukeiciamos vietomis
            fprintf(1,'eilutes sukeiciamos vietomis :')
            A1([i,i+iii-1],:)=A1([i+iii-1,i],:); 
            A1
        end
    for j=i+1:n,   A1(j,i:n+1)=A1(j,i:n+1)-A1(i,i:n+1)*A1(j,i)/A1(i,i);    end
    fprintf(1,'vedanciojo elemento eilute atimama is zemiau esanciu :')
    A1
    input('Press Enter')
end

fprintf(1,' *******    Atvirkstinis zingsnis: ********** \n')
x=zeros(n,1);
eps=1e-5;
 
for i=n:-1:1
    rrr=A1(i,n+1)-A1(i,i+1:n)*x(i+1:n);
    if A1(i,i) == 0 && abs(rrr)<eps,
          x(i)=1;
          fprintf(1,'\n>>>>>> rrr=%g;   Kintamasis x(%d) gali buti bet koks skaicius\n',rrr,i)
          fprintf(1,'>>>>>>  Priimame x(%d)=1\n',i)
    elseif A1(i,i) == 0 && abs(rrr)> eps,
        fprintf(1,'\n >>>>  kintamasis x(%d),   rrr=%g \n',i,rrr);
        fprintf(1,'\n >>>>  sprendiniu nera \n');
        return
    else
    x(i)=rrr/A1(i,i);
    fprintf(1,'\n x(%d)=%g %g %g %g',i,x(i))
    end
end

disp('sprendinys x='),x
disp('sprendinio patikrinimas:'),liekana=A*x-b
disp('bendra santykine paklaida:'),disp(norm(liekana)/norm(x))