% read audio and set data and dataLength
[y,Fs] = audioread('voices\v1.mp3');
dataLength = length(y);
data = transpose(y);

% calculate power and freqency domain
power = abs(fft(data).^2/dataLength);
hz = linspace(0,Fs/2,floor(dataLength/2)+1);

% stem power spectrum
stem(hz, power(1:length(hz)));  
xlabel('Frequency'), ylabel('Power');
title('Power spectrum');
set(gca,'XLim',[0 1000]);


