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

subplot(2, 2, 1);
specgram(signal, 512, 2, kaiser(500,5),256);
configure_figure_settings('Input signal spectrogram', 'Time, s', 'Frequency, Hz');

subplot(2, 2, 2);
specgram(output, 512, 2, kaiser(500,5),256);
configure_figure_settings('Output signal spectrogram', 'Time, s', 'Frequency, Hz');

subplot(2, 2, 3);
plot(signal);
configure_figure_settings('Input signal', 'Time, s', 'Amplitude');

subplot(2, 2, 4); 
plot(output);
configure_figure_settings('Output signal', 'Time, s', 'Amplitude');
