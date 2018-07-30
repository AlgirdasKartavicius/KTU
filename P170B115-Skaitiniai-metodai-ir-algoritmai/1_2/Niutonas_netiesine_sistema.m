function Niutonas_netiesine_sistema
    clc,close all;
    format long;
    scrsz = get(0,'ScreenSize');
%     --------------------------------------------------------------
%     Paèiame sprendime nanaudojami dalykai, bet reikalinga, norint
%     susidaryti Jakobio matricà, kai jà apskaièiuoja MATLAB
    syms x y
    f1 = exp(-(((x+2)^2) + 2*y^2)/4) - 0.1;
    f2 = x^2*y^2 + x - 8;
    Jakobio_Matrica=[diff(f1, 'x'), diff(f1, 'y'); diff(f2, 'x'), diff(f2, 'y')]
%     --------------------------------------------------------------
    x=[-10:0.1:10];y=[-10:0.1:10];
    Z=pavirsius(@f,x,y);
    % [left, bottom, width, height]
    fig1=figure(1);set(fig1,'Position',[50 scrsz(4)/1.8 scrsz(3)/3 scrsz(4)/3],'Color','w');
    hold on,grid on,axis equal,axis([min(x) max(x) min(y) max(y) 0 5]);view([0 0 1]);xlabel('x'),ylabel('y');
    mesh(x,y,Z(:,:,1)','FaceAlpha',0.2,'FaceColor','r','EdgeColor','r');
    contour(x,y,Z(:,:,1)',[0 0],'LineWidth',1.5,'LineColor','r');
    mesh(x,y,Z(:,:,2)','FaceAlpha',0.2,'FaceColor','b','EdgeColor','b');
    contour(x,y,Z(:,:,2)',[0 0],'LineWidth',1.5,'LineColor','b');
    xx=axis; fill([xx(1),xx(1),xx(2),xx(2)],[xx(3),xx(4),xx(4),xx(3)],'b','FaceAlpha',0.2);
    contour(x,y,Z(:,:,1)',[0 0],'LineWidth',1.5, 'DisplayName', 'exp(-(((x(1)+2)^2) + 2*x(2)^2)/4) - 0.1')
    contour(x,y,Z(:,:,2)',[0 0],'b-', 'LineWidth',1.5, 'DisplayName', 'x(1)^2*x(2)^2 + x(1) - 8')
    eps=1e-9;
    itmax=100;
    x=[-3; 1]  % pradinis artinys
    ff=f(x); dff=df(x);
    figure(1);plot3(x(1),x(2),0,'b*');line([x(1),x(1)],[x(2),x(2)],[0,ff(1)],'Color','black');
    alpha=0.5   %0.9   %0.8; %  0.5   % zingsnio sumazinimo koeficientas

    for iii=1:itmax
        pause;
        dff=df(x);
        deltax=-dff\ff; 
        x1=x+alpha*deltax; 
        ff1=f(x1);
        figure(1);plot3(x1(1),x1(2),0,'g*');
        line([x(1),x1(1)],[x(2),x1(2)],[0,0],'Color','magenta');
        line([x(1),x1(1)],[x(2),x1(2)],[ff(1),0*ff1(1)],'Color','green','LineWidth',2.5);
        line([x1(1),x1(1)],[x1(2),x1(2)],[0,ff1(1)],'Color','black');
        tikslumas=norm(f(x));
        fprintf(1,'\n iteracija %d  tikslumas %g',iii,tikslumas);
        if tikslumas < eps, fprintf(1,'\n sprendinys x ='); fprintf(1,' %g  ',x);plot3(x(1),x(2),0,'gp'); break;        elseif iii == itmax,fprintf(1,'\n ****tikslumas nepasiektas. Paskutinis artinys x =  %g',x'); plot3(x(1),x(2),0,'gp'); break;
        
        end
        x=x1;
        ff=ff1;    
    end
    x
    fprintf(1,'\n');  
    return
end

%   Lygciu sistemos funkcija 
    function fff=f(x)
        fff=[exp(-(((x(1)+2)^2) + 2*x(2)^2)/4) - 0.1;
            x(1)^2*x(2)^2 + x(1) - 8];
        return
    end
    
%  Jakobio matrica
    function dfff=df(x)
        dfff=[-exp(- (x(1) + 2)^2/4 - x(2)^2/2)*(x(1)/2 + 1), ...
              -x(2)*exp(- (x(1) + 2)^2/4 - x(2)^2/2);
               2*x(1)*x(2)^2 + 1, 2*x(1)^2*x(2)];
        return
    end
    
    function Z=pavirsius(funk,x,y)
        for i=1:length(x)
            for j=1:length(y)
                Z(i,j,1:2)=funk([x(i),y(j)]);
            end
        end
        return
    end