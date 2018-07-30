function saknu_intervalai
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
    a = [1 5 -2 -24];
    n = numel(a);
    [R_grub, R_neig, R_teig]=Reziai(n, a);
    colors = ['g', 'r', 'b', 'k', 'y', 'c'];
    % ------------------------------------
    % ðaknø intervalø atskyrimas daugianariui f(x)
    zingsnis = 0.35; % zingsnio nustatymas
    [SaknuIntervalai_fx]=SkenavimasPastoviu(R_neig, R_teig, zingsnis, f);
    SaknuIntervalai_fx
    % daugianario f(x) ir jo ðaknø intervalø atvaizdavimas
    figure(1); hold on; grid on;
    tikslus_intervalas = R_neig:0.1:R_teig;
    plot([R_neig R_teig], [0 0], 'bp', 'LineWidth', 2);
    plot(tikslus_intervalas, f(tikslus_intervalas), 'k-', 'LineWidth', 2);
    for i = 1:length(SaknuIntervalai_fx)
        plot(SaknuIntervalai_fx(i, 1), 0*SaknuIntervalai_fx(i, 1), 'o', 'MarkerFaceColor', colors(i), 'MarkerSize', 5);
        plot(SaknuIntervalai_fx(i, 2), 0*SaknuIntervalai_fx(i, 2), 'o', 'MarkerFaceColor', colors(i), 'MarkerSize', 5);
    end
    title(['f(x)=', f_name, ' Ðaknø atskyrimo intervalai. Þingsnis: ', num2str(zingsnis)]);
    legend('f(x) ðaknø intervalo rëþiai', 'Daugianaris f(x)');
    axis([R_neig R_teig -25 50]);
    % ------------------------------------
    % ðaknø intervalø atskyrimas funkcijai g(x)
    zingsnis = 0.2; % zingsnio nustatymas
    g_min = 1;
    g_max = 20;
    g_intervalas = g_min:0.1:g_max;
    [SaknuIntervalai_gx]=SkenavimasPastoviu(g_min, g_max, zingsnis, g);
    SaknuIntervalai_gx
    figure(2); hold on; grid on;
    plot([g_min g_max], [0 0], 'rp', 'LineWidth', 2);
    plot(g_intervalas, g(g_intervalas), 'k-', 'LineWidth', 2);
    for i = 1:length(SaknuIntervalai_gx)
        plot(SaknuIntervalai_gx(i, 1), 0*SaknuIntervalai_gx(i, 1), 'o', 'MarkerFaceColor', colors(i), 'MarkerSize', 5);
        plot(SaknuIntervalai_gx(i, 2), 0*SaknuIntervalai_gx(i, 2), 'o', 'MarkerFaceColor', colors(i), 'MarkerSize', 5);
    end
    title(['g(x)=', g_name, ' Ðaknø atskyrimo intervalai. Þingsnis: ', num2str(zingsnis)]);
    legend('funkcijos g(x) intervalo rëþiai', 'Funkcija g(x)');
    axis([g_min g_max -6 2]);
end