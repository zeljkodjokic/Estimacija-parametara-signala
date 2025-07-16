% --- main_estimation_project.m ---
% Glavni skript za projekat estimacije frekvencije sinusnog signala u sumu

clc;        % Ocisti Command Window
clear all;  % Ocisti workspace varijable
close all;  % Zatvori sve otvorene figure

% --- 1. Parametri simulacije ---
Fs = 1000;          % Frekvencija odmeravanja (Hz)
N = 1000;           % Broj odmeraka
A = 1;              % Amplituda signala (poznata)
phi = 0;            % Faza signala (poznata)
F0_true = 50.7;     % STVARNA frekvencija signala (Hz) - Parametar koji procenujemo!

SNR_dB_values = -10:2:30; % Opseg SNR vrednosti za testiranje
num_realizations = 1000; % Broj ponavljanja za svaku SNR vrednost (za statistiku)

% Inicijalizacija nizova za rezultate
mse_FFT = zeros(size(SNR_dB_values));
mse_ML = zeros(size(SNR_dB_values));
crlb_values = zeros(size(SNR_dB_values));

fprintf('Pokrecem simulaciju performansi...\n');

% Glavna petlja simulacije: prolazi kroz razlicite SNR vrednosti
for i = 1:length(SNR_dB_values)
    current_SNR_dB = SNR_dB_values(i);
    
    % Racunanje varijanse suma za trenutni SNR
    signal_power = (A^2) / 2;
    current_SNR_linear = 10^(current_SNR_dB/10);
    current_noise_variance = signal_power / current_SNR_linear; % Varijansa suma (sigma_w^2)

    errors_FFT = zeros(1, num_realizations);
    errors_ML = zeros(1, num_realizations);
    
    % Izracunavanje CRLB za trenutni SNR
    crlb_values(i) = calculate_crlb(A, N, Fs, current_noise_variance);

    % Petlja za Monte Carlo simulacije (ponavljanja za statisticku analizu)
    for j = 1:num_realizations
        % Generisanje novog signala sa sumom za svaku realizaciju
        % Sada generate_noisy_signal NE SADRZI vizualizaciju!
        [x, s_true, t_vec, ~] = generate_noisy_signal(Fs, N, A, phi, F0_true, current_SNR_dB);
        
        % --- Vizualizacija signala (samo za prvu iteraciju i prvi SNR) ---
        % Ovo osigurava da se grafici iscrtaju samo jednom na pocetku simulacije
        if i == 1 && j == 1
            figure;
            plot(t_vec, x);
            hold on;
            plot(t_vec, s_true, 'r--', 'LineWidth', 1.2);
            title(['Primer signala sa sumom (SNR = ', num2str(current_SNR_dB), ' dB)']);
            xlabel('Vreme (s)');
            ylabel('Amplituda');
            legend('Primljeni signal (x[n])', 'Originalni signal (s[n])');
            grid on;
            
            % Vizualizacija FFT spektra tog prvog signala
            Y = fft(x);
            f_axis = (0:N-1)*(Fs/N);
            f_axis_half = f_axis(1:floor(N/2)+1);
            
            figure;
            plot(f_axis_half, abs(Y(1:floor(N/2)+1)));
            title(['Magnituda FFT spektra za SNR = ', num2str(current_SNR_dB), ' dB']);
            xlabel('Frekvencija (Hz)');
            ylabel('|Y(f)|');
            grid on;
            xline(F0_true, 'r--', 'Stvarna F0');
            % Obelezi FFT procenu za taj specificni signal (iz prvog generisanog signala)
            [~, idx_fft_plot] = max(abs(Y(1:floor(N/2)+1)));
            xline(f_axis_half(idx_fft_plot), 'b:', 'Procenjena F0 (FFT)');
        end

        % FFT Estimacija
        F0_est_FFT_current = fft_estimator(x, Fs);
        errors_FFT(j) = (F0_est_FFT_current - F0_true)^2; % Kvadratna greska

        % ML Estimacija
        % Opseg pretrage za ML estimator:
        search_min = max(0, F0_true - 15);
        search_max = min(Fs/2, F0_true + 15);
        
        F0_est_ML_current = ml_estimator(x, t_vec, A, phi, Fs, search_min, search_max);
        errors_ML(j) = (F0_est_ML_current - F0_true)^2;
    end
    
    mse_FFT(i) = mean(errors_FFT); % Srednja kvadratna greska za FFT
    mse_ML(i) = mean(errors_ML);   % Srednja kvadratna greska za ML
    
    fprintf('SNR = %4.1f dB, MSE_FFT = %.4e, MSE_ML = %.4e, CRLB = %.4e\n', ...
            current_SNR_dB, mse_FFT(i), mse_ML(i), crlb_values(i));
end

% --- 5. Analiza performansi (greška estimacije vs. SNR) ---
plot_performance(SNR_dB_values, mse_FFT, mse_ML, crlb_values);

fprintf('\nSimulacija zavrsena.\n');