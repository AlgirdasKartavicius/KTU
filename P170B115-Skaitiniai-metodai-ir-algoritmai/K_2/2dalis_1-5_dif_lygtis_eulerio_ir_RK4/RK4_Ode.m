function simonas_b
    clc, clear all, % close all
    % ar rodyti ode45 matlab funkcijos grafikà
    % 0 - nerodyti, 1 - rodyti
    ode45_rodyti = 0;
    % tyrimo tipas
    % 0 - tikslu ir stabilumo tyrimas, 1 - uþdavinio sprendimas ir jei
    % pasirinkta palyginimas su ode45 sprendiniu
    variantas = 1;
    nnn=100; % vaizdavimo tasku skaicius zingsnyje
% % % % % % % % % % % % % % % % % % % % % % % % % % % %     
    global m m1 m2 h0 tg g v0;
    m1 = 100;
    m2 = 15;
    m = m1 + m2;
    k1 = 0.5;
    k2 = 10;
    tg = 40;
    h0 = 3000;
    g = 9.8;
    v0 = 0;
    Tmax = 170;
    figure(1), hold on, grid on,set(gcf,'Color','w');
%     plot(0,v0,'ro', 'MarkerSize', 10) % pradinio tasko vaizdavimas
    if (variantas == 0) 
%         Stabilumui
%         DT=[0.05, 0.1, 0.2, 0.3, 0.4, 0.6];
%         Tikslumui
        DT=[0.005, 0.01, 0.05, 0.1, 0.15, 0.2];
        spalvos=['k','b','m','g','y','c'];
        ylabel('h, m');
        xlabel('t, s');
        for j=1:length(DT)
            dt=DT(j);
            xxx=0:dt/(nnn-1):dt; % vaizdavimo taskai viename zingsnyje
            nsteps=floor(Tmax/dt); % zingsniu skaicius
            X=[];
            H=[];
            Y=[];
            X=zeros(round(nsteps)+1,1);
            H=zeros(round(nsteps)+1,1);
            Y=zeros(round(nsteps)+1,1);
            v=v0;
            h=h0;
            t=0;
            X(1)=t; Y(1)=v; H(1) = h0;
            for i=1:nsteps
                dy=funkcija1(t,v);
                % gauname pirmaja ekstrapoliacija pagal T.e. narius iki 1 eiles
                yz=v+dt/2*dy(1);
                % apskaiciuojame desines puses funkcija prie (x+dx/2,yz)
                dyz=funkcija1(t+dt/2,yz);
                yzz=v+dt/2*dyz(1); % atgaline Eulerio formule
                dyzz=funkcija1(t+dt/2,yzz);
                yzzz=v+dt*dyzz(1); % vidurinio tasko formule
                dyzzz=funkcija1(t+dt,yzzz);
                vtarpinis=v+dt*(dy(1)+2*dyz(1)+2*dyzz(1)+dyzzz(1))/6; % Heuno (II RK) formule
                
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
                dy=funkcija1(t,v);
                % gauname pirmaja ekstrapoliacija pagal T.e. narius iki 1 eiles
                yz=v+dt/2*dy(2);
                % apskaiciuojame desines puses funkcija prie (x+dx/2,yz)
                dyz=funkcija1(t+dt/2,yz);
                yzz=v+dt/2*dyz(2); % atgaline Eulerio formule
                dyzz=funkcija1(t+dt/2,yzz);
                yzzz=v+dt*dyzz(2); % vidurinio tasko formule
                dyzzz=funkcija1(t+dt,yzzz);
%                 h=h+dt*(dy(2)+2*dyz(2)+2*dyzz(2)+dyzzz(2))/6; % Heuno (II RK) formule
                h = h + dt*dy(2);
                H(i+1)=h;
                %%%%%
                X(i+1)=t+dt;
                Y(i+1)=vtarpinis;
                v = vtarpinis;
                t=t+dt; % argumento prieaugis per 1 zingsni
                xxx=xxx+dt; % vaizdavimo taskai perstumiami i sekanti zingsni
            end
            figure(1); hold on;
            plot(X,Y,[spalvos(j)]);
        end
%         figure(2), hold on, grid on, %axis(range);
%         plot(X,H);
        legend(['Greièio priklausomybë nuo laiko kai \Deltat=', num2str(DT(1))],...
                ['Greièio priklausomybë nuo laiko, kai \Deltat=', num2str(DT(2))],...
                ['Greièio priklausomybë nuo laiko, kai \Deltat=', num2str(DT(3))],...
                ['Greièio priklausomybë nuo laiko, kai \Deltat=', num2str(DT(4))],...
                ['Greièio priklausomybë nuo laiko, kai \Deltat=', num2str(DT(5))],...
                ['Greièio priklausomybë nuo laiko, kai \Deltat=', num2str(DT(6))]);
    else
        v=v0;
        t=0;
        dt=0.1; % integravimo zingsnis
        xxx=0:dt/(nnn-1):dt; % vaizdavimo taskai viename zingsnyje
        nsteps=floor(Tmax/dt); % zingsniu skaicius
        X=zeros(round(nsteps)+1,1);
        H=zeros(round(nsteps)+1,1);
        Y=zeros(round(nsteps)+1,1);
        X(1)=t; Y(1)=v; H(1) = h0;
        h = h0;
        for i=1:nsteps
            dy=funkcija1(t,v);
            % gauname pirmaja ekstrapoliacija pagal T.e. narius iki 1 eiles
            yz=v+dt/2*dy(1);
            % apskaiciuojame desines puses funkcija prie (x+dx/2,yz)
            dyz=funkcija1(t+dt/2,yz);
            yzz=v+dt/2*dyz(1); % atgaline Eulerio formule
            dyzz=funkcija1(t+dt/2,yzz);
            yzzz=v+dt*dyzz(1); % vidurinio tasko formule
            dyzzz=funkcija1(t+dt,yzzz);
            vtarpinis=v+dt*(dy(1)+2*dyz(1)+2*dyzz(1)+dyzzz(1))/6; % Heuno (II RK) formule
                
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
            dy=funkcija1(t,v);
            % gauname pirmaja ekstrapoliacija pagal T.e. narius iki 1 eiles
            yz=v+dt/2*dy(2);
            % apskaiciuojame desines puses funkcija prie (x+dx/2,yz)
            dyz=funkcija1(t+dt/2,yz);
            yzz=v+dt/2*dyz(2); % atgaline Eulerio formule
            dyzz=funkcija1(t+dt/2,yzz);
            yzzz=v+dt*dyzz(2); % vidurinio tasko formule
            dyzzz=funkcija1(t+dt,yzzz);
%           h=h+dt*(dy(2)+2*dyz(2)+2*dyzz(2)+dyzzz(2))/6; % Heuno (II RK) formule
            h = h + dt*dy(2);
            H(i+1)=h;
            %%%%%
            X(i+1)=t+dt;
            Y(i+1)=vtarpinis;
            v = vtarpinis;
            t=t+dt; % argumento prieaugis per 1 zingsni
            xxx=xxx+dt; % vaizdavimo taskai perstumiami i sekanti zingsni
        end
        ylabel('v, m/s');
        xlabel('t, s');
        figure(1); hold on;
        plot(X,Y,'.-');
        legend('Greièio priklausomybë nuo laiko');
        figure(2); hold on; grid on;
        plot(X,H,'r.-');
        legend('Aukðèio priklausomybë nuo laiko, kai h0 = 3000m');
        ylabel('h, m');
        xlabel('t, s');
        %     ode45
        if (ode45_rodyti == 1)
            [x,y]=ode45(@funkcija1,[0 Tmax],[v0 h0]);
            figure(3); hold on; grid on;
            ylabel('v, m/s');
            xlabel('t, s');
            plot(x,y(:,1), 'r.-');
            plot(X,Y, 'b.-');
            legend('Greièio priklausomybë nuo laiko ode45', 'Greièio priklausomybë nuo laiko IV eilës Rungës ir Kutos');
            figure(4); hold on; grid on;
            ylabel('h, m');
            xlabel('t, s');
            plot(x,y(:,2), 'r.-');
            plot(X,H, 'b.-');
            legend('Aukðèio priklausomybë nuo laiko ode45', 'Aukðèio priklausomybë nuo laiko IV eilës Rungës ir Kutos');
        end
    end  
    return

    function f=funkcija1(t,v)
    % f=k*x*(n+1-x);
    if t <= tg
        kpas = k1;
    else
        kpas = k2;
    end
    f=[g - kpas*v(1)*abs(v(1))/m; -v(1)];
    end
end