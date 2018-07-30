function BallUp

clc; close all;

global g m k1 k2;

figure(1); grid on; hold on;
h1 = zeros(4, 1);
h1(1) = plot(NaN,NaN,'k-');
h1(2) = plot(NaN,NaN,'b-');
h1(3) = plot(NaN,NaN,'r-');
h1(4) = plot(NaN,NaN,'k*');
%legend(h1, 'Pagreitis','Greitis','Aukstis', 'Auksciausias taskas');
ylim([-100 100]);
xlim([-1 10]);
xlabel('t');
ylabel('pagretisi (m/s^2)');
figure(3); grid on; hold on;
ylim([-100 100]);
xlim([-1 10]);
xlabel('t');
ylabel('gretis (m/s)');
figure(4); grid on; hold on;
ylim([-100 100]);
xlim([-1 10]);
xlabel('t');
ylabel('aukstis (m)');

figure(2); grid on;
hPlot = plot(0,NaN,'bo', 'MarkerFaceColor', 'b');
ylim([-5 100]);
xlim([-1 1]);

k1 = 0.015;
k2 = 0.05;
%k1 = 0;
%k2 = 0;
g = -9.81;
m = 0.5;
v0 = 50;
h0 = 30;

tmax = 10;
dt = 0.016;

%pause;
simulation(dt, 'k');
%simulation(dt / 2, 'g');
%simulation(dt / 4, 'b');
%simulation(dt / 8, 'r');
%simulation(dt / 16, 'y');
%simulation(dt / 32, 'c');
%simulation(dt / 64, 'm');

    function simulation(dt, color)
        nsteps=tmax/dt;
        
        v = v0;
        h = h0;
        t = 0;
        a = A(v);
        pntt=t;pnta=a;pntv=v;pnth=h;

        for i=1:nsteps 
            a=A(v);
            if(v > 0 && abs(a*dt) > v)
               disp('Maksimalus aukstis:');
               disp(h);
               disp('laikas:');
               disp(t);
               figure(1);
               %plot(t, h, 'k*', 'MarkerSize',8);
            end
            v=v+a*dt;
            h=h+v*dt;
            t=t+dt;

            %pause(dt);

            figure(1);
            plot(t,a,[color,'.'],'MarkerSize',8)
            plot([pntt,t],[pnta,a],[color,'-']);
            figure(3);
            plot(t, v, 'b.','MarkerSize',8);
            plot([pntt,t],[pntv,v],['b','-']);
            figure(4);
            plot(t, h, 'r.','MarkerSize',8);
            plot([pntt,t],[pnth,h],['r','-']);
            
            %plot(t, v, [color, '.'],'MarkerSize',8);
            %plot([pntt,t],[pntv,v],[color,'-']);
            %plot(t, h, [color, '.'],'MarkerSize',8);
            %plot([pntt,t],[pnth,h],[color,'-']);

            figure(2);
            set(hPlot,'YData',h);

            pntt=t;pnta=a;pntv=v;pnth=h;

            if(h < 0)
               break; 
            end
        end

        disp('Pasieke zeme laikas:');
        disp(t);

    end

    function a=A(v)
        if(v > 0)
            a=((m*g)-(k1*v.^2))./m;
        else 
            a=((m*g)+(k2*v.^2))./m;
        end
        return
    end 
end