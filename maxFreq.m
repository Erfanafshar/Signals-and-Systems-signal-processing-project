function peak = maxFreq(address)
% read audio and set data and dataLength
[y,Fs] = audioread(address);
dataLength = length(y);
data = transpose(y);

% calculate the signal power and frequency domain
signalpower = abs(fft(data)/dataLength).^2;
signalPower = signalpower(1:length(data)/2+1)/dataLength;
hz = linspace(0,Fs/2,floor(dataLength/2)+1);

% get picks and find the maximum pick from these picks
[pks,frqs] = findpeaks(signalPower,hz);
maxIndex = pks == max(pks);
peak = frqs(maxIndex);
end

