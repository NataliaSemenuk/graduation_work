%common
K = 24;

bark_sc=0.5:1:23.5;
fc = bark2frq(bark_sc);

%1
input_signal = zeros(1,2^12);
input_signal(1,1) = 1;

output_signal = gammatoneFast(input_signal, fc);

corrected_output_signal = output_signal.*1.8;

figure;
hold on;
set(gca, 'YLim', [-90 0]);
configure_figure_settings('Proccesing signal', 'Normalized Frequency (H)', 'Magnitude (dB)');

for N=1:K
    [h, w] = freqz(corrected_output_signal(N,:));
    hDb  = 20*log10(h);
    wHz = w / 2 * pi;
    plot(wHz, hDb);
end

%2
[audio, fs] =  audioread("1.mp3");
audio_input_signal = audio(:,1)';

audio_output_signal = gammatoneFast(audio_input_signal, fc);

corrected_audio_output_signal = audio_output_signal.*1.8;

processed_audio_output_signal = corrected_audio_output_signal.*1;

synthesized_audio_output_signal = sum(processed_audio_output_signal);

audiowrite('output_signal.wav',synthesized_audio_output_signal,fs);

figure; 

subplot(2, 2, 1);
specgram(audio_input_signal, 512, 2, kaiser(500,5),256);
configure_figure_settings('Input signal spectrogram', 'Time, s', 'Frequency, Hz');

subplot(2, 2, 2);
specgram(synthesized_audio_output_signal, 512, 2, kaiser(500,5),256);
configure_figure_settings('Output signal spectrogram', 'Time, s', 'Frequency, Hz');

subplot(2, 2, 3);
plot(audio_input_signal);
configure_figure_settings('Input signal', 'Time, s', 'Amplitude, dB');

subplot(2, 2, 4); 
plot(synthesized_audio_output_signal);
configure_figure_settings('Output signal', 'Time, s', 'Amplitude, dB');

%input =  audioread("1.mp3");
	
%signal = input(:,1)';
%frame_size = 256;
%N_frame = floor(length(signal)/frame_size);
%output = zeros(1,length(signal));

%for N=1:N_frame
%    x_frame = signal(1+(N-1)*frame_size:N*frame_size);
%    fft_frame = fft(x_frame);
%    
%    proccesing_fft_frame = fft_frame.*1;
%    
%    ifft_frame = ifft(proccesing_fft_frame);
%    output(1+(N-1)*frame_size:N*frame_size) = ifft_frame;
%end

%figure; 

%subplot(2, 2, 1);
%specgram(signal, 512, 2, kaiser(500,5),256);
%configure_figure_settings('Input signal spectrogram', 'Time, s', 'Frequency, Hz');

%subplot(2, 2, 2);
%specgram(output, 512, 2, kaiser(500,5),256);
%configure_figure_settings('Output signal spectrogram', 'Time, s', 'Frequency, Hz');

%subplot(2, 2, 3);
%plot(signal);
%configure_figure_settings('Input signal', 'Time, s', 'Amplitude');

%subplot(2, 2, 4); 
%plot(output);
%configure_figure_settings('Output signal', 'Time, s', 'Amplitude');
