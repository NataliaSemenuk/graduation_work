function create_gammaton_bank_filter_figure(corrected_output_signal, K, fs, freq_aud)
    figure;
    hold on;
    set(gca, 'YLim', [-90 0]);

    configure_figure_settings('', 'Частота, Гц', 'Амплитуда, дБ');

    for N=1:K-1
        [h, w] = freqz(corrected_output_signal(N,:),1,4096);
        hDb  = 20*log10(h);
        wHz = w/pi*(fs/2);
        plot(wHz, hDb, 'LineWidth',2.5);
    end
    grid on;
    ylim ([ -72 0]);
end

