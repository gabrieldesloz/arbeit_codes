clc;
clear all; 
close all;

wp = 0.2*pi;
ws = 0.3*pi;
Rp = 0.25;
As = 50;

%plotar pontos gabarito

tr_width = ws -wp; % largura de banda de transiçao
M = ceil(6.6*pi/tr_width) + 1; % calculo darodem

n = [0:1:M-1]; % vetor dos coeficientes
wc = (ws+wp)/2; % frequencia central
hd = ideal_lp(wc,M); % implementa expressão ...
w_ham = (hamming(M));
h = hd.*w_ham;
[db,maf,pha,grd,m] = freqz_n(h,[1]); % coeficientes "a" = 1, retorna
% fase etc...

figure(1)
subplot(2,2,1)
plot(w/pi,db) % normalizando em relação pi
hold %hold  para segurar graficos
%colocar gabarito
plot( [0 ws/pi ws/pi pi/pi],[0 0 ;As ;As], 'r', [0 wp/pi wp/pi], [-Rp -Rp -200], 'r' );
axis([0 1 -90 10])
ylabel('db');
xlabel('Unidades de pi')
grid
subplot(2,2,3)
plot(w/pi,mag)
subplot(2,2,3)
plot(2,2,4)
plot(w/pi,grd) % atraso de grupo - figura de merito para estimar quao linear é a fase
