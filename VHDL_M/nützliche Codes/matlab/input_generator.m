

% File to generate input in txt file



freq = 60;
fs = 15360;
cycles = 10;
t = 0:1/fs:(256/fs)*32;

wave = 216*sin(2*pi*freq*t);
int_wave = int16(wave);

fileID = fopen('input.txt','wt');

file_print = sprintf('%d\n', typecast(int16(int_wave),'uint16'));
fprintf(fileID,file_print);


fclose('all');

plot(wave)