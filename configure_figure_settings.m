function configure_figure_settings(titleSpecgram, xlabelSpecgram, ylabelSpecgram)
    set(gca, 'Clim', [-65 15]);
    title(titleSpecgram);
    xlabel(xlabelSpecgram);
    ylabel(ylabelSpecgram);
    set(gca, 'FontSize', 10);
    %set(gca, 'FontName', 'Times New Roman');
end