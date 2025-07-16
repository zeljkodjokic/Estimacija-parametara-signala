function F0_est_FFT = fft_estimator(x, Fs)
% FFT_ESTIMATOR Procenjuje frekvenciju signala koristeci FFT
%   F0_est_FFT = fft_estimator(x, Fs)
%   x: Primljeni signal
%   Fs: Frekvencija odmeravanja (Hz)

N = length(x); % Broj odmeraka
Y = fft(x);    % Izracunaj FFT primljenog signala

% Racunanje frekventnog vektora
% f_axis sadrzi frekvencije od 0 do Fs-Fs/N
f_axis = (0:N-1)*(Fs/N);
% Zanima nas samo prvi deo spektra (do Nyquistove frekvencije Fs/2)
f_axis_half = f_axis(1:floor(N/2)+1); 

% Pronadji indeks frekventne komponente sa najvecom magnitudom
% Koristimo abs() za magnitudu kompleksnog broja
[~, idx] = max(abs(Y(1:floor(N/2)+1)));

% Procenjena frekvencija je frekvencija koja odgovara tom indeksu
F0_est_FFT = f_axis_half(idx);

% Opciona vizualizacija spektra (moze se pozvati direktno iz main skripte za pojedinacne slucajeve)
% if false % Postavi na 'true' ako zelis da vidis spektar za jednu simulaciju
%     figure;
%     plot(f_axis_half, abs(Y(1:floor(N/2)+1)));
%     title('Magnituda FFT spektra');
%     xlabel('Frekvencija (Hz)');
%     ylabel('|Y(f)|');
%     grid on;
%     % Opciono: obelezi stvarnu i procenjenu frekvenciju
%     % xline(F0_true, 'r--', 'Stvarna F0');
%     % xline(F0_est_FFT, 'b:', 'Procenjena F0 (FFT)');
% end

end