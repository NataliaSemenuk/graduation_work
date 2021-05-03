function create_input_output_signal_figure(audio_input_signal, synthesized_audio_output_signal, fs, freq_aud)
    figure; 
    
    subplot(2, 2, 1);
    specgram(audio_input_signal, 512, fs, kaiser(512,7),475);
    ylim ([0 freq_aud(end)]);    
    configure_figure_settings('Спектрограмма входного сигнала', 'Время, с', 'Частота, Гц');

    subplot(2, 2, 2);
    specgram(synthesized_audio_output_signal, 512, fs, kaiser(512,7),475);
    ylim ([0 freq_aud(end)]);    
    configure_figure_settings('Спектрограмма выходного сигнала', 'Время, с', 'Частота, Гц');

    subplot(2, 2, 3);
    plot((1:length(audio_input_signal)) / fs, audio_input_signal);
    ylim ([-2 2]);    
    configure_figure_settings('Временное представление сигнала', 'Время, с', 'Амплитуда, дБ');

    subplot(2, 2, 4); 
    plot((1:length(synthesized_audio_output_signal)) / fs, synthesized_audio_output_signal');
    ylim ([-2 2]);    
    configure_figure_settings('Временное представление сигнала', 'Время, с', 'Амплитуда, дБ');
end

