function iverciai_ir_grafikai
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
% f(x) intervalo nustatymas
% f(x) = x.^4+5*x.^3-2*x.^2-24*x
% n = 4
% a4 = 1
% a3 = 5
% a2 = -2
% a1 = -24
a = [1 5 -2 -24];
n = numel(a);
[R_grub, R_neig, R_teig]=Reziai(n, a);
Grubus = [-R_grub R_grub]
Tikslesnis = [R_neig R_teig]
% ------------------------------------
% grafikø braiþymas
grubus_intervalas = -R_grub:0.1:R_grub;
tikslus_intervalas = R_neig:0.1:R_teig;
% ------------------------------------
% f(x) grubus
figure(1); hold on; grid on;
% plot(-min(R_grub, R_neig), 0, 'bp', 'LineWidth', 2);
% plot(min(R_grub,R_teig),0,'bp', 'LineWidth', 2);
plot([-R_grub,R_grub],[0 0],'r*', 'LineWidth', 2);
plot([R_neig R_teig], [0 0], 'bp', 'LineWidth', 2);
plot(grubus_intervalas, f(grubus_intervalas), 'k-', 'LineWidth', 2);
title(['f(x)=', f_name, ' Grubus intervalas.']);
legend('Grubus ðaknø intervalo ávertis', 'Tikslesnis ðaknø intervalo ávertis', 'Daugianaris f(x)');
axis([-R_grub R_grub -R_grub R_grub]);
plot([-R_grub, R_grub], [0, 0], 'b'); % X aðies linija
% ------------------------------------
% f(x) tikslus
figure(2); hold on; grid on;
plot([-R_grub,R_grub],[0 0],'r*', 'LineWidth', 2);
plot([R_neig R_teig], [0 0], 'bp', 'LineWidth', 2);
plot(tikslus_intervalas, f(tikslus_intervalas), 'k-', 'LineWidth', 2);
title(['f(x)=', f_name, ' Tikslus intervalas.']);
legend('Grubus ðaknø intervalo ávertis', 'Tikslesnis ðaknø intervalo ávertis', 'Daugianaris f(x)');
axis([R_neig R_teig -25 50]);
plot([-R_grub, R_grub], [0, 0], 'b'); % X aðies linija
% ------------------------------------
% g(x)
figure(3); hold on; grid on;
g_min = 1;
g_max = 20;
g_intervalas = g_min:0.1:g_max;
plot([g_min g_max], [0 0], 'r*', 'LineWidth', 2);
plot(g_intervalas, g(g_intervalas), 'k-', 'LineWidth', 2);
title(['g(x)=', g_name]);
legend('funkcijos g(x) intervalo rëþiai', 'Funkcija g(x)');
axis([g_min g_max -6 2]);
plot([-R_grub, R_grub], [0, 0], 'b'); % X aðies linija
end