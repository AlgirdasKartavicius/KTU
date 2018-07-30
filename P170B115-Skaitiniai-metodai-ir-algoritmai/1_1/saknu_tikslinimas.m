function saknu_tikslinimas
    clc, close all, clear all;
    format long;
    % ------------------------------------
    % Daugianaris f(x)
    f = @(x)x.^4+5*x.^3-2*x.^2-24*x;
    f_name = 'x^4+5x^3-2x^2-24x';
    % ------------------------------------
    % Funkcija g(x)
    g = @(x)sin(x).*log(x)-(x/6);
    g_name = 'sin(x)ln(x)-(x/6)';
    % ------------------------------------
    a = [1 5 -2 -24 0];
    n = numel(a);
    [R_grub, R_neig, R_teig]=Reziai(n, a);
    % ------------------------------------
    % ðaknø intervalø atskyrimas daugianariui f(x)
    % ------------------------------------
    zingsnis = 0.35; % zingsnio nustatymas
    [SaknuIntervalai_fx]=SkenavimasPastoviu(R_neig, R_teig, zingsnis, f);
    % ------------------------------------
    % REKURSINIS SKENAVIMAS (MAÞINANT ÞINGSNÁ)
    % ------------------------------------
    % ðaknø tikslinimas daugianariui f(x)
    % ------------------------------------
    disp( sprintf( '----------------------------------------------------'));
    disp( sprintf( 'Ðaknø tikslinimas skenavimo metodu, maþinant þingsná'));
    disp( sprintf( 'Daugianaris f(x)=x^4+5x^3-2x^2-24x'));
    disp( sprintf( '----------------------------------------------------'));
    disp( sprintf( 'Stulpeliø reikðmës:'));
    disp( sprintf( '1:2 - pradiniai ðaknø tikslinimo intervalai'));
    disp( sprintf( '3 - ðaknis'));
    disp( sprintf( '4 - tikslumas'));
    disp( sprintf( '5 - atliktø iteracijø kiekis'));
    disp( sprintf( '----------------------------------------------------'));
    Saknys_intervalai_fx = [];
    Tikslumai = [];
    Iteracijos = [];
    tikslumas = 1e-9;
    for i=1:length(SaknuIntervalai_fx)
        x_min = SaknuIntervalai_fx(i,1);
        x_max = SaknuIntervalai_fx(i, 2);
        if i == 1
            draw = 1;
            figure(1); grid on; hold on;
            npoints= 1000; 
            x = x_min:(x_max-x_min)/(npoints - 1):x_max;
            plot(x, f(x), 'r-', 'LineWidth', 2);
        else
            draw = 0;
        end;
        if (sign(f(x_min)) ~= sign(f(x_max)))
            iteracijos_sk = 0;
            [a, b, it, t]=SkenavimasRekursija(x_min, x_max, zingsnis, tikslumas, f, iteracijos_sk, draw);
            Saknys_intervalai_fx = [Saknys_intervalai_fx; a b];
            Iteracijos = [Iteracijos; it];
            Tikslumai = [Tikslumai; t];
        end
    end;
    close all;
    Saknys_fx = (Saknys_intervalai_fx(:,1) + Saknys_intervalai_fx(:,2))/2;
    Rez_fx = [];
    for i=1:length(Saknys_fx)
        Rez_fx = [Rez_fx; SaknuIntervalai_fx(i,:) Saknys_fx(i) Tikslumai(i) Iteracijos(i)];
    end;
     Rez_fx
    % ------------------------------------
    % ðaknø tikslinimas funkcijai g(x)
    % ------------------------------------
    % ðaknø intervalø atskyrimas funkcijai g(x)
    % ------------------------------------
    zingsnis = 0.2; % zingsnio nustatymas
    g_min = 1;
    g_max = 20;
    [SaknuIntervalai_gx]=SkenavimasPastoviu(g_min, g_max, zingsnis, g);
    disp( sprintf( '----------------------------------------------------'));
    disp( sprintf( 'Ðaknø tikslinimas skenavimo metodu, maþinant þingsná'));
    disp( sprintf( 'Funkcija g(x)=sin(x)ln(x)-(x/6)'));
    disp( sprintf( '----------------------------------------------------'));
    disp( sprintf( 'Stulpeliø reikðmës:'));
    disp( sprintf( '1:2 - pradiniai ðaknø tikslinimo intervalai'));
    disp( sprintf( '3 - ðaknis'));
    disp( sprintf( '4 - tikslumas'));
    disp( sprintf( '5 - atliktø iteracijø kiekis'));
    disp( sprintf( '----------------------------------------------------'));
    Saknys_intervalai_gx = [];
    Tikslumai = [];
    Iteracijos = [];
    tikslumas = 1e-9;
    for i=1:length(SaknuIntervalai_gx)
        x_min = SaknuIntervalai_gx(i, 1);
        x_max = SaknuIntervalai_gx(i, 2);
        draw = 0;
        if (sign(g(x_min)) ~= sign(g(x_max)))
            iteracijos_sk = 0;
            [a, b, it, t]=SkenavimasRekursija(x_min, x_max, zingsnis, tikslumas, g, iteracijos_sk, draw);
            Saknys_intervalai_gx = [Saknys_intervalai_gx; a b];
            Iteracijos = [Iteracijos; it];
            Tikslumai = [Tikslumai; t];
        end
    end;
    Saknys_gx = (Saknys_intervalai_gx(:,1) + Saknys_intervalai_gx(:,2))/2;
    Rez_gx = [];
    for i=1:length(Saknys_gx)
        Rez_gx = [Rez_gx; SaknuIntervalai_gx(i,:) Saknys_gx(i) Tikslumai(i) Iteracijos(i)];
    end;
    Rez_gx
    % ------------------------------------
    % STYGØ METODAS
    % ------------------------------------
    eps = 1e-9;
    % ðaknø tikslinimas daugianariui f(x)
    % ------------------------------------
    disp( sprintf( '----------------------------------------------------'));
    disp( sprintf( 'Ðaknø tikslinimas stygø metodu'));
    disp( sprintf( 'Daugianaris f(x)=x^4+5x^3-2x^2-24x'));
    disp( sprintf( '----------------------------------------------------'));
    disp( sprintf( 'Stulpeliø reikðmës:'));
    disp( sprintf( '1:2 - pradiniai ðaknø tikslinimo intervalai'));
    disp( sprintf( '3 - ðaknis'));
    disp( sprintf( '4 - tikslumas'));
    disp( sprintf( '5 - atliktø iteracijø kiekis'));
    disp( sprintf( '----------------------------------------------------'));
    Tikslumai = [];
    Iteracijos = [];
    Saknys_fx = [];
    iteracijos_sk_max = 200; % maksimalus leistinas iteracijø skaièius
    figure(1); grid on; hold on;
    for i=1:length(SaknuIntervalai_fx)
        xn = SaknuIntervalai_fx(i, 1);
        xn1 = SaknuIntervalai_fx(i, 2);
        npoints= 1000; x = xn:(xn1-xn)/(npoints - 1):xn1;
        iteracijos_sk = 0;
        tikslumas = 1;
        while tikslumas > eps
            iteracijos_sk = iteracijos_sk + 1;
            if (iteracijos_sk > iteracijos_sk_max)
                fprintf('Virsytas leistinas iteraciju skaicius');
                break;
            end
            % ieðkomos k ir xmid reikðmës
            fxn = f(xn); 
            fxn1 = f(xn1);
            k=abs(fxn/fxn1);
            xmid=(xn+k*xn1)/(1+k);
            %----------------------------------------------------
            % vizualizacija
            %----------------------------------------------------
            if (i == 1 && iteracijos_sk < 7)
                plot(x, f(x), 'r-');
                plot([xn xn1], [0 0], 'b-');
                plot(xn, 0, 'mp', 'Linewidth', 2); h = findobj(gca,'Type','line');h1=h(1);
                plot(xn1,0,'cp', 'Linewidth', 2);h = findobj(gca,'Type','line');h2=h(1);
                plot(xmid,0,'gs', 'Linewidth', 2);plot([xn,xn1],[fxn,fxn1],'g-');h = findobj(gca,'Type','line');h3=h(1:2);
                input('Press Enter'), figure(1);
                delete(h1);delete(h2);delete(h3);
            end
            %----------------------------------------------------
            fxmid=f(xmid);
            if (sign(fxmid) == sign(fxn))
               xn=xmid;
            else
               xn1=xmid;
            end
            
            tikslumas = abs(fxmid);
        end
            Iteracijos = [Iteracijos; iteracijos_sk];
            Tikslumai = [Tikslumai; tikslumas];
            Saknys_fx = [Saknys_fx; xmid];
    end
    close all;
    Rez_fx = [];
    for i=1:length(Saknys_fx)
        Rez_fx = [Rez_fx; SaknuIntervalai_fx(i,:) Saknys_fx(i) Tikslumai(i) Iteracijos(i)];
    end;
    Rez_fx
    % ------------------------------------
    % ðaknø tikslinimas funkcijai g(x)
    % ------------------------------------
    disp( sprintf( '----------------------------------------------------'));
    disp( sprintf( 'Ðaknø tikslinimas stygø metodu'));
    disp( sprintf( 'Funkcija g(x)=sin(x)ln(x)-(x/6)'));
    disp( sprintf( '----------------------------------------------------'));
    disp( sprintf( 'Stulpeliø reikðmës:'));
    disp( sprintf( '1:2 - pradiniai ðaknø tikslinimo intervalai'));
    disp( sprintf( '3 - ðaknis'));
    disp( sprintf( '4 - tikslumas'));
    disp( sprintf( '5 - atliktø iteracijø kiekis'));
    disp( sprintf( '----------------------------------------------------'));
    Tikslumai = [];
    Iteracijos = [];
    Saknys_gx = [];
    iteracijos_sk_max = 200; % maksimalus leistinas iteracijø skaièius
    for i=1:length(SaknuIntervalai_gx)
        xn = SaknuIntervalai_gx(i, 1);
        xn1 = SaknuIntervalai_gx(i, 2);
        iteracijos_sk = 0;
        tikslumas = 1;
        while tikslumas > eps
            iteracijos_sk = iteracijos_sk + 1;
            if (iteracijos_sk > iteracijos_sk_max)
                fprintf('Virsytas leistinas iteraciju skaicius');
                break;
            end
            % ieðkomos k ir xmid reikðmës
            fxn = g(xn); 
            fxn1 = g(xn1);
            k=abs(fxn/fxn1);
            xmid=(xn+k*xn1)/(1+k);
            
            fxmid=g(xmid);
            if (sign(fxmid) == sign(fxn))
               xn=xmid;
            else
               xn1=xmid;
            end
            
            tikslumas = abs(fxmid);
        end
            Iteracijos = [Iteracijos; iteracijos_sk];
            Tikslumai = [Tikslumai; tikslumas];
            Saknys_gx = [Saknys_gx; xmid];
    end
    Rez_gx = [];
    for i=1:length(Saknys_gx)
        Rez_gx = [Rez_gx; SaknuIntervalai_gx(i,:) Saknys_gx(i) Tikslumai(i) Iteracijos(i)];
    end;
    Rez_gx
    % ------------------------------------
    % Kvazi-Niutono (kirstiniø) metodas
    eps = 1e-9;
    % ------------------------------------
    % ðaknø tikslinimas daugianariui f(x)
    % ------------------------------------
    disp( sprintf( '----------------------------------------------------'));
    disp( sprintf( 'Ðaknø tikslinimas Kvazi-Niutono (kirstiniø) metodu'));
    disp( sprintf( 'Daugianaris f(x)=x^4+5x^3-2x^2-24x'));
    disp( sprintf( '----------------------------------------------------'));
    disp( sprintf( 'Stulpeliø reikðmës:'));
    disp( sprintf( '1 - pirmasis pradinis artinys'));
    disp( sprintf( '2 - antrasis pradinis artinys'));
    disp( sprintf( '3 - ðaknis'));
    disp( sprintf( '4 - tikslumas'));
    disp( sprintf( '5 - atliktø iteracijø kiekis'));
    disp( sprintf( '----------------------------------------------------'));
    Tikslumai = [];
    Iteracijos = [];
    Saknys_fx = [];
    Artiniai = [];
    iteracijos_sk_max = 200;
    figure(1); grid on; hold on;
    for i=1:length(SaknuIntervalai_fx)
        x0 = SaknuIntervalai_fx(i, 1);
        x01 = SaknuIntervalai_fx(i, 2);
        npoints=1000; 
        x=x0:(x01-x0)/(npoints-1):x01;
        axis([(x0-0.01) (x01+0.01) -2.5 8.5]);
        Artiniai = [Artiniai; x0 x01];
        fxn = f(x0);
        fxn1 = f(x01);
        xn = x0;
        xn_plot = x0;
        xn1_plot = x01;
        fxn_plot = f(x0);
        fxn1_plot = f(x01);
        dfxn = (fxn1 - fxn)/(x01-x0);
        tikslumas = 1;
        iteracijos_sk = 0;
        while tikslumas > eps
            iteracijos_sk = iteracijos_sk + 1;
            if (iteracijos_sk > iteracijos_sk_max)
                fprintf('Virsytas leistinas iteraciju skaicius');
                break;
            end
            xn1 = xn - fxn/dfxn;
            if(i == 1 && iteracijos_sk < 7)
                plot(x,f(x),'r-');
                plot([x0 x01],[0 0],'b-');
                plot(x0,0,'mp');
                h = findobj(gca,'Type','line');h1=h(1);
                plot([xn_plot,xn_plot,xn1_plot,xn1_plot],[0,fxn_plot,fxn1_plot,0],'k-');
                plot([xn,xn,xn1],[0,fxn,0],'k-');
                delete(h1);plot(xn1,0,'mp');h = findobj(gca,'Type','line');h1=h(1);
                input('Press Enter'), figure(1);
            end
            fxn1 = f(xn1);
            dfxn = (fxn1 - fxn)/(xn1 - xn);
            xn = xn1;
            fxn = f(xn);
            tikslumas = abs(fxn);
        end
        Iteracijos = [Iteracijos; iteracijos_sk];
        Tikslumai = [Tikslumai; tikslumas];
        Saknys_fx = [Saknys_fx; xn];
    end;
    close all;
    Rez_fx = [];
    for i=1:length(Saknys_fx)
        Rez_fx = [Rez_fx; Artiniai(i, :) Saknys_fx(i) Tikslumai(i) Iteracijos(i)];
    end;
    Rez_fx
    % ------------------------------------
    % ðaknø tikslinimas funkcijai g(x)
    % ------------------------------------
    disp( sprintf( '----------------------------------------------------'));
    disp( sprintf( 'Ðaknø tikslinimas Kvazi-Niutono (kirstiniø) metodu'));
    disp( sprintf( 'Funkcija g(x)=sin(x)ln(x)-(x/6)'));
    disp( sprintf( '----------------------------------------------------'));
    disp( sprintf( 'Stulpeliø reikðmës:'));
    disp( sprintf( '1 - pirmasis pradinis artinys'));
    disp( sprintf( '2 - antrasis pradinis artinys'));
    disp( sprintf( '3 - ðaknis'));
    disp( sprintf( '4 - tikslumas'));
    disp( sprintf( '5 - atliktø iteracijø kiekis'));
    disp( sprintf( '----------------------------------------------------'));
    Tikslumai = [];
    Iteracijos = [];
    Saknys_gx = [];
    Artiniai = [];
    iteracijos_sk_max = 200;
    for i=1:length(SaknuIntervalai_gx)
        x0 = SaknuIntervalai_gx(i, 1) - 0.2;
        x01 = SaknuIntervalai_gx(i, 1) - 0.1;
        Artiniai = [Artiniai; x0 x01];
        fxn = g(x0);
        fxn1 = g(x01);
        dfxn = (fxn1 - fxn)/(x01-x0);
        xn = x0;
        tikslumas = 1;
        iteracijos_sk = 0;
        while tikslumas > eps
            iteracijos_sk = iteracijos_sk + 1;
            if (iteracijos_sk > iteracijos_sk_max)
                fprintf('Virsytas leistinas iteraciju skaicius');
                break;
            end
            xn1 = xn - fxn/dfxn;
            fxn1 = g(xn1);
            dfxn = (fxn1 - fxn)/(xn1 - xn);
            xn = xn1;
            fxn = g(xn);
            tikslumas = abs(fxn);
        end
        Iteracijos = [Iteracijos; iteracijos_sk];
        Tikslumai = [Tikslumai; tikslumas];
        Saknys_gx = [Saknys_gx; xn];
    end;
    Rez_gx = [];
    for i=1:length(Saknys_gx)
        Rez_gx = [Rez_gx; Artiniai(i, :) Saknys_gx(i) Tikslumai(i) Iteracijos(i)];
    end;
    Rez_gx
    % Matlab funkcijos
    % Daugianaris f(x)
    disp( sprintf( '----------------------------------------------------'));
    disp( sprintf( 'MATLAB funkcijos'));
    disp( sprintf( '----------------------------------------------------'));
    disp( sprintf( 'Daugianaris f(x)'));
    disp( sprintf( '----------------------------------------------------'));
    a = [1 5 -2 -24 0];
    saknys_roots = roots(a)
    for i=1:length(SaknuIntervalai_fx)
        fzero(f, SaknuIntervalai_fx(i, 1))
    end
    % Matlab funkcijos
    % Funkcija g(x)
    disp( sprintf( '----------------------------------------------------'));
    disp( sprintf( 'Funkcija g(x)'));
    disp( sprintf( '----------------------------------------------------'));
    for i=1:length(SaknuIntervalai_gx)
        fzero(g, SaknuIntervalai_gx(i, 1))
    end
end