clear all; close all; clc;
figure(1) = image(imread('carxy.png'));
[X,Y] = ginput(20)
yylim = ylim;
dify = yylim(2)-yylim(1)
Y = dify-Y
dlmwrite('carx.txt', X);
dlmwrite('cary.txt', Y); fclose all;