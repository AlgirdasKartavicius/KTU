
% QR-algoritmas singuliari matrica

clc
% Singuliari matrica
A=[  1     1     1     1 ;
     1     1    -1     1 ;
     1     1    -2     4 ;
    -1     -1    1     4 ;
    ]
fprintf(1,'laisvuju nariu vektorius :')
b=[2;9.14286;14;-7] % be galo daug sprendiniu

n=size(A,1),  nb=size(b,2)
A1=[A,b]

disp(' tiesioginis zingsnis(atspindziai)')
for i=1:n-1
    z=A1(i:n,i);
    zp=zeros(size(z));
    zp(1)=sign(z(1))*norm(z);
    omega=(z-zp); 
    if norm(omega) < eps, continue, end 
    omega=omega/norm(omega);
    Q=eye(n-i+1)-2*omega*omega'
    A1(i:n,:)=Q*A1(i:n,:)
end

x=A1(:,n+1:end);

fprintf(1,' *******    Atvirkstinis zingsnis: ********** \n')
x=zeros(n,1);
eps=1e-5;
if A1(n,n+1)==0 && abs(A1(n,n)) < eps
   x(n)=1;
   fprintf(1,'>>>>>>  Kintamasis x(%d) gali buti bet koks skaicius\n',n)
   fprintf(1,'>>>>>>  Priimame x(%d)=1\n',n)
elseif A1(n,n+1)~=0 && abs(A1(n,n)) < eps
   fprintf(1,'>>>>  sprendiniu nera');
   return
else
    x(n)=A1(n,n+1)/A1(n,n);
end
fprintf(1,'\n x(%d)= %g %g %g %g ',n,x(n))
 
for i=n-1:-1:1
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

fprintf(1,' sprendinys: \n');
x

fprintf(1,' sprendinio patikrinimas \n');
A*x-b
