function Lab_euler
clc, clear all,
close all
spalva=['k','b','g','c','r'];
 
global g h0 t0 rh c R Aw;
t0=0;
rc = 0.09;
h0=0.25;
g=9.8;
rh=0.005;
c=0.6;
tmax=140;
R=@(h)0.3*sqrt(h)+0,005;
Aw1=@(h)pi*(0.3*sqrt(h)+0.005)^2;
Aw2=@(h)pi*rc.^2;
 
zingsniaiTiksl=[0.25 0.5 1 2 4]; % Tiklsumo zingsniu masyvas
zingsniaiStabil=[1 5 10 15 30]; % Stabilumo zingsniu masyvas
 
nnn=100;
figurosIndeksas=1;
 
for i=1:2
    if i==1
        zingsniai=zingsniaiTiksl;
    else
        zingsniai=zingsniaiStabil;
    end;
for j=1:2
    if j==1
        Aw=Aw1;
        forma='Duotos formos '
    else
        Aw=Aw2;
        forma='Cilindro '
    end;
    
    figure(figurosIndeksas), hold on, grid on;
    figurosIndeksas=figurosIndeksas+1;
    for k=1:length(zingsniai)
        zingsnis=zingsniai(k);
        zingsniuSkaicius=tmax/zingsnis;
        ttt=t0+(0:zingsnis/(nnn-1):zingsnis);
        t=t0;
        h=h0;
        plot(t,h,'ro');
        prevt=t;
        prevh=h;
            for l=1:zingsniuSkaicius
                dv=funkcija(t,h,Aw);
                h=h+zingsnis*dv;
               h2=h;
             if h < 0
                 h2= 0;
             end
                t=t+zingsnis;
                plot(t,h2,[spalva(k),'.'],'MarkerSize',5)
                ob(k)=plot([prevt,t],[prevh,h2],[spalva(k),'-']);
                prevt=t;prevh=h2;
                ttt=ttt+zingsnis;
            end
    end
 
    if i==1
        %tikslumo tyrimas
        legend(ob,'dt=0.25','dt=0.5','dt=1','dt=2','dt=4') 
        title([forma, 'Tiklsumo tyrimas']) 
    else
        %stabilumo tyrimas
        legend(ob,'dt=1','dt=5','dt=10','dt=15','dt=30') 
        title([forma, 'Stabilumo tyrimas']) 
    end;
    
    
    xlabel('Laikas, s'); ylabel('Skyscio lygis, m')
end
end
 
 
return
    function dv=funkcija(t,h,Aw)
        dv=-c*pi*rh.^2*sqrt(abs(2*g*h))/Aw(h); 
    return,end
end
