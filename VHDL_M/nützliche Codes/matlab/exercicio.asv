addpath('F:/estudos/especializacao/dsp/PWS_DSP');   
clc;clear;
a=[1,-1,0.9];
b=1;
delta=impseq(0,-20,210);
step=stepseq(0,-20,210);
n=[-20:100];
h=filter(b,a,delta); % resposta ao impulso
u=filter(b,a,step); % resposta ao degrau
figure(1);
subplot(2,1,1);
stem(n,h);
xlabel('resposta ao impulso');
subplot(2,1,2);
stem(n,u);
xlabel('resposta ao degrau');
sum(abs(h));
z=roots(a);



%tempo - variável independente

%vetor de amostragem





%exemplo1-a matlab
%setup
addpath('h:/estudos/especializacao/dsp/PWS_DSP');   
clc;clear;clf;
%==========

%definiçao do intervalo de amostragem
n = [-5:1:5];
x = 2*impseq(-2,-5,5) - impseq(4,-5,5);
%grafico de palitos
stem(n,x);
xlabel('resposta');


%exemplo1-b matlab
%setup
addpath('h:/estudos/especializacao/dsp/PWS_DSP');   
clc;clear;clf;
%==========

%definiçao do intervalo de amostragem
n = [0:20];
x1 = n.*(stepseq(0,0,20)-stepseq(10,0,20));  % .*  multiplicaçao elemento por elemento
x2 = 10*exp(-0.3*(n-10)).*(stepseq(10,0,20)-stepseq(20,0,20));
%grafico de palitos
x= x1 + x2;
stem(n,x);
xlabel('resposta');





%exemplo1-d matlab - sequencia 
%setup
addpath('h:/estudos/especializacao/dsp/PWS_DSP');   
clc;clear;clf;
%==========

%definiçao do intervalo de amostragem
n = [-10:9];
x = [5,4,3,2,1];
xtil = x' * ones(1,4);
xtil = (xtil(:))';
%grafico de palitos
stem(n,xtil);
xlabel('resposta');


%raizes de uma função
z = roots([3 -4 1 ]);


%transformada Z
%R vetor com as constantes, R polos, K vazio ou nao dependendo do grau do denominador
% o matlab traballha com z^-1, multiplicar tudo pelo maior denominador (^-)
% (0 z^-1 z^-2 etc)
B = [0 1];
A = [3 -4 1];
[R,P,K] = residuez(B,A); 

zplane[] %linha e coluna
freqz[]  %reposta em frequencia do sistema

[H,w] = freqz(b,a,100);
magH = abs(H); phaH = angle(H);
subplot(2,1,1); plot(w/pi,magH);
subplot(2,1,2); plot(w/pi,phaH/pi); grid;


