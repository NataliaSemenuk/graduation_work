function create_characteristic_drc_input_output_figure(drc_in, drc_out)
    % ѕередаточна€ характеристика устройства 
    figure;
    plot(drc_in, drc_out);
    grid on;
    configure_figure_settings('DRC Characteristic', 'Input magnitude, dB', 'Output magnitude, dB');
    xlim([-90 0]);
    ylim([-90 0]);
end

