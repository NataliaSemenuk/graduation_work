function create_input_output_signal_figure(audio_input_signal, synthesized_audio_output_signal)
    figure; 
    subplot(2, 2, 1);
    specgram(audio_input_signal, 512, 2, kaiser(500,5),256);
    configure_figure_settings('Input signal spectrogram', 'Time, s', 'Frequency, Hz');

    subplot(2, 2, 2);
    specgram(synthesized_audio_output_signal, 512, 2, kaiser(500,5),256);
    configure_figure_settings('Output signal spectrogram', 'Time, s', 'Frequency, Hz');

    subplot(2, 2, 3);
    plot(audio_input_signal);
    configure_figure_settings('Input signal', 'Time, s', 'Magnitude, dB');

    subplot(2, 2, 4); 
    plot(synthesized_audio_output_signal);
    configure_figure_settings('Output signal', 'Time, s', 'Magnitude, dB');
end

