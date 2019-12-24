clc;
clear all;
%projetar um filtro butterworth analogico
%omegap, omegas, Rp, As
addpath('H:/estudos/especializacao/dsp/PWS_DSP');

Wp = 0.2*pi;
Ws = 0.3*pi;
Rp = 7;
As = 16;

%analog filter design
[b,a] = afd_butt(Wp,Ws,Rp,As)

% 2cond order - cascata
[C,B,A] = sdir2cas(b,a);

%frequency response
[db, mag, pha, W] = freqs_m(b,a,pi);

figure(1)
semilogx(W,db)
hold on
%gabarito
plot([0.001 Ws Ws 10],[0 0 -As -As], 'r');
plot([0.001 Wp Wp],[-Rp -Rp -50],'r');
axis([0.1 0.5*pi -50 10]);

grid






