function L2_2
    clc, clear all, % close all
    % ar rodyti ode45 matlab funkcijos grafikà
    % 0 - nerodyti, 1 - rodyti
    ode45_rodyti = 1;
    % tyrimo tipas
    % 0 - tikslumo tyrimas, 1 - stabilumo tyrimas, kitais atvejais -
    % iðsprendþiamas uþdavinys pakankamai tiksliu þingsniu bei su matlab
    % funkcija ode45 (jei pasirinkta)
    tyrimas = 2;
    T1 = 473;
    T2 = 270;
    T_pradine = T1;
    Ta1 = 373;
    Ta2 = 423;
    ts = 20;
    ta = ts + 10;  
    tmax=70; % sprendimo intervalo pabaiga
    nnn=100; % vaizdavimo tasku skaicius zingsnyje
    figure(1), hold on, grid on,set(gcf,'Color','w');
    plot(0,T_pradine,'ro', 'MarkerSize', 10) % pradinio tasko vaizdavimas
    if (tyrimas == 0)  
        DT=[1.5, 1, 0.5, 0.25, 0.125, 0.0625];
        spalvos=['k','b','m','g','y','c'];
        for j=1:length(DT)
            dt=DT(j);
            xxx=0:dt/(nnn-1):dt; % vaizdavimo taskai viename zingsnyje
            nsteps=floor(tmax/dt); % zingsniu skaicius
            X=[];
            TA=[];
            Y=[];
            X=zeros(round(nsteps)+1,1);
            TA=zeros(round(nsteps)+1,1);
            Y=zeros(round(nsteps)+1,1);
            T=T_pradine;
            t=0;
            X(1)=t; Y(1)=T; TA(1) = Ta1;
            for i=1:nsteps
                dy=f(t,T);
                % gauname pirmaja ekstrapoliacija pagal T.e. narius iki 1 eiles
                yz=T+dt/2*dy;
                % apskaiciuojame desines puses funkcija prie (x+dx/2,yz)
                dyz=f(t+dt/2,yz);
                yzz=T+dt/2*dyz; % atgaline Eulerio formule
                dyzz=f(t+dt/2,yzz);
                yzzz=T+dt*dyzz; % vidurinio tasko formule
                dyzzz=f(t+dt,yzzz);
                T=T+dt*(dy+2*dyz+2*dyzz+dyzzz)/6; % Heuno (II RK) formule
                X(i+1)=t+dt;
                Y(i+1)=T;
                if (t < ts)
                    TA(i+1) = Ta1;
                elseif (t >= ts) && (t < ta)
                    TA(i+1) = Ta(t);
                else
                    TA(i+1) = Ta2;
                end
                t=t+dt; % argumento prieaugis per 1 zingsni
                xxx=xxx+dt; % vaizdavimo taskai perstumiami i sekanti zingsni
            end
            figure(1); hold on;
            plot(X,Y,[spalvos(j),'.-']);
        end
        plot(X,TA,'r.-');
        legend('Kûno temperatûra, kai t=0',...
                ['Kûno temperatûra, kai \Deltat=', num2str(DT(1))],...
                ['Kûno temperatûra, kai \Deltat=', num2str(DT(2))],...
                ['Kûno temperatûra, kai \Deltat=', num2str(DT(3))],...
                ['Kûno temperatûra, kai \Deltat=', num2str(DT(4))],...
                ['Kûno temperatûra, kai \Deltat=', num2str(DT(5))],...
                ['Kûno temperatûra, kai \Deltat=', num2str(DT(6))],...
                'Aplinkos temperatûra', 'Kûno temperatûra, apskaièiuota naudojant Matlab funkcijà ode45');
    elseif (tyrimas == 1)
        DT=[0.5, 1, 2.5, 5, 10, 15];
        spalvos=['k','b','m','g','y','c'];
        for j=1:length(DT)
            dt=DT(j);
            xxx=0:dt/(nnn-1):dt; % vaizdavimo taskai viename zingsnyje
            nsteps=floor(tmax/dt); % zingsniu skaicius
            X=[];
            TA=[];
            Y=[];
            X=zeros(round(nsteps)+1,1);
            TA=zeros(round(nsteps)+1,1);
            Y=zeros(round(nsteps)+1,1);
            T=T_pradine;
            t=0;
            X(1)=t; Y(1)=T; TA(1) = Ta1;
            for i=1:nsteps
                dy=f(t,T);
                % gauname pirmaja ekstrapoliacija pagal T.e. narius iki 1 eiles
                yz=T+dt/2*dy;
                % apskaiciuojame desines puses funkcija prie (x+dx/2,yz)
                dyz=f(t+dt/2,yz);
                yzz=T+dt/2*dyz; % atgaline Eulerio formule
                dyzz=f(t+dt/2,yzz);
                yzzz=T+dt*dyzz; % vidurinio tasko formule
                dyzzz=f(t+dt,yzzz);
                T=T+dt*(dy+2*dyz+2*dyzz+dyzzz)/6; % Heuno (II RK) formule
                X(i+1)=t+dt;
                Y(i+1)=T;
                if (t < ts)
                    TA(i+1) = Ta1;
                elseif (t >= ts) && (t < ta)
                    TA(i+1) = Ta(t);
                else
                    TA(i+1) = Ta2;
                end
                t=t+dt; % argumento prieaugis per 1 zingsni
                xxx=xxx+dt; % vaizdavimo taskai perstumiami i sekanti zingsni
            end
            figure(1); hold on;
            plot(X,Y,[spalvos(j),'.-']);
        end
        legend('Kûno temperatûra, kai t=0',...
                ['Kûno temperatûra, kai \Deltat=', num2str(DT(1))],...
                ['Kûno temperatûra, kai \Deltat=', num2str(DT(2))],...
                ['Kûno temperatûra, kai \Deltat=', num2str(DT(3))],...
                ['Kûno temperatûra, kai \Deltat=', num2str(DT(4))],...
                ['Kûno temperatûra, kai \Deltat=', num2str(DT(5))],...
                ['Kûno temperatûra, kai \Deltat=', num2str(DT(6))],...
                'Aplinkos temperatûra', 'Kûno temperatûra, apskaièiuota naudojant Matlab funkcijà ode45');
    else
        T=T_pradine;
        t=0;
        dt=1; % integravimo zingsnis
        xxx=0:dt/(nnn-1):dt; % vaizdavimo taskai viename zingsnyje
        nsteps=floor(tmax/dt); % zingsniu skaicius
        X=zeros(round(nsteps)+1,1);
        TA=zeros(round(nsteps)+1,1);
        Y=zeros(round(nsteps)+1,1);
        X(1)=t; Y(1)=T; TA(1) = Ta1;
        for i=1:nsteps
            dy=f(t,T);
            % gauname pirmaja ekstrapoliacija pagal T.e. narius iki 1 eiles
            yz=T+dt/2*dy;
            % apskaiciuojame desines puses funkcija prie (x+dx/2,yz)
            dyz=f(t+dt/2,yz);
            yzz=T+dt/2*dyz; % atgaline Eulerio formule
            dyzz=f(t+dt/2,yzz);
            yzzz=T+dt*dyzz; % vidurinio tasko formule
            dyzzz=f(t+dt,yzzz);
            T=T+dt*(dy+2*dyz+2*dyzz+dyzzz)/6; % Heuno (II RK) formule
            X(i+1)=t+dt;
            Y(i+1)=T;
            if (t < ts)
                TA(i+1) = Ta1;
            elseif (t >= ts) && (t < ta)
                TA(i+1) = Ta(t);
            else
                TA(i+1) = Ta2;
            end
            t=t+dt; % argumento prieaugis per 1 zingsni
            xxx=xxx+dt; % vaizdavimo taskai perstumiami i sekanti zingsni
        end
        figure(1); hold on;
        plot(X,Y,'.-');
        plot(X,TA,'r.-');
        %     ode45
        if (ode45_rodyti == 1)
            [T, X]=ode45(@f,[0 tmax],T_pradine);
            plot(T,X, 'm.-');
        end
        legend('Kûno temperatûra, kai t=0', 'Kûno temperatûra', 'Aplinkos temperatûra', 'Kûno temperatûra, apskaièiuota naudojant Matlab funkcijà ode45');
    end  
    ylabel('T, K');
    xlabel('t, s');
    return

    function dy=f(t, T)
        if (t < ts)
            dy=k(T)*(T-Ta1);
        elseif (t >= ts) && (t < ta)
            dy=k(T)*(T-Ta(t));
        else
            dy=k(T)*(T-Ta2);
        end
    end
    
    function k_val=k(T)
        k_val = -0.15 - (T-273)/800 + 3/40*((T-273)/100)^2; 
    end

    function t_val=Ta(t)
        t_val = Ta1 + (Ta2-Ta1)/2*(1 - cos(pi/10*(t-ts)));
    end
end