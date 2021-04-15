function create_input_output_signal_figure(audio_input_signal, synthesized_audio_output_signal, fs)
    figure; 
    
    subplot(2, 2, 1);
    %set(gca, 'XTickLabel',freq_aud);
    specgram(audio_input_signal, 512, fs, kaiser(512,7),475);
    configure_figure_settings('Input signal spectrogram', 'Time, s', 'Frequency, Hz');

    subplot(2, 2, 2);
    specgram(synthesized_audio_output_signal, 512, fs, kaiser(512,7),475);
    configure_figure_settings('Output signal spectrogram', 'Time, s', 'Frequency, Hz');

    subplot(2, 2, 3);
    plot((1:length(audio_input_signal)) / fs, audio_input_signal);
    xlim ([0 length(audio_input_signal) / fs]);
    configure_figure_settings('Input signal', 'Time, s', 'Magnitude, dB');

    subplot(2, 2, 4); 
    plot((1:length(synthesized_audio_output_signal)) / fs, synthesized_audio_output_signal');
    xlim ([0 length(synthesized_audio_output_signal) / fs]);
    configure_figure_settings('Output signal', 'Time, s', 'Magnitude, dB');
end

