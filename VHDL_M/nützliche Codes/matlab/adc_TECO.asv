clc; clf; clear all;




%-------------conversão------------------------
%bits conversao
bits_adc = 16;
%niveis_adc - % 2^8 = 256 niveis
Niveis_adc = 2^bits_adc;                        
%numero de ciclos
ciclos = 5;
%pontos por ciclo
ppc = 80;
%frequencia fixa input
f = 60;

%frequencia de amostragem
Fs = ppc*f; 
%vetor tempo
t = 0:1/Fs:(ciclos*(1/f)) - 1/Fs;

% Quantizer's dynamic range
Dynamic_Range = 4;      
% offset DC
DC_Offset = Dynamic_Range / 2;

%teco...........................................
Vref = 1.25;             %tensao referencia offset
f = 60;                  %frequencia da rede
Ip = 2000;               %valor da corrente
s = Ip*sin(2*pi*f*t);    %gerando sinal do link
kfs = 10e-5;              %ganho angular do sensor farady 
Ang = 45 + s * kfs ;
Vx = cos(Ang) + Vref;
Vy = sin(Ang) + Vref;



%quantização------------------------------------------------------

Stepsize = Dynamic_Range/(Niveis_adc - 1);  %Stepsize = 2V/255
Rep_levels = [];

% 256 levels with spacing of "Stepsize"
for i = 0:1:Niveis_adc - 1
    Rep_levels = [Rep_levels i*Stepsize];   
end

Quantized_op_Vx = [];
for i = 1:1:length(Vx)
    [minValue,minIndex] = min(abs(Vx(i) - Rep_levels));  % Get rep level closest to each SH_op
    Quantized_op_Vx = [Quantized_op_Vx Rep_levels(minIndex)];     % Quantize to that value
end


Quantized_op_Vy = [];
for i = 1:1:length(Vy)
    [minValue,minIndex] = min(abs(Vy(i) - Rep_levels));  % Get rep level closest to each SH_op
    Quantized_op_Vy = [Quantized_op_Vy Rep_levels(minIndex)];     % Quantize to that value
end



figure(1);
stairs(t,Vx);
xlabel('Time in s');
ylabel('Voltage in V');
title('S/H ouptut');
axis auto;

figure(2);
stairs(t,Vy);
xlabel('Time in s');
ylabel('Voltage in V');
title('S/H ouptut');
axis auto;


figure(3);
stairs(t,Quantized_op_Vx);
xlabel('Time in us');
ylabel('Voltage in V');
title(['Quantized output (Step size = ',num2str(Dynamic_Range),'V/255 = ',num2str(Stepsize*10^3),'mV)']);
axis auto;


figure(4);
stairs(t,Quantized_op_Vy);
xlabel('Time in us');
ylabel('Voltage in V');
title(['Quantized output (Step size = ',num2str(Dynamic_Range),'V/255 = ',num2str(Stepsize*10^3),'mV)']);
axis auto;



%Erro de quantização
% Quantization_Noise = Quantized_op - SH_op; 
% figure(3);
% plot(Quantization_Noise*10^3);
% axis auto;
% xlabel('Sample Number');
% ylabel('Error in mV');
% title('Quantization Noise');
% Q_Noise_power = var(Quantization_Noise);    % Simulated value
% Q_Noise_power_th = Stepsize/12;             % Theoretical value


%geração do codigo binario
ADC_op_bin_Vx = [];
ADC_op_bin_Vx = [ADC_op_bin_Vx dec2bin(Quantized_op_Vx / Stepsize)];
ADC_op_dec_Vx = [];
ADC_op_dec_Vx = [ADC_op_dec_Vx (Quantized_op_Vx / Stepsize)];

figure(5);
stairs(t,ADC_op_dec_Vx);
title('Vx Binario');
axis auto;


ADC_op_bin_Vy = [];
ADC_op_bin_Vy = [ADC_op_bin_Vy dec2bin(Quantized_op_Vy / Stepsize)];
ADC_op_dec_Vy = [];
ADC_op_dec_Vy = [ADC_op_dec_Vy (Quantized_op_Vy / Stepsize)];


figure(6);
stairs(t,ADC_op_dec_Vy);
title('Vy Binario');
axis auto;


%---- tansformação no formato binario

ADC_op_dec_Vx_pf = fi(ADC_op_dec_Vx,1,32,0); % sem numero fracionarios
ADC_op_dec_Vy_pf = fi(ADC_op_dec_Vy,1,32,0); % sem numero fracionarios

Vx_m_Vy = ADC_op_dec_Vx_pf - ADC_op_dec_Vy_pf;
Vx_m_Vy_pf = fi(Vx_m_Vy,1,32,0);

figure(7);
stairs(t,Vx_m_Vy);
title('Vx-Vy');
axis auto;


Vx_mm_Vy = ADC_op_dec_Vx_pf + ADC_op_dec_Vy_pf;
Vx_mm_Vy_pf = fi(Vx_mm_Vy,1,32,0);

figure(7);
stairs(t,Vx_mm_Vy);
title('Vx+Vy');
axis auto;

%BITSET, BITAND, BITOR, BITXOR, BITCMP, BITSHIFT, BITMAX


% input='010000000000000000000000';
% a=fi(0,1,24,24);
% a.bin=input
% output=a.double
% 
% fi(v,s,w,f) returns a fixed-point object with value v, signed property value
% s, word length w, and fraction length f.
% 
% bitshift
% dec2bin
% b = fi(ADC_op_dec_Vx,1,32,0)



