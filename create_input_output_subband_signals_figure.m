function create_input_output_subband_signals_figure(corrected_audio_output_signal, processed_audio_output_signal)
    figure;
    subplot(2,1,1); 
    plot(corrected_audio_output_signal);
    configure_figure_settings('Input signal', 'Time, s', 'Magnitude, dB');
    ylim([-1 1]);

    subplot(2,1,2);
    plot(processed_audio_output_signal);
    configure_figure_settings('Output signal', 'Time, s', 'Magnitude, dB');
    ylim([-1 1]);
end

