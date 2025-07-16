function plot_performance(SNR_dB_values, mse_FFT, mse_ML, crlb_values)
% PLOT_PERFORMANCE Crta MSE vs. SNR grafikone
%   plot_performance(SNR_dB_values, mse_FFT, mse_ML, crlb_values)
%   SNR_dB_values: Vektor SNR vrednosti u dB
%   mse_FFT: Vektor MSE za FFT estimator
%   mse_ML: Vektor MSE za ML estimator
%   crlb_values: Vektor CRLB vrednosti

figure;
loglog(SNR_dB_values, mse_FFT, 'b-o', 'LineWidth', 1.5, 'DisplayName', 'MSE FFT Estimator');
hold on; % Drzi trenutni grafikon otvorenim za dodavanje novih linija
loglog(SNR_dB_values, mse_ML, 'r-s', 'LineWidth', 1.5, 'DisplayName', 'MSE ML Estimator');
loglog(SNR_dB_values, crlb_values, 'k--', 'LineWidth', 1.5, 'DisplayName', 'CRLB');
title('MSE frekvencijske estimacije u zavisnosti od SNR');
xlabel('SNR (dB)');
ylabel('MSE (Hz^2)');
legend('show'); % Prikazi legendu da objasni linije
grid on;       % Prikazi mrezu na grafikonu
ylim([1e-8 1e2]); % Prilagoditi Y-osu po potrebi za bolji prikaz
hold off;      % Zatvori mogucnost dodavanja linija na trenutni grafikon

end