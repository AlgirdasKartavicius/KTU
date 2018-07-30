function Grafinis_sprendimas
    clc, close all, clear all;
   
    x=[-10:0.1:10];
    y=[-10:0.1:10];
    Z=pavirsius(@f,x,y);
    figure(1),hold on,grid on,axis equal,axis([min(x) max(x) min(y) max(y) 0 5]);view([1 1 1]);
    xlabel('x'),ylabel('y');
    mesh(x,y,Z(:,:,1)','FaceAlpha',0.2);contour(x,y,Z(:,:,1)',[0,0],'LineWidth',1.5);
    xx=axis;
    fill([xx(1),xx(1),xx(2),xx(2)],[xx(3),xx(4),xx(4),xx(3)],'c','FaceAlpha',0.2);

    figure(2),hold on,grid on,axis equal,axis([min(x) max(x) min(y) max(y) 0 5]);view([1 1 1]);
    xlabel('x'),ylabel('y')
    mesh(x,y,Z(:,:,2)','FaceAlpha',0.2);contour(x,y,Z(:,:,2)',[0 0],'LineWidth',1.5)
    xx=axis;
    fill([xx(1),xx(1),xx(2),xx(2)],[xx(3),xx(4),xx(4),xx(3)],'b','FaceAlpha',0.2);
    
    figure(3),hold on,grid on,axis equal
    title('Sprendimas grafiniu bûdu');
    contour(x,y,Z(:,:,1)',[0 0],'LineWidth',1.5, 'DisplayName', 'exp(-(((x(1)+2)^2) + 2*x(2)^2)/4) - 0.1')
    contour(x,y,Z(:,:,2)',[0 0],'b-', 'LineWidth',1.5, 'DisplayName', 'x(1)^2*x(2)^2 + x(1) - 8')
    
    xlabel('x'),ylabel('y')
    
%     Ðaknø paieðka naudojant fsolve
    artiniai=[-2 2; -2 -2; -5 -1; -5 1];
    zymekliai=['ro'; 'co'; 'yo'; 'ko'];
    options=optimset('Jacobian', 'on');
    [rows, columns] = size(artiniai); 
    for i=1:rows
        [root]=fsolve(@fjx, [artiniai(i,1) artiniai(i, 2)], options)
        plot(root(1), root(2), zymekliai(i, :), 'LineWidth', 2, 'DisplayName',mat2str(root));
    end
    legend('show');
    return
end

%   Lygciu sistemos funkcija 
function fff=f(x)
    fff=[exp(-(((x(1)+2)^2) + 2*x(2)^2)/4) - 0.1;
        x(1)^2*x(2)^2 + x(1) - 8];
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