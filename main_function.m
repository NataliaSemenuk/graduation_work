close all; clc; 

% Инициализация констант
K = 21;
frame_size = 256;
coefficient_a = 0.9900; % attack time coefficient
coefficient_b = 0.9992; % release time coefficient
freq_aud = [125 250 500 750 1000 2000 3000 4000 6000 8000]; % сетка частот
% HT = [24 30 36 35 34 40 42 44 41 40]; % 1я степень тугоухости
HT = [43 50 50 47 45 50 52 53 58 60]; % 2я степень тугоухости
% HT = [53 66 60 62 64 54 60 67 69 70]; % 3я степень тугоухости
% HT = [70 75 76 78 80 77 79 80 82 84]; % 4я степень тугоухости
input_signal = zeros(1,2^12);
input_signal(1,1) = 1;
bark_sc=1.5:1:K-0.5;

% Выбираются центральные частоты банка фильтров в соответствии с
% психоакустической шкалой Барков
fc = bark2frq(bark_sc);
[spl, freq_iso] = iso226_rev(0);

% Считывается входного звукого сигнала
[audio, fs] =  audioread("input_signals/001.m4a");
audio_input_signal = audio(:, 1)';

output_signal = gammatoneFast(input_signal, fc);
create_gammaton_bank_filter_figure(output_signal, K, fs, freq_aud);

from_digdb_to_spl = 105;

% Нахождение порога слышимости
interped_HT = interp1(freq_aud, HT, fc, 'linear');
interped_spl = interp1(freq_iso, spl-from_digdb_to_spl, fc, 'linear');
hi = interped_HT-from_digdb_to_spl;

% Построение графиков аудиограммы, порогов слышимости в норме и при наличии
% патологии
create_hearing_thresholds_figure(freq_aud, HT, hi, freq_iso, spl, fc);

% Происходит разложение входного сигнала на субполосы
audio_output_signal = gammatoneFast(audio_input_signal, fc);

% Производится коррекция амплитуд
corrected_audio_output_signal = audio_output_signal.*1.8;

% Инициализация переменных
N_frames=floor(length(corrected_audio_output_signal(1,:))/frame_size);
p_start = repmat(2^(-10),length(1:K-1),1);
g_begin = ones(length(1:K-1));
synthesized_audio_output_signal = zeros(1, N_frames * frame_size);
processed_audio_output_signal = zeros(K, N_frames * frame_size);
y = zeros(1, N_frames * frame_size);

% Конфигурация графика компрессора динамического диапазона
figure;
configure_figure_settings('Компрессор динамического диапазона', 'Входная мощность, дБ', 'Выходная мощность, дБ');
hold on;
grid on;

for M=1:K-1
    % Определение точек перегиба компрессора динамического диапазона
    b_out = -20;
    a_out = -30;
    b_in = -40;
    a_in = -50;
    CL_out = a_out + (b_out-a_out).*rand(1,1);
    CL_in = a_in + (b_in-a_in).*rand(1,1);
    
    drc_in = [-120 interped_spl(1,M) CL_in 0];
    drc_out = [-120 hi(1,M) CL_out 0]; 
    
    % Построение графика компрессора динамического диапазона
    plot (drc_in, drc_out, 'k', 'LineWidth', 1);
    plot (drc_in, drc_out, 'ok', 'LineWidth', 1.5);

    % Реализация алгоритма нахождения коэффициентов усиления для каждой
    % субполосы
    for N=1:N_frames
        i_beg = (N-1)*frame_size+1;
        i_end = N*frame_size;
        x_frame = corrected_audio_output_signal(M, i_beg : i_end);
        
        % Разбиение каждой субполосы на фреймы для оптимизации алгоритма
        for j=1:frame_size
            % Производится оценка уровеня мощности 
            p_cur = x_frame(j)^2;
            
            if p_cur > p_start(M)
                p_start(M) = p_start  (M) * coefficient_a + p_cur * (1 - coefficient_a);
            else
                p_start(M) = p_start  (M) * coefficient_b + p_cur * (1 - coefficient_b);
            end
        end 
        
        p_end = p_start (M);
        % Полученный уровень мощности переводится в дБ 
        p_end_db   = 10*log10(p_end);
        % Вычисляется коэффициент усиления в каждой субполосе 
        p_out_db = interp1(drc_in, drc_out, [p_end_db], 'linear');
        g_end_db = p_out_db - p_end_db;
        % Коэффициент усиления переводится из дБ в линейный маштаб 
        g_end = 10^(g_end_db / 20);
        g_line = interp1([0 frame_size], [g_begin(M) g_end],1:frame_size, 'linear');
        g_begin(M) = g_end; 
        % Производится усиления 
        y(i_beg:i_end) = x_frame.*g_line;
    end
    
    % Синтез выходного сигнала
    synthesized_audio_output_signal = synthesized_audio_output_signal + y;
    processed_audio_output_signal(M, :) = y;
end

%create_characteristic_drc_input_output_figure(drc_in, drc_out);
%create_input_output_subband_signals_figure(corrected_audio_output_signal, processed_audio_output_signal);

% Построение графиков временного представления и спектрограмм входного и выходного сигнала
create_input_output_signal_figure(audio_input_signal, synthesized_audio_output_signal, fs, freq_aud);

% Запись выходного звукого сигнала
audiowrite('output_signal.wav', synthesized_audio_output_signal, fs);