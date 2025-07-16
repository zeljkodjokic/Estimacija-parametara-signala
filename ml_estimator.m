function F0_est_ML = ml_estimator(x, t, A, phi, Fs, search_range_min, search_range_max)
% ML_ESTIMATOR Procenjuje frekvenciju signala koristeci ML estimator
%   F0_est_ML = ml_estimator(x, t, A, phi, Fs, search_range_min, search_range_max)
%   x: Primljeni signal
%   t: Vremenski vektor
%   A: Amplituda signala (poznata)
%   phi: Faza signala (poznata)
%   Fs: Frekvencija odmeravanja (Hz)
%   search_range_min: Donja granica opsega pretrage za frekvenciju (Hz)
%   search_range_max: Gornja granica opsega pretrage za frekvenciju (Hz)

% Definisi funkciju greske (kost funkciju) koju treba minimizovati
% Anonimna funkcija koristi promenljive 'x', 't', 'A', 'phi' iz okruzujuceg skopa
cost_function = @(f) sum((x - A * sin(2*pi*f*t + phi)).^2);

% Koriscenje fminbnd za pronalazenje minimuma funkcije troska
% fminbnd je dobar za jednodimenzionalno pretraživanje u zadatom opsegu [search_range_min, search_range_max]
F0_est_ML = fminbnd(cost_function, search_range_min, search_range_max);

end