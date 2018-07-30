
% Gauso algoritmas triju istrizainiu matricai, saugant staciakampiu pavidalu
clc
A=[ 1 -1  0  0;
   -1  2 -1  0;
    0 -1  2 -1;
    0 0  -1  2]
b=[2;0;0;0]
n=size(A,1)
A1=[A,b]  % matrica ir laisvuju nariu vektorius sublokuojami

%  Naudojant A ir b atskirai, veiksmus su b atlikti pirma, kol dar nepakites A

% Gauso algoritmo tiesioginis etapas:
for i=1:n-1
       A1(i+1,[i+1,n+1])=A1(i+1,[i+1,n+1])-A1(i,[i+1,n+1])*A1(i+1,i)/A1(i,i);
       A1(i+1,i)=0;
       A1
end

% Gauso algoritmo atvirkstinis etapas:
x=zeros(n,1);
x(n)=A1(n,n+1)/A1(n,n);
for i=n-1:-1:1
    x(i)=(A1(i,n+1)-A1(i,i+1)*x(i+1))/A1(i,i);
end

disp('sprendinys x='), x
disp('sprendinio patikrinimas:'), liekana=A*x-b
disp('bendra santykine paklaida:'),disp(norm(liekana)/norm(x))