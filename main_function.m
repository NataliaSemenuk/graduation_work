%common
K = 20;

bark_sc=0.5:1:19.5;
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
audio_input_signal = audio_input_sig(1, 60000:70000);

[spl, freq_iso] = iso226_rev(0);

freq_aud = [125 250 500 750 1000 2000 3000 4000 6000 8000]; % ����� ������
audiogram = [24 30 36 35 34 40 42 44 41 40]; % 1� ������� ����������

interped_audiogram = interp1(freq_aud, audiogram, fc);
interped_spl = interp1(freq_iso, spl-80, fc);

hi = interped_audiogram + interped_audiogram;

figure;
subplot(2,1,1); 
plot(freq_aud, audiogram);
configure_figure_settings('Audiogram', 'Frequency, Hz', 'Amplitude, dB');
subplot(2,1,2); 
plot(freq_iso, spl-80);
configure_figure_settings('Absolute audibility threshold (ISO)', 'Frequency, Hz', 'Amplitude, dB');

figure;
subplot(3,1,1); 
plot(fc, interped_audiogram);
configure_figure_settings('Interped audiogram', 'Frequency, Hz', 'Amplitude, dB');
subplot(3,1,2); 
plot(fc, interped_spl);
configure_figure_settings('Interped absolute audibility threshold (ISO)', 'Frequency, Hz', 'Amplitude, dB');
subplot(3,1,3); 
plot(fc, hi);
configure_figure_settings('HI', 'Frequency, Hz', 'Amplitude, dB');

%%
xdB = [0 -80 -90];
ydB = [-15 -20 -90];

coefficient_a = 0.9900; % attack time coefficient
coefficient_b = 0.9992; % release time coefficient

audio_output_signal = gammatoneFast(audio_input_signal, fc);

corrected_audio_output_signal = audio_output_signal.*1.8;
%%
frame_size = 256;
N_frames=floor(length(corrected_audio_output_signal(1,:))/frame_size);
p_start = 2 ^ (-10);

synthesized_audio_output_signal = zeros(1, N_frames * frame_size);
processed_audio_output_signal = zeros(K, N_frames * frame_size);
y = zeros(1, N_frames * frame_size);

for M=1:K
    p_level = zeros(1, length(corrected_audio_output_signal(M, :)));
    
    for N=1:N_frames
        i_beg = (N-1)*frame_size+1;
        i_end = N*frame_size;
        
        x_frame = corrected_audio_output_signal(M, i_beg : i_end);
        max_signal_power = max(x_frame);
        
        p_max_signal = max_signal_power^ 2;
        if p_max_signal > p_start
            p_end = p_start * coefficient_a + max_signal_power * (1 - coefficient_a);
        else
            p_end = p_start * coefficient_b + max_signal_power * (1 - coefficient_b);
        end
        
        p_start = p_end;
        
        p_end_db   = 10*log10(p_end);
        p_out_db = interp1(xdB, ydB, [p_end_db], 'linear');
        g_end_db = p_out_db - p_end_db;
        g_end = 10^(g_end_db / 20);
                        
        y(1+(N-1)*frame_size:N*frame_size) = x_frame.*g_end;
    end
    synthesized_audio_output_signal = synthesized_audio_output_signal + y;
    processed_audio_output_signal(M, :) = y;
end
%%
%[r, c] = size(corrected_audio_output_signal);
%p = zeros(K,c);

%p(:,1) = 2 .^ (-10);

%for i = 2:K
%    p_corrected_audio_output_signal = corrected_audio_output_signal(i,:) .^ 2; 
%    if p_corrected_audio_output_signal(i) > p(i - 1)
%        p(i,:) = p(i - 1).*coefficient_a + p_corrected_audio_output_signal(i).*(1 - coefficient_a);
%    else
%        p(i,:) = p(i - 1).*coefficient_b + p_corrected_audio_output_signal(i).*(1 - coefficient_b);
%    end
%end

%p_start = 10 * log10(p);
%p_out_start = interp1(xdB,ydB,p_start,'linear');

%g = 10 .^ ((p_out_start - p_start) / 20);

%processed_audio_output_signal = corrected_audio_output_signal .* g;

%synthesized_audio_output_signal = sum(processed_audio_output_signal);
%%
% ������������ �������������� ���������� 
figure
plot(xdB, ydB);
grid on;
configure_figure_settings('Static Characteristic', 'Input, dB', 'Output, dB');
xlim([-90 0]);
ylim([-90 0]);

% ������� � �������� ������
figure
subplot(2,1,1); 
plot(corrected_audio_output_signal)
title('Input signal')
ylim([-1 1]);

subplot(2,1,2);
plot(processed_audio_output_signal)
title('Output signal')
ylim([-1 1]);

%%
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