function L2_1_1
    clc, close all, clear all;
    format long;
    atvaizdavimas = 0; % funkcijø atvaizdavimo formatas 0 - viskas viename lange, 1 - dviejuose languose
    f=@(x)log(x)./(sin(2*x)+2.5);
    f_sym = 'ln(x)/(sin(2x)+2.5)';
    a = 2;
    b = 10;
    n = 9;  % taðkø skaièius
    X = a:(b-a)/(n-1):b; % tolygiai pasiskirsèiøsiø taðkø abscisës
    i = 0:n-1;
    XC = (b-a)/2*cos(pi*(2*i+1)/(2*n)) + (b+a)/2; % Èiobyðevo abscisës
    x = min(X):(max(X)-min(X))/1000:max(X); % vaizdavimui skirtos x reikðmës
    M = ones(n);
    MC = ones(n);
%     M matricos skaièiavimas (eilutëje - vieno taðko x^0, x^1... x^(n-1).)
    for j=2:n
        for k=1:n
            M(k,j) = X(k).^(j-1);
            MC(k,j) = XC(k).^(j-1);
        end
    end
    A = M\f(X).'   % vienanariø bazës koeficientø reikðmës, kai taðkai pasiskirstæ tolygiai
    AC = MC\f(XC).'; % vienanariø bazës koeficientø reikðmës, kai taðkø abscisës - Èiobyðevo
    p = poly2sym(fliplr(A.'))
    pc = poly2sym(fliplr(AC.'))
    Y = [];
    YC = [];
    Y_NET = [];
    YC_NET = [];
%     Ciklas, pagal gautus koeficientus, skaièiuoja taðkø ordinates
%     kiekviename funkcijos vaizdavimo taðke bei skaièiuojama kiekvieno
%     taðko netiktis
    for j=1:numel(x)
        y = 0;
        yc = 0;
        for k=1:n
            y = y + x(j)^(k-1)*A(k);
            yc = yc + x(j)^(k-1)*AC(k);
        end
        Y = [Y; y];
        YC = [YC; yc];
        Y_NET = [Y_NET; f(x(j))-y];
        YC_NET = [YC_NET; f(x(j))-yc];
    end
%     Funkcijø grafikø atvaizdavimas, kur 0 - viskas viename lange, 1 -
%     dviejuose languose (viename tolygiai pasiskirstæ taðkai, kitame -
%     taðkai, pasiskirstæ pagal Èiobyðevo abscises)
    if atvaizdavimas == 0
%             Atvaizdavimas viename lange (vienas langas)
        leg={['Duotoji funkcija: ', f_sym],...
            'Tolygiai pasiskirstæ taðkai',...
            'Interpoliavimas per tolygiai pasiskirsèiusius taðkus',...
            'Netiktis interpoliuojant per tolygiai pasiskirsèiusius taðkus',...
            'Taðkai pagal Èiobyðevo abscises',...
            'Interpoliavimas per Èiobyðevo abscisiø taðkus',...
            'Netiktis interpoliuojant per Èiobyðevo abscisiø taðkus'};
        figure(1), hold on, grid on; 
        title(['Interpoliavimas, kai taðkø skaièius = ', num2str(n)]);
        plot(x,f(x),'k-'); % duotoji funkcija
        plot(X,f(X),'bo','MarkerFaceColor','b','MarkerSize',6); % tolygiai pasiskirstæ taðkai
        plot(x, Y, 'b-'); % interpoliavimas per tolygiai pasiskirsèiusius taðkus
        plot(x,Y_NET,'b--'), % netiktis interpoliuojant per tolygiai pasiskirsèiusius taðkus
        plot(XC, f(XC),'ro','MarkerSize',8) % taðkai pagal Èiobyðevo abscises
        plot(x, YC, 'r-'); % interpoliavimas per Èiobyðevo abscisiø taðkus
        plot(x,YC_NET,'r--'), % netiktis interpoliuojant per Èiobyðevo abscisiø taðkus
        legend(leg, 'Location', 'northwest');
    elseif atvaizdavimas == 1
%             Atvaizdavias atskiruose grafikuose (2 langai)
        leg1={['Duotoji funkcija: ', f_sym],...
            'Tolygiai pasiskirstæ taðkai',...
            'Interpoliavimas per tolygiai pasiskirsèiusius taðkus',...
            'Netiktis interpoliuojant per tolygiai pasiskirsèiusius taðkus'};
        leg2={'Duota funkcija',...,
            'Taðkai pagal Èiobyðevo abscises',...
            'Interpoliavimas per Èiobyðevo abscisiø taðkus',...
            'Netiktis interpoliuojant per Èiobyðevo abscisiø taðkus'};
        figure(1), hold on, grid on;
        title(['Interpoliavimas, kai taðkø skaièius = ', num2str(n), '. Taðkai pasiskirstæ tolygiai.']);
        plot(x,f(x),'k-'); % duotoji funkcija
        plot(X,f(X),'bo','MarkerFaceColor','b','MarkerSize',6); % tolygiai pasiskirstæ taðkai
        plot(x, Y, 'b-'); % interpoliavimas per tolygiai pasiskirsèiusius taðkus
        plot(x,Y_NET,'b--'), % netiktis interpoliuojant per tolygiai pasiskirsèiusius taðkus
        legend(leg1, 'Location', 'northwest');
        figure(2), hold on, grid on;
        title(['Interpoliavimas, kai taðkø skaièius = ', num2str(n), '. Taðkai pasiskirstæ pagal Èiobyðevo abscises.']);
        plot(x,f(x),'k-'); % duotoji funkcija
        plot(XC, f(XC),'ro','MarkerSize',8) % taðkai pagal Èiobyðevo abscises
        plot(x, YC, 'r-'); % interpoliavimas per Èiobyðevo abscisiø taðkus
        plot(x,YC_NET,'r--'), % netiktis interpoliuojant per Èiobyðevo abscisiø taðkus
        legend(leg2, 'Location', 'northwest');
    else
        disp('Funkcijø atvaizdavimo pasirinkimas netinkamas');
    end
end