function create_hearing_thresholds_figure(freq_aud, HT, hi, freq_iso, spl, fc)
    figure;
    array = 1:length(freq_aud);
    hold on;
    plot (array, -1*HT, 'k', 'LineWidth', 2);
    ylim ([-70 10]);
    xlim ([array(1) array(end)]);
    plot (array,-1*HT, 'ok', 'LineWidth', 2);
    grid on;
    set(gca, 'YTickLabel', [70:-10:-10]); %90,80,70,60,50,40,30,20,10,0,-10
    set(gca, 'XTickLabel',freq_aud);
    set(gca, 'XTick',array(1):array(end));
    set(gca, 'Clim', [-65 15]);
    configure_figure_settings('Аудиограмма при 2-ой степени тугоухости', 'Частота, Гц', 'Потеря слуха, дБ');

    figure;
    plot(freq_iso, spl-80, 'k', 'LineWidth', 2);
    configure_figure_settings('Абсолютный порог слышимости', 'Частота, Гц', 'Амплитуда, дБ');
    xlim ([freq_iso(1) freq_iso(end)]);
    ylim ([-90 0]);
    grid on;

    figure;
    plot(fc, hi, 'k', 'LineWidth', 2);
    configure_figure_settings('Порог слышимости при патологиии', 'Частота, Гц', 'Амплитуда, дБ');
    xlim ([fc(1) fc(end)]);
    ylim ([-90 0]);
    grid on;
end

