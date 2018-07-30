
% Gauso algoritmas
clc
A=[1  1  1  1;
   1 -1 -1  1;
   2  1 -1  2;
   3  1  2 -1]
b=[2;0;9;7]
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
