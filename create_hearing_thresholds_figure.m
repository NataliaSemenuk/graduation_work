function create_hearing_thresholds_figure(freq_aud, HT, hi, freq_iso, spl, fc, interped_HT, interped_spl)
    figure;
    subplot(2,1,1); 
    plot(freq_aud, -1*HT);
    configure_figure_settings('Audiogram', 'Frequency, Hz', 'Magnitude, dB');
    xlim ([freq_aud(1) freq_aud(end)]);
    ylim ([-90 0]);

    subplot(2,1,2); 
    plot(freq_iso, spl-80);
    configure_figure_settings('Absolute audibility threshold (ISO)', 'Frequency, Hz', 'Magnitude, dB');
    xlim ([freq_iso(1) freq_iso(end)]);
    ylim ([-90 0]);

    figure;
    subplot(3,1,1); 
    plot(fc, -1*interped_HT);
    configure_figure_settings('Interped audiogram', 'Frequency, Hz', 'Magnitude, dB');
    xlim ([fc(1) fc(end)]);
    ylim ([-90 0]);

    subplot(3,1,2); 
    plot(fc, interped_spl);
    configure_figure_settings('Interped absolute audibility threshold (ISO)', 'Frequency, Hz', 'Magnitude, dB');
    xlim ([fc(1) fc(end)]);
    ylim ([-90 0]);

    subplot(3,1,3); 
    plot(fc, hi);
    configure_figure_settings('HI', 'Frequency, Hz', 'Magnitude, dB');
    xlim ([fc(1) fc(end)]);
    ylim ([-90 0]);
end

