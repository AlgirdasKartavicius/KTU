
% Gauso algoritmas
clc
A=[3  8  3  4;
   2  6  7  9;
   4  6  5  1;
   1  2 -6 -5]
b=[2;3;-2;-1]
% b=[2 1;0  2;9 3;7 3]
n=size(A,1),  nb=size(b,2)
A1=[A,b]

%  Naudojant A ir b atskirai, veiksmus su b atlikti pirma, kol dar nepakites A

% Gauso algoritmo tiesioginis etapas:
for i=1:n-1
    for j=i+1:n,
        A1(j,i+1:n+nb)=A1(j,i+1:n+nb)-A1(i,i+1:n+nb)*A1(j,i)/A1(i,i);
        A1(j,i)=0;   
    end
    A1
end

% Gauso algoritmo atvirkstinis etapas:
x=zeros(n,nb);
for i=n:-1:1
    x(i,:)=(A1(i,n+1:end)-A1(i,i+1:n)*x(i+1:n,:))/A1(i,i);
end

disp('sprendinys x='),x
disp('sprendinio patikrinimas:'),liekana=A*x-b
disp('bendra santykine paklaida:'),disp(norm(liekana)/norm(x))

% syms x1 x2 x3 x4
% eq1 = 3*x1 + 8*x2 + 3*x3 + 4*x4 == 2;
% eq2 = 2*x1 + 6*x2 + 7*x3 + 9*x4 == 3;
% eq3 = 4*x1 + 6*x2 + 5*x3 + x4 == -2;
% eq4 = 1*x1 + 2*x2 - 6*x3 - 5*x4 == -1;
% sol = solve([eq1, eq2, eq3, eq4], [x1, x2, x3, x4]);

X = linsolve(A, b)



