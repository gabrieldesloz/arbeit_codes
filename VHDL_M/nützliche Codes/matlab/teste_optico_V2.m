%---------------------------------------------------------------------%
% Modelo me medição com o sensor Faraday                              %
% Autor: Emiliano A. Veiga                                            %  
% emiliano@poweropticks.com                                           %
%---------------------------------------------------------------------%

clc
clear all
ts = 1/5760;             %freq de amostrage
t=0:ts:0.2;              %tempo de amostragem
Vref = 1.25;             %tensao referencia offset
f = 60;                  %frequencia da rede
Ip = 2000;               %valor da corrente
s = Ip*sin(2*pi*f*t);    %gerando sinal do link


%kfs= 10e-4               %ganho angular do sensor farady 
%kfs= 10e-6               %ganho angular do sensor farady 
kfs= 10e-5               %ganho angular do sensor farady 


%simular aquisicao sensor optico
Ang = 45 + s * kfs ;
Vx = cos(Ang) + Vref;
Vy = sin(Ang) + Vref;

%plotar sinal link
figure(1)
plot(t,Vx);
grid
title('Vx');
figure(2)
plot(t,Vy)
grid
title('Sinal do link');

%plotar sinais Vx e Vy
figure(2)
subplot(2,1,1)
plot(t,Vx,'black');
title('Sensor - Vx');
grid
subplot(2,1,2)
plot(t,Vy,'red');
title('Sensor - Vy');
grid


%calcula diferença normalizada
dif=(Vx-Vy)./(Vx+Vy);
figure(3)
plot(dif);
grid
title('Dif sem retirar o offset');


off= mean(dif);
figure(4)
plot(t,off);
title('offset');


dif = dif-off;
%plotar diferença
figure(5)
plot(dif);
grid
title('Sinal Vx-Vy sem offset');

%calcula ganho fino de leitura
Ef1= mean(s.*s)^0.5 
Ef2= mean(dif.*dif)^0.5
Kfinal = Ef1/Ef2


%Relaciona a medição ao sinal original
Imedido= -1*dif*Kfinal;
t1=1:96*2;
figure(6)
plot(t1,s(t1),'black',t1,Imedido(t1),'blue');
grid
title('Sinal medido e sinal original');

%calcula o erro entre a medição ao sinal original
erro= s-Imedido;
t1=1:96*2;
figure(7)
plot(t1,erro(t1),'red');
grid
title('Erro: Sinal original - sinal medido');











