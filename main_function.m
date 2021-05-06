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
CL_in_2 = [-46.1844154290699,-42.0480009886294,-45.1023560421177,-43.5368698988874,-42.4531331801764,-43.2029732314633,-48.3738826480537,-45.0163594801786,-46.5961427333387,-47.7618806050886,-47.4490488454073,-43.0092327734331,-40.4070857479456,-48.6137555717132,-47.4249174587626,-47.4571782102847,-47.5647503127501,-46.5001623401519,-47.4891614202397,-45.2671115109727];
CL_out_2 = [-25.6125564034360,-22.3448321185100,-28.1312739544562,-25.5441379928910,-22.9063516914193,-27.2397492300142,-23.4490199602616,-28.8100231844162,-20.4025604148392,-24.1473224902022,-22.4873294069435,-24.9404294833486,-21.0909674746420,-24.5278447003620,-28.5070599444094,-21.5928274401634,-21.8571517393118,-20.7073637681277,-28.0340474956879,-23.8395532385336];
CL_in_3 = [-13.5568186980631,-11.8841954171752,-16.4927289642312,-11.2405718850702,-13.7752491399877,-17.9225770726697,-15.2907665148241,-11.5569120730461,-17.7407821902760,-17.7233570218345,-16.8889771334959,-15.6979260867042,-10.9511903132011,-15.6113002687390,-17.4193530408793,-14.0510392599139,-13.9715691061792,-17.7825326598276,-17.0332412678167,-15.7583324028619];
CL_out_3 = [-46.2139061733973,-44.6717441120055,-40.6099843800011,-44.4984365710158,-44.1295529546858,-46.9875366972051,-47.6951183978844,-48.0523571043295,-48.2929195285214,-45.6430131589610,-40.7662035789676,-48.1518367987586,-40.2025162164392,-48.8888077655940,-45.9128015388745,-47.3778825221916,-42.8878421956632,-48.8258234914419,-46.8122169807412,-44.9214171533888];

CL_in = CL_in_2;
CL_out = CL_out_2;

% Выбираются центральные частоты банка фильтров в соответствии с
% психоакустической шкалой Барков
fc = bark2frq(bark_sc);
[spl, freq_iso] = iso226_rev(0);

% Считывается входного звукого сигнала
% % % [audio, fs] =  audioread("input_signals/001.m4a");
addpath('input_signals');
filename = 'table 5_16kHz_HL_3nd';
cond = '_corr_HL3';
[audio, fs] =  audioread([filename '.wav']);

audio_input_signal = audio(:, 1)';

output_signal = gammatoneFast(input_signal, fc);
% % % create_gammaton_bank_filter_figure(output_signal, K, fs, freq_aud);

from_digdb_to_spl = 105;

% Нахождение порога слышимости
interped_HT = interp1(freq_aud, HT, fc, 'linear');
interped_spl = interp1(freq_iso, spl-from_digdb_to_spl, fc, 'linear');
hi = interped_HT-from_digdb_to_spl;

% Построение графиков аудиограммы, порогов слышимости в норме и при наличии
% патологии
% % % create_hearing_thresholds_figure(freq_aud, HT, hi, freq_iso, spl, fc);

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
% % % figure;
% % % configure_figure_settings('Компрессор динамического диапазона', 'Входная мощность, дБ', 'Выходная мощность, дБ');
% % % hold on;
% % % grid on;

for M=1:K-1
    % Определение точек перегиба компрессора динамического диапазона
    % % % % b_out = -10;
    % % % % a_out = -20;
    % % % % b_in = -40;
    % % % % a_in = -50;
    % % % % CL_out_3(M) = a_out + (b_out-a_out).*rand(1,1);
    % % % % CL_in_3(M) = a_in + (b_in-a_in).*rand(1,1);
    drc_in = [-120 interped_spl(1,M) CL_in(M) 0];
    drc_out = [-120 hi(1,M) CL_out(M) 0]; 
    
    % Построение графика компрессора динамического диапазона
    % % % plot (drc_in, drc_out, 'k', 'LineWidth', 1);
    % % % plot (drc_in, drc_out, 'ok', 'LineWidth', 1.5);

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
% % % create_input_output_signal_figure(audio_input_signal, synthesized_audio_output_signal, fs, freq_aud);

% Запись выходного звукого сигнала
audiowrite([filename cond '.wav'], synthesized_audio_output_signal, fs);