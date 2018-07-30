clear all; close all;
figure(1) = image(imread('car.png'));

[X, Y] = ginput(22)  %skliausteliuose taðkø skaièius
yylim = ylim
dify = yylim(2)-yylim(1)
Y = dify-Y
dlmwrite('autox.txt', X);
dlmwrite('autoy.txt', Y); fclose all;