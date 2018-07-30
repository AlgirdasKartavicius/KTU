function L2_1_1
    clc, close all, clear all;
    format long;
    atvaizdavimas = 0; % funkcij� atvaizdavimo formatas 0 - viskas viename lange, 1 - dviejuose languose
    f=@(x)log(x)./(sin(2*x)+2.5);
    f_sym = 'ln(x)/(sin(2x)+2.5)';
    a = 2;
    b = 10;
    n = 9;  % ta�k� skai�ius
    X = a:(b-a)/(n-1):b; % tolygiai pasiskirs�i�si� ta�k� abscis�s
    i = 0:n-1;
    XC = (b-a)/2*cos(pi*(2*i+1)/(2*n)) + (b+a)/2; % �ioby�evo abscis�s
    x = min(X):(max(X)-min(X))/1000:max(X); % vaizdavimui skirtos x reik�m�s
    M = ones(n);
    MC = ones(n);
%     M matricos skai�iavimas (eilut�je - vieno ta�ko x^0, x^1... x^(n-1).)
    for j=2:n
        for k=1:n
            M(k,j) = X(k).^(j-1);
            MC(k,j) = XC(k).^(j-1);
        end
    end
    A = M\f(X).'   % vienanari� baz�s koeficient� reik�m�s, kai ta�kai pasiskirst� tolygiai
    AC = MC\f(XC).'; % vienanari� baz�s koeficient� reik�m�s, kai ta�k� abscis�s - �ioby�evo
    p = poly2sym(fliplr(A.'))
    pc = poly2sym(fliplr(AC.'))
    Y = [];
    YC = [];
    Y_NET = [];
    YC_NET = [];
%     Ciklas, pagal gautus koeficientus, skai�iuoja ta�k� ordinates
%     kiekviename funkcijos vaizdavimo ta�ke bei skai�iuojama kiekvieno
%     ta�ko netiktis
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
%     Funkcij� grafik� atvaizdavimas, kur 0 - viskas viename lange, 1 -
%     dviejuose languose (viename tolygiai pasiskirst� ta�kai, kitame -
%     ta�kai, pasiskirst� pagal �ioby�evo abscises)
    if atvaizdavimas == 0
%             Atvaizdavimas viename lange (vienas langas)
        leg={['Duotoji funkcija: ', f_sym],...
            'Tolygiai pasiskirst� ta�kai',...
            'Interpoliavimas per tolygiai pasiskirs�iusius ta�kus',...
            'Netiktis interpoliuojant per tolygiai pasiskirs�iusius ta�kus',...
            'Ta�kai pagal �ioby�evo abscises',...
            'Interpoliavimas per �ioby�evo abscisi� ta�kus',...
            'Netiktis interpoliuojant per �ioby�evo abscisi� ta�kus'};
        figure(1), hold on, grid on; 
        title(['Interpoliavimas, kai ta�k� skai�ius = ', num2str(n)]);
        plot(x,f(x),'k-'); % duotoji funkcija
        plot(X,f(X),'bo','MarkerFaceColor','b','MarkerSize',6); % tolygiai pasiskirst� ta�kai
        plot(x, Y, 'b-'); % interpoliavimas per tolygiai pasiskirs�iusius ta�kus
        plot(x,Y_NET,'b--'), % netiktis interpoliuojant per tolygiai pasiskirs�iusius ta�kus
        plot(XC, f(XC),'ro','MarkerSize',8) % ta�kai pagal �ioby�evo abscises
        plot(x, YC, 'r-'); % interpoliavimas per �ioby�evo abscisi� ta�kus
        plot(x,YC_NET,'r--'), % netiktis interpoliuojant per �ioby�evo abscisi� ta�kus
        legend(leg, 'Location', 'northwest');
    elseif atvaizdavimas == 1
%             Atvaizdavias atskiruose grafikuose (2 langai)
        leg1={['Duotoji funkcija: ', f_sym],...
            'Tolygiai pasiskirst� ta�kai',...
            'Interpoliavimas per tolygiai pasiskirs�iusius ta�kus',...
            'Netiktis interpoliuojant per tolygiai pasiskirs�iusius ta�kus'};
        leg2={'Duota funkcija',...,
            'Ta�kai pagal �ioby�evo abscises',...
            'Interpoliavimas per �ioby�evo abscisi� ta�kus',...
            'Netiktis interpoliuojant per �ioby�evo abscisi� ta�kus'};
        figure(1), hold on, grid on;
        title(['Interpoliavimas, kai ta�k� skai�ius = ', num2str(n), '. Ta�kai pasiskirst� tolygiai.']);
        plot(x,f(x),'k-'); % duotoji funkcija
        plot(X,f(X),'bo','MarkerFaceColor','b','MarkerSize',6); % tolygiai pasiskirst� ta�kai
        plot(x, Y, 'b-'); % interpoliavimas per tolygiai pasiskirs�iusius ta�kus
        plot(x,Y_NET,'b--'), % netiktis interpoliuojant per tolygiai pasiskirs�iusius ta�kus
        legend(leg1, 'Location', 'northwest');
        figure(2), hold on, grid on;
        title(['Interpoliavimas, kai ta�k� skai�ius = ', num2str(n), '. Ta�kai pasiskirst� pagal �ioby�evo abscises.']);
        plot(x,f(x),'k-'); % duotoji funkcija
        plot(XC, f(XC),'ro','MarkerSize',8) % ta�kai pagal �ioby�evo abscises
        plot(x, YC, 'r-'); % interpoliavimas per �ioby�evo abscisi� ta�kus
        plot(x,YC_NET,'r--'), % netiktis interpoliuojant per �ioby�evo abscisi� ta�kus
        legend(leg2, 'Location', 'northwest');
    else
        disp('Funkcij� atvaizdavimo pasirinkimas netinkamas');
    end
end