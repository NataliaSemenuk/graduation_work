input =  audioread("1.mp3");
	
signal = input(:,1)';
frame_size = 256;
N_frame = floor(length(signal)/frame_size);
output = zeros(1,length(signal));

for N=1:N_frame
    x_frame = signal(1+(N-1)*frame_size:N*frame_size);
    fft_frame = fft(x_frame);
    
    proccesing_fft_frame = fft_frame.*1;
    
    ifft_frame = ifft(proccesing_fft_frame);
    output(1+(N-1)*frame_size:N*frame_size) = ifft_frame;
end
        
figure; 
subplot(2, 1, 1);
plot(signal);
subplot(2, 1, 2); 
plot(output);

figure; 
subplot(2, 1, 1);
specgram(signal);
subplot(2, 1, 2);
specgram(output);