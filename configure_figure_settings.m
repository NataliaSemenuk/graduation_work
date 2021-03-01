function configure_figure_settings(titleSpecgram, xlabelSpecgram, ylabelSpecgram)
    set(gca, 'Clim', [-65 15]);
    title(titleSpecgram);
    xlabel(xlabelSpecgram);
    ylabel(ylabelSpecgram);
    %set(gca, 'FontName', 'Times New Roman');
    %set(gca, 'FontSize', 14);
end