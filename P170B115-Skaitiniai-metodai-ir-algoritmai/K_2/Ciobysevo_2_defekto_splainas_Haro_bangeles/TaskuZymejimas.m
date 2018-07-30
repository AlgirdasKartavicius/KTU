function TaskuZymejimas
clear all; close all; clc;
figure(1) = image(imread('car1.jpg')); % pav nuskaitymas i faila;
 axis([0 600 0 200])
[X,Y] = ginput(32)
yylim = ylim;
dify = yylim(2)-yylim(1)
Y = dify-Y
dlmwrite('carxx.txt',X);
dlmwrite('caryy.txt',Y);
fclose all;
end