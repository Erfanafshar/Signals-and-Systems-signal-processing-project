close all;
clear all;
[y ,fs]= audioread('test.wav');
%sound(y,fs);
%plot(y)
y = awgn(y, 30);
%plot(y)
%sound(y,fs);
signal_len = length(y);
frame_len=1.0*fs;
frame_step=0.01*fs;


num_frames =1+ ceil((signal_len - frame_len)/frame_step);
padded_len = (num_frames-1)*frame_step + frame_len;

padded_y = [y', zeros(1, padded_len - signal_len)];

indices = repmat(1:frame_len, num_frames, 1) + repmat((0: frame_step: num_frames*frame_step-1)', 1, frame_len);
frames = padded_y(indices);
noise_frames = floor(0.5*fs/frame_step);
window_fn = repmat(hamming(frame_len)', size(frames, 1), 1);
windowed_frames = frames.* window_fn;

Y_spec = fft(frames,frame_len,2);



Ymag_spec = abs(Y_spec).^2; 
%figure(1);
%subplot(2,1,1);
%plot(Ymag_spec(noise_frames,:));
%title('Power Spectrum of Noisy signal of a single frame');
%xlabel('Samples');ylabel('Amplitude');
phase = angle(Y_spec); 

noise_psd = mean(Ymag_spec(1:noise_frames,:));
clean_spec = Ymag_spec - repmat(noise_psd,size(Ymag_spec,1),1); 
clean_spec(clean_spec < 0) = 0; 


%figure(1);
%subplot(2,1,2);
%plot(clean_spec(noise_frames,:));
%title('Power Spectrum of clean signal of a single frame');
%xlabel('Samples');ylabel('Amplitude');
j=sqrt(-1);
reconstructed_frames = ifft(sqrt((clean_spec).*exp(j*phase)),frame_len,2);
reconstructed_frames = real(reconstructed_frames); 
clean_signal = zeros(1,padded_len);
window_correction = zeros(1,padded_len);
window_fn = hamming(frame_len)';
for i = 1:num_frames
    window_correction(indices(i,:)) = window_correction(indices(i,:)) + window_fn;
    clean_signal(indices(i,:)) = clean_signal(indices(i,:)) + reconstructed_frames(i,:);
end

plot(clean_signal);
clean_signal = clean_signal./window_correction;
%sound(clean_signal,fs);
%sound(y,fs);

