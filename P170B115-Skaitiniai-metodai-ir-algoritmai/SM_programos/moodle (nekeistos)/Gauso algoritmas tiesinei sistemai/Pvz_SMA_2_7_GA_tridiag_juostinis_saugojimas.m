
% Gauso algoritmas triju istrizainiu matricai, saugant juostiniu pavidalu
clc
% koeficientu matricos staciakampis pavidalas:
A=[ 1 -1  0  0  0  0  0;
   -1  2 -1  0  0  0  0;
    0 -1  2 -1  0  0  0;
    0  0 -1  2 -1  0  0;
    0  0  0 -1  2 -1  0;
    0  0  0  0 -1  2 -1;
    0  0  0  0 0  -1  2;]
b=[2;0;0;0;0;0;0]
n=size(A,1)


% koeficientu matricos juostinis pavidalas
Ar=zeros(n,3);
for i=1:n
    if i == 1, Ar(1,2:3)=A(i,1:2);
    elseif i == n, Ar(n,1:2)=A(n,n-1:n);
    else, Ar(i,1:3)=A(i,i-1:i+1);
    end
end
Ar

A1=[Ar,b]  % matrica ir laisvuju nariu vektorius sublokuojami

% Gauso algoritmo tiesioginis etapas:
for i=1:n-1
       A1(i+1,[2,4])=A1(i+1,[2,4])-A1(i,[3,4])*A1(i+1,1)/A1(i,2);
       A1(i+1,1)=0;
       A1
end

% Gauso algoritmo atvirkstinis etapas:

x=zeros(n,1);
x(n)=A1(n,4)/A1(n,2);
for i=n-1:-1:1
    x(i)=(A1(i,4)-A1(i,3)*x(i+1))/A1(i,2);
end

disp('sprendinys x='), x
disp('sprendinio patikrinimas:'), liekana=A*x-b
disp('bendra santykine paklaida:'),disp(norm(liekana)/norm(x))
