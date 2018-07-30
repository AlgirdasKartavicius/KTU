clc, clear, close all;
load sunspot.txt;

% sunspot % patikrinti, ar uþkrovë sunspot
% % clear sunspot

% Saules demiu grafiko braizymas
figure(1);
plot(sunspot(:, 1), sunspot(:, 2), 'b-o');
grid on;
xlabel('Metai');
ylabel('Demiu skaicius');
title('Saules demiu aktyvumas 1700-1950 metais');
% P ir T matricø apraðymas
L = length(sunspot);
disp('P matrica (ávesties duomenys):')
P = [sunspot(1:L-2, 2)'; sunspot(2:L-1, 2)'] % Ávestys
disp('P matricos dydis:')
size(P)
disp('T matrica (iðvesties duomenys):')
T = sunspot(3:L, 2)' % Iðvestys
disp('T matricos dydis:')
size(T)
figure(2)
plot3(P(1,:), P(2,:), T, 'bo');
grid on;
xlabel('Saules demiu skaicius (n-2)-aisiais metais');
ylabel('Saules demiu skaicius (n-1)-taisiais metais');
zlabel('Saules demiu skaicius n-aisiais metais');
title('Saules demiu prognoziu, remiantis 2 ankstesniais metais, diagrama');
% Apmokymas
disp('Pu matrica (apmokymo duomenys):')
Pu = P(:, 1:200)
disp('Tu matrica (apmokymo rezultatai):')
Tu = T(:, 1:200)
disp('Pu matricos dydis:')
size(Pu)
disp('Tu matricos dydis:')
size(Tu)
net = newlind(Pu, Tu);
disp('Neurono svorio koeficientai:');
disp(net.IW{1});
disp('Neurono bias reikðmë:');
disp(net.b{1});
% svorio koeficientø reikðmiø priskyrimas
w1 = net.IW{1}(1)
w2 = net.IW{1}(2)
b = net.b{1}
% modelio verifikacija (prognozuojamø reikðmiø radimas) 1702-1901
Tsu = sim(net, Pu) % Neurono veikimo simuliacija
figure(3), hold on;
plot(sunspot(3:202, 1), Tu, 'r-o');
plot(sunspot(3:202, 1), Tsu, 'b-o');
xlabel('Metai');
ylabel('Demiu skaicius');
grid on;
legend('Tikrosios demiu reiksmes', ...
    'Prognozuojamos demiu reiksmes');
title('Saules demiu prognozavimo kokybes patikrinimas 1702-1901 metams');
% modelio verifikacija 1702-2014
Ts = sim(net, P);
figure(4), hold on;
plot(sunspot(3:315, 1), T, 'r-o');
plot(sunspot(3:315, 1), Ts, 'b-o');
xlabel('Metai');
ylabel('Demiu skaicius');
grid on;
legend('Tikrosios demiu reiksmes', ...
    'Prognozuojamos demiu reiksmes');
title('Saules demiu prognozavimo kokybes patikrinimas 1702-2014 metams');
% Prognozës klaidø vektoriaus sukûrimas
disp('Prognozës klaidø vektorius')
e = T - Ts
figure(5);
plot(sunspot(3:315), e, 'r-o');
grid on;
title('Prognozes klaidos grafikas 1702-2014 metams');
xlabel('Metai');
ylabel('Demiu skaiciaus skirtumas tarp tikrosios ir prognozuojamos reiksmiu');
% Prognozës klaidø histograma
figure(6);
hist(e);
title('Prognozes klaidu histograma');
xlabel('Prognozes klaidos reiksme');
ylabel('Daznis');
% Vidutinës kvadratinës prognozës klaidos reikðmës skaièiavimas
disp('Vidutinës kvadratinës prognozës klaidos reikðmë')
mse_reiksme = mse(e)

