filename = '01Калистрат.mp3';
[x, Fs] = audioread(filename); % Reading in a mp3 file.
% (Fs = 22050) 
size(x); % 6722947           2 
duration = 6722947 / Fs; % 304.8956 ms
% sound(x, 22050);
x1 = x(:, 1); % Select and work only with one of the channels.

n = length(x1);

a = 0.9900; % attack time coefficient
b = 0.9992; % release time coefficient

xdB = [0 -20 -90];
ydB = [-15 -15 -90];
% xdB = [0 -5 -50];
% ydB = [-10 -10 -50];


p(1) = 2 .^ (-10); 
P_start = 10 * log10(p);

for i = 2:n
    p_inst = x1(i) .^ 2;
    if p_inst > p(i - 1)
        p(i) = a * p(i - 1) + (1 - a) * p_inst;
    else
        p(i) = b * p(i - 1) + (1 - b) * p_inst;
    end
end

P_out_start = interp1(xdB,ydB,P_start,'linear');
g = 10 .^ ((P_out_start - P_start) / 20);

for i = 1:n
    y(i) = x1(i) * g(i);
end


audiowrite('Output signal.wav', y, Fs);


% Передаточная характеристика устройства 
figure
plot(xdB, ydB);
grid on;
title('Static Characteristic') % for limiter
xlabel('Input (dB)');
ylabel('Output (dB)');
xlim([-90 0]);
ylim([-90 0]);


% Входной и выходной сигнал
figure
subplot(2,1,1); 
plot(x1)
title('Input signal')
ylim([-1 1]);

subplot(2,1,2);
plot(y)
title('Output signal')
ylim([-1 1]);