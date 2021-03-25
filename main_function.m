%common
K = 22;

bark_sc=0.5:1:21.5;
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
audio_input_sig = audio(:,1)';
audio_input_signal = audio_input_sig(1, 20000:30000);

xdB = [0 -70 -90];
ydB = [-15 -20 -90];

coefficient_a = 0.9900; % attack time coefficient
coefficient_b = 0.9992; % release time coefficient

audio_output_signal = gammatoneFast(audio_input_signal, fc);

corrected_audio_output_signal = audio_output_signal.*1.8;

%Найти можность для каждой полосы
[r, c] = size(corrected_audio_output_signal);
p = zeros(K,c);

p(1,:) = 2 .^ (-10);
    
for i = 2:K
    p_corrected_audio_output_signal = corrected_audio_output_signal(i,:) .^ 2; 
    if p_corrected_audio_output_signal(i) > p(i - 1)
        p(i,:) = p(i - 1).*coefficient_a + p_corrected_audio_output_signal(i).*(1 - coefficient_a);
    else
        p(i,:) = p(i - 1).*coefficient_b + p_corrected_audio_output_signal(i).*(1 - coefficient_b);
    end
end

p_start = 10 * log10(p);
p_out_start = interp1(xdB,ydB,p_start,'linear');

g = 10 .^ ((p_out_start - p_start) / 20);

%for i = 1:K
%    processed_audio_output_signal(i) = corrected_audio_output_signal(i) * g(i);
%end
processed_audio_output_signal = corrected_audio_output_signal.*1;
synthesized_audio_output_signal = sum(processed_audio_output_signal);

% Передаточная характеристика устройства 
figure
plot(xdB, ydB);
grid on;
title('Static Characteristic') % for limiter
xlabel('Input (dB)');
ylabel('Output (dB)');
xlim([-90 0]);
ylim([-90 0]);


% Входной и выходной сигнал
figure
subplot(2,1,1); 
plot(corrected_audio_output_signal)
title('Input signal')
ylim([-1 1]);

subplot(2,1,2);
plot(processed_audio_output_signal)
title('Output signal')
ylim([-1 1]);

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

audiowrite('output_signal.wav',synthesized_audio_output_signal,fs);

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