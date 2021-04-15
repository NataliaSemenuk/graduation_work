function create_hearing_thresholds_figure(freq_aud, HT, hi, freq_iso, spl, fc, interped_HT, interped_spl)
    figure;

    array = 1:length(freq_aud);
    hold on;
    plot (array,-1*HT,'k','LineWidth',2);
    ylim ([-70 10]);
    xlim ([array(1) array(end)]);

    plot (array,-1*HT,'ok','LineWidth',2);
    grid on;
    set(gca, 'YTickLabel', [70:-10:-10]); %90,80,70,60,50,40,30,20,10,0,-10
    set(gca, 'XTickLabel',freq_aud);
    set(gca, 'XTick',array(1):array(end));
    set(gca, 'FontName', 'Times New Roman');
    set(gca, 'FontSize', 14);
    set(gca, 'Clim', [-65 15]);
    title('Audiogram');
    xlabel('Frequency, Hz');
    ylabel('Magnitude, dB');

    figure;
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

