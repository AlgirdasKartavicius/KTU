% Niutono metodas su simboliniu diferencijavimu

function Niutonas_4_lygtys
clc,close all
syms x1 x2 x3 x4
format long;
 X=[x1; x2; x3; x4];
 F(1)=X(2)-2*X(3)+3*X(4)-10;
 F(2)=3*X(1)*X(3)-X(1)+40;
 F(3)=2*X(2)^3-X(2)^2-4*X(3)^2+35;
 F(4)=3*X(1)-3*X(2)-9;


eps=1e-10
itmax=100
x=[-10;-8;-8;-5];
fun = @f;
fsolved = fsolve(fun,x)
 F=F(:);
 DF=jacobian(F,X);
 for iii=1:itmax
     deltax=-eval(subs(DF,X,x))\eval(subs(F,X,x));
     x=x+deltax;
     tikslumas = norm(f(x));
%                     fprintf(1,'\n iteracija %d  tikslumas %g',iii,tikslumas);
    if tikslumas < eps
         fprintf(1,'\n sprendinys x =');    fprintf(1,'  %g',x);    fprintf(1,'\n funkcijos reiksmes f =');
         fprintf(1,'  %g',eval(subs(F,X,x)));
         iii
         tikslumas
         break
     elseif iii == itmax
         fprintf(1,'\n ****tikslumas nepasiektas. Paskutinis artinys x =');    fprintf(1,'  %g',x);
%                         fprintf(1,'\n funkcijos reiksmes f =');    fprintf(1,'  %g',eval(subs(F,X,x)));
         break
     end
 end
 x

fprintf(1,'\n');

    return
end

 function Ff=f(X)
 Ff(1)=X(2)-2*X(3)+3*X(4)-10;
   Ff(2)=3*X(1)*X(3)-X(1)+40;
   Ff(3)=2*X(2)^3-X(2)^2-4*X(3)^2+35;
   Ff(4)=3*X(1)-3*X(2)-9;
        return
    end