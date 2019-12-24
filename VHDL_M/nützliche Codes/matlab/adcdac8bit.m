% ***********************************************************
% *************** 8 bit ADC and DAC simulation***************
% ***********************************************************
f = 10^6;                       % 10MHz i/p signal
Fs = 100*f;                      % 100MHz Sampling freq
amp = 1;                        % i/p signal amplitude
Dynamic_Range = 2;              % Quantizer's dynamic range
DC_Offset = Dynamic_Range / 2;

%**************** S/H ******************
t = 0:1/Fs:1/f - 1/Fs;
SH_op = DC_Offset + amp*sin(2*pi*f*t);     %Add offset to obtain positive voltage values

%************* A/D Conversion ***********
%************* Quantization *************
No_rep_levels = 256;                        % 2^8 = 256 levels
Stepsize = Dynamic_Range/(No_rep_levels - 1);  %Stepsize = 2V/255
Rep_levels = [];

for i = 0:1:No_rep_levels - 1
    Rep_levels = [Rep_levels i*Stepsize];   % 256 levels with spacing of "Stepsize"
end

Quantized_op = [];
for i = 1:1:length(SH_op)
    [minValue,minIndex] = min(abs(SH_op(i) - Rep_levels));  % Get rep level closest to each SH_op
    Quantized_op = [Quantized_op Rep_levels(minIndex)];     % Quantize to that value
end
subplot(5,1,1);
stairs(t*10^6,SH_op);
xlabel('Time in us');
ylabel('Voltage in V');
title('S/H ouptut');

subplot(5,1,2);
stairs(t*10^6,Quantized_op);
xlabel('Time in us');
ylabel('Voltage in V');
title(['Quantized output (Step size = ',num2str(Dynamic_Range),'V/255 = ',num2str(Stepsize*10^3),'mV)']);

%****************** Quantization Error ******************
Quantization_Noise = Quantized_op - SH_op; 
subplot(5,1,3);
plot(Quantization_Noise*10^3);
xlabel('Sample Number');
ylabel('Error in mV');
title('Quantization Noise');
Q_Noise_power = var(Quantization_Noise);    % Simulated value
Q_Noise_power_th = Stepsize/12;             % Theoretical value

%************* Digital Code Generation *****************
ADC_op = [];
ADC_op = [ADC_op dec2bin(Quantized_op / Stepsize)];

%************** End of ADC *****************************

%************** D/A Coversion *************************
DAC_op = [];
for i = 1:1:length(ADC_op)
    b7 = str2num(ADC_op(i,1))*128;
    b6 = str2num(ADC_op(i,2))*64;
    b5 = str2num(ADC_op(i,3))*32;
    b4 = str2num(ADC_op(i,4))*16;
    b3 = str2num(ADC_op(i,5))*8;
    b2 = str2num(ADC_op(i,6))*4;
    b1 = str2num(ADC_op(i,7))*2;
    b0 = str2num(ADC_op(i,8))*1;
    D_to_A = (b7 + b6 + b5 + b4 + b3 + b2 + b1 + b0) * (Dynamic_Range / 255);
DAC_op = [DAC_op D_to_A];
end
subplot(5,1,4);
stairs(t*10^6,DAC_op);
xlabel('Time in us');
title('DAC output');

subplot(5,1,5);
plot((DAC_op - SH_op)*10^3);
xlabel('Sample Number');
ylabel('Error in mV');
title('Difference between SH o/p and DAC o/p');

% ***************** End of DAC ********************
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
