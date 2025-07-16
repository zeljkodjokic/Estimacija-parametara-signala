function [x, s, t, noise_variance] = generate_noisy_signal(Fs, N, A, phi, F0_true, SNR_dB)
% GENERATE_NOISY_SIGNAL Generise sinusni signal sa aditivnim Gausovim sumom
%   [x, s, t, noise_variance] = generate_noisy_signal(Fs, N, A, phi, F0_true, SNR_dB)
%   Fs: Frekvencija odmeravanja (Hz)
%   N: Broj odmeraka
%   A: Amplituda signala
%   phi: Faza signala (radijani)
%   F0_true: Stvarna frekvencija signala (Hz)
%   SNR_dB: Odnos signal/sum u dB

t = (0:N-1) * (1/Fs); % Vremenski vektor
s = A * sin(2*pi*F0_true*t + phi); % Sinusni signal (s_true u prethodnim verzijama)

signal_power = (A^2) / 2; % Snaga sinusnog signala (za sinusoidu)
SNR_linear = 10^(SNR_dB/10); % Konverzija SNR iz dB u linearnu skalu
noise_variance = signal_power / SNR_linear; % Varijansa suma (sigma_w^2)
sigma_w = sqrt(noise_variance); % Standardna devijacija suma

w = sigma_w * randn(1, N); % Gausov sum sa srednjom vrednoscu 0 i varijansom sigma_w^2
x = s + w; % Primljeni signal (signal + sum)

end