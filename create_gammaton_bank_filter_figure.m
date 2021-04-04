function create_gammaton_bank_filter_figure(corrected_output_signal, K)
    figure;
    hold on;
    set(gca, 'YLim', [-90 0]);
    configure_figure_settings('Proccesing signal', 'Normalized Frequency, Hz', 'Magnitude, dB');

    for N=1:K-1
        [h, w] = freqz(corrected_output_signal(N,:));
        hDb  = 20*log10(h);
        wHz = w / 2 * pi;
        plot(wHz, hDb);
    end
end

