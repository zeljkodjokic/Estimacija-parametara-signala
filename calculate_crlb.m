function crlb_F0_Hz_sq = calculate_crlb(A, N, Fs, noise_variance)
% CALCULATE_CRLB Racuna Cramer-Rao Donju Granicu za frekvencijsku estimaciju
%   crlb_F0_Hz_sq = calculate_crlb(A, N, Fs, noise_variance)
%   A: Amplituda signala
%   N: Broj odmeraka
%   Fs: Frekvencija odmeravanja (Hz)
%   noise_variance: Varijansa Gausovog suma (sigma_w^2)

% CRLB za normalizovanu frekvenciju f0 (f0 = F0/Fs)
% Formula: Var(f0) >= (12 * sigma_w^2) / (A^2 * N * (N^2 - 1) * (2*pi)^2)
% gde je sigma_w^2 varijansa suma.
crlb_f0_norm = (12 * noise_variance) / (A^2 * N * (N^2 - 1) * (2*pi)^2);

% Konverzija CRLB iz normalizovane frekvencije (bez jedinica) u Hz^2
% Var(F0) = Var(f0 * Fs) = Fs^2 * Var(f0)
crlb_F0_Hz_sq = crlb_f0_norm * Fs^2;

end