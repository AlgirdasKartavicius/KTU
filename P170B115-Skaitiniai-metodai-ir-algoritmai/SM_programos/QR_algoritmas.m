
% Pvz_SMA_3_1_Hausholderio_atspindziu(QR)_algoritmas

clc,clear all
A=[3  8  3  4;
   2  6  7  9;
   4  6  5  1;
   1  2 -6 -5]
b=[2;3;-2;-1]

n=size(A,1),  nb=size(b,2)
A1=[A,b]

disp(' tiesioginis zingsnis(atspindziai)')
for i=1:n-1
    z=A1(i:n,i)
    zp=zeros(size(z)) 
    zp(1)=norm(z)
    omega=(z-zp)  
    omega=omega/norm(omega)
    Q=eye(n-i+1)-2*omega*omega'
    A1(i:n,:)=Q*A1(i:n,:)
end

% Atvirkstinis zingsnis

x=zeros(n,nb);
for i=n:-1:1
    x(i,:)=(A1(i,n+1:end)-A1(i,i+1:n)*x(i+1:n,:))/A1(i,i);
end


disp('sprendinys x='),x'
disp('sprendinio patikrinimas:'),liekana=(A*x-b)'
disp('bendra santykine paklaida:'),disp(norm(liekana)/norm(x))
