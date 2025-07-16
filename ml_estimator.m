function F0_est_ML = ml_estimator(x, t, A, phi, Fs, initial_guess)
% ML_ESTIMATOR Procenjuje frekvenciju signala koristeci ML estimator
%   F0_est_ML = ml_estimator(x, t, A, phi, Fs, initial_guess)
%   x: Primljeni signal
%   t: Vremenski vektor
%   A: Amplituda signala (poznata)
%   phi: Faza signala (poznata)
%   Fs: Frekvencija odmeravanja (Hz)
%   initial_guess: Početna tačka za optimizaciju (FFT procena)

cost_function = @(f) sum((x - A * sin(2*pi*f*t + phi)).^2);
F0_est_ML = fminsearch(cost_function, initial_guess);

end