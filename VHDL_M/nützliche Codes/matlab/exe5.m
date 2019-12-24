%exemplo5
clc
clear all
close all



Wp = 0.2*pi;
Ws = 0.3*pi;
Rp = 1;
As = 15;

T = 1;

OmegaP = Wp/T;
OmegaS = Ws/T;

%analogo
[cs,ds] = afd_chb1(OmegaP,OmegaS,Rp,As);

%digital
[b,a] = imp_invr(cs,ds,T); 
[C,B,A] = dir2par(b,a); %dircas

[db,mag,pha,grd,w] = freqz_m(b,a);



%graficos

figure(1)
subplot(2,2,1)
semilogx(w/pi,db);
hold
plot( [w(2)/pi ws/pi ws/pi pi/pi ], [0 0 -As -As], 'r', [w(2)/pi w/pi w/pi], [-Rp -Rp -50],'r'); 
ylabel('dB');
xlabel('Unidades de pi');
grid


subplot(2,2,2)
semilogx(w/pi,unwrap(pha));
ylabel('Fase');
xlabel('Unidades de pi');
grid

subplot(2,2,2)
semilogx(w/pi,grd);
ylabel('Atraso de grupo(2)');
xlabel('Unidades de pi');
grid


subplot(2,2,4);
t = 0:T:30;
%vetor impulso
delta = [1, zeros(1, lenght(t)-1)]
% resposta do sistema
h  = filter(b,a,delta);
stem(t,h);



