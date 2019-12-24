clc; clf; clear all;


%-------------conversão------------------------
%bits conversao
bits_adc = 8;
%niveis_adc - % 2^8 = 256 niveis
Niveis_adc = 2^bits_adc;                        
%amplitude v
amp = 1;
%numero de ciclos
ciclos = 10;
%pontos por ciclo
ppc = 80;
%frequencia fixa input
f = 60;

%frequencia de amostragem
Fs = ppc*f; 
%vetor tempo
t = 0:1/Fs:(ciclos*(1/f)) - 1/Fs;

% Quantizer's dynamic range
Dynamic_Range = 2;      
% offset DC
DC_Offset = Dynamic_Range / 2;
%forma de onda 1, com offset
SH_op = DC_Offset + amp*sin(2*pi*f*t);


%quantização------------------------------------------------------

Stepsize = Dynamic_Range/(Niveis_adc - 1);  %Stepsize = 2V/255
Rep_levels = [];

% 256 levels with spacing of "Stepsize"
for i = 0:1:Niveis_adc - 1
    Rep_levels = [Rep_levels i*Stepsize];   
end

Quantized_op = [];
for i = 1:1:length(SH_op)
    [minValue,minIndex] = min(abs(SH_op(i) - Rep_levels));  % Get rep level closest to each SH_op
    Quantized_op = [Quantized_op Rep_levels(minIndex)];     % Quantize to that value
end


figure(1);
stairs(t,SH_op);
xlabel('Time in s');
ylabel('Voltage in V');
title('S/H ouptut');
axis auto;
figure(1);
stairs(t,Quantized_op);
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
ADC_op_bin = [];
ADC_op_bin = [ADC_op_bin dec2bin(Quantized_op / Stepsize)];
ADC_op_dec = [];
ADC_op_dec = [ADC_op_dec (Quantized_op / Stepsize)];








