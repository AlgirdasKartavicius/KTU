function Niutonas_artiniai_tinklelis
clc,close all
    scrsz = get(0,'ScreenSize');
    itmax=100;
    alpha=0.25;   %0.9   %0.8; %  0.5   % zingsnio sumazinimo koeficientas
    warning off;
    artinys=[-10:0.1:10];y=[-10:0.1:10];
    Z=pavirsius(@f,artinys,y);
    fig1=figure(1);set(fig1,'Position',[50 scrsz(4)/1.8 scrsz(3)/3 scrsz(4)/3],'Color','w');
    hold on,axis equal,axis([min(artinys) max(artinys) min(y) max(y)]);view([0 0 1]);xlabel('x'),ylabel('y');
    contour(artinys,y,Z(:,:,1)',[0 0],'LineWidth',1.5, 'DisplayName', 'exp(-(((x(1)+2)^2) + 2*x(2)^2)/4) - 0.1')
    contour(artinys,y,Z(:,:,2)',[0 0],'b-', 'LineWidth',1.5, 'DisplayName', 'x(1)^2*x(2)^2 + x(1) - 8')
    %     ----------------------------------------------
    %     Ðaknø paieðka naudojant fsolve (reikalinga legendai sudaryti)
    artiniai=[-2 2; -2 -2; -5 -1; -5 1];
    zymekliai=['gp'; 'yp'; 'bp'; 'rp'];
    options=optimset('Jacobian', 'on');
    [rows, columns] = size(artiniai); 
    for i=1:rows
        [root]=fsolve(@fjx, [artiniai(i,1) artiniai(i, 2)], options);
        plot(root(1), root(2), zymekliai(i, :), 'LineWidth', 4, 'DisplayName',mat2str(root));
    end
%     Pieðiama uþ plokðtumos atvaizdavimo ribø, kad nesimatytø
    plot(-15,-15,'k.', 'DisplayName', 'Nekonverguoja');
    legend('show');
    %     ----------------------------------------------
    eps=1e-9; %tikslumas
    for x=-10:0.25:10
        for y=-10:0.25:10
            artinys=[x;y];
            ff=f(artinys); 
            dff=df(artinys);
            plot(x,y,'k.', 'MarkerSize',10)
            for iii=1:itmax  
                dff=df(artinys); 
                deltax=-dff\ff; 
                x1=artinys+alpha*deltax; 
                ff1=f(x1);
                tikslumas = norm(f(artinys));
                if (tikslumas < eps)
                    if (abs(artinys(1)) < 2)
                        if (artinys(2) > 0)
                            plot(x,y,'g.', 'MarkerSize',10)
                        else
                            plot(x,y,'y.', 'MarkerSize',10)
                        end
                    else
                        if (artinys(2) > 0)
                            plot(x,y,'r.', 'MarkerSize',10)
                        else
                            plot(x,y,'b.', 'MarkerSize',10)
                        end
                    end
                    break;
                end
                artinys=x1;
                ff=ff1;    
            end
        end
    end
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
    
    % Funkcija, skirta ðaknø suradimui su fsolve
function [F, J]=fjx(x)
    F=[exp(-(((x(1)+2)^2) + 2*x(2)^2)/4) - 0.1;...
        x(1)^2*x(2)^2 + x(1) - 8];
    if nargout > 1
    J=[-exp(-(x(1)+ 2)^2/4-x(2)^2/2)*(x(1)/2+1), ...
          -x(2)*exp(-(x(1)+2)^2/4-x(2)^2/2);...
          2*x(1)*x(2)^2+1, 2*x(1)^2*x(2) ];
    end
end
