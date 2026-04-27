% Telecommunication Systems I - Exercise 2
% Baseband PAM waveforms and Stochastic Processes

clear; clc; close all;

%% Part A: Baseband PAM waveforms

%% A.1 SRRC Pulse and its Energy Spectral Density
T = 1e-3;           % Symbol period in seconds
over = 10;          % Oversampling factor
Ts = T / over;      % Sampling period
A = 4;              % Half-length of truncated pulse
a = 0.5;            % Roll-off factor
N_f = 2048;         % Number of frequency points for FFT
Fs = 1/Ts;          % Sampling frequency

[phi, t_phi] = srrc_pulse(T, over, A, a);

% Compute Fourier Transform of phi(t)
PHI = fftshift(fft(phi, N_f)) * Ts;
ESD_phi = abs(PHI).^2;
F = linspace(-Fs/2, Fs/2 - Fs/N_f, N_f);

figure('Name', 'A.1: Energy Spectral Density of phi(t)', 'NumberTitle', 'off');
semilogy(F, ESD_phi, 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('|\Phi(F)|^2');
title('Energy Spectral Density of SRRC pulse \phi(t)');

%% A.2 & A.3 2-PAM Signal and PSD Estimation
N = 100;            % Number of bits
K = 500;            % Number of realizations
sigma_X2_2pam = 1;  % Variance for 2-PAM symbols {+1, -1}

% Periodogram averaging for 2-PAM
Px_2pam_avg = zeros(1, N_f);

for k = 1:K
    % Generate bits and map to 2-PAM
    bits = randi([0, 1], N, 1);
    X = bits_to_2PAM(bits);
    
    % Construct waveform X(t)
    % Using upsample and convolution as in Ex1
    X_delta = (1/Ts) * upsample(X, over);
    X_t = conv(X_delta, phi) * Ts;
    
    % Compute periodogram
    % Duration T_total
    T_total = length(X_t) * Ts;
    X_F = fftshift(fft(X_t, N_f)) * Ts;
    Px_F = (abs(X_F).^2) / T_total;
    
    Px_2pam_avg = Px_2pam_avg + Px_F;
end
Px_2pam_avg = Px_2pam_avg / K;

% Theoretical PSD
Sx_2pam_theory = (sigma_X2_2pam / T) * ESD_phi;

figure('Name', 'A.3: PSD Estimation for 2-PAM', 'NumberTitle', 'off');
semilogy(F, Px_2pam_avg, 'b', 'DisplayName', 'Experimental (Average Periodogram)');
hold on;
semilogy(F, Sx_2pam_theory, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Theoretical PSD');
grid on;
xlabel('Frequency (Hz)');
ylabel('PSD');
title(['PSD of 2-PAM (N=', num2str(N), ', K=', num2str(K), ')']);
legend;
hold off;

%% A.4 4-PAM Signal and PSD Estimation
% N=100 bits -> 50 symbols
sigma_X2_4pam = 5;  % Variance for 4-PAM symbols {+3, +1, -1, -3}

Px_4pam_avg = zeros(1, N_f);

for k = 1:K
    bits = randi([0, 1], N, 1);
    X = bits_to_4PAM(bits);
    
    X_delta = (1/Ts) * upsample(X, over);
    X_t = conv(X_delta, phi) * Ts;
    
    T_total = length(X_t) * Ts;
    X_F = fftshift(fft(X_t, N_f)) * Ts;
    Px_F = (abs(X_F).^2) / T_total;
    
    Px_4pam_avg = Px_4pam_avg + Px_F;
end
Px_4pam_avg = Px_4pam_avg / K;

% Theoretical PSD
Sx_4pam_theory = (sigma_X2_4pam / T) * ESD_phi;

figure('Name', 'A.4: PSD Estimation for 4-PAM', 'NumberTitle', 'off');
semilogy(F, Px_4pam_avg, 'b', 'DisplayName', 'Experimental (Average Periodogram)');
hold on;
semilogy(F, Sx_4pam_theory, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Theoretical PSD');
grid on;
xlabel('Frequency (Hz)');
ylabel('PSD');
title(['PSD of 4-PAM (N=100 bits, K=', num2str(K), ')']);
legend;
hold off;

%% A.5 PSD with T' = 2T
T_prime = 2 * T;
over_prime = 20; % To keep Ts = 1e-4
[phi_prime, t_phi_prime] = srrc_pulse(T_prime, over_prime, A, a);

% New Theoretical ESD for phi_prime
PHI_prime = fftshift(fft(phi_prime, N_f)) * Ts;
ESD_phi_prime = abs(PHI_prime).^2;

Px_2pam_Tprime_avg = zeros(1, N_f);

for k = 1:K
    bits = randi([0, 1], N, 1);
    X = bits_to_2PAM(bits);
    
    X_delta = (1/Ts) * upsample(X, over_prime);
    X_t = conv(X_delta, phi_prime) * Ts;
    
    T_total = length(X_t) * Ts;
    X_F = fftshift(fft(X_t, N_f)) * Ts;
    Px_F = (abs(X_F).^2) / T_total;
    
    Px_2pam_Tprime_avg = Px_2pam_Tprime_avg + Px_F;
end
Px_2pam_Tprime_avg = Px_2pam_Tprime_avg / K;

Sx_2pam_Tprime_theory = (sigma_X2_2pam / T_prime) * ESD_phi_prime;

figure('Name', 'A.5: PSD Estimation with T'' = 2T', 'NumberTitle', 'off');
semilogy(F, Px_2pam_Tprime_avg, 'b', 'DisplayName', 'Experimental');
hold on;
semilogy(F, Sx_2pam_Tprime_theory, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Theoretical');
grid on;
xlabel('Frequency (Hz)');
ylabel('PSD');
title(['PSD of 2-PAM with T'' = 2T (N=', num2str(N), ', K=', num2str(K), ')']);
legend;
hold off;

%% Part B: Stochastic Processes
% Y(t) = X * cos(2*pi*F0*t + Phi)
% X ~ N(0, 1), Phi ~ U(0, 2*pi)

F0 = 10;
Ts_B = 0.01;
t_axis = 0 : Ts_B : 5/F0;
num_realizations = 5;

figure('Name', 'B.1: Realizations of Y(t)', 'NumberTitle', 'off');
hold on;
for i = 1:num_realizations
    X_val = randn();
    Phi_val = 2 * pi * rand();
    Y_t = X_val * cos(2 * pi * F0 * t_axis + Phi_val);
    plot(t_axis, Y_t, 'DisplayName', ['Realization ', num2str(i)]);
end
grid on;
xlabel('Time (s)');
ylabel('Y(t)');
title('5 Realizations of Y(t) = X \cdot cos(2\pi F_0 t + \Phi)');
legend;
hold off;

% B.2 & B.3 Theory (Comments for report)
% E[Y(t)] = E[X] * E[cos(...)] = 0 * E[cos(...)] = 0.
% Ryy(t+tau, t) = E[Y(t+tau)Y(t)]
%              = E[X^2] * E[cos(2*pi*F0(t+tau) + Phi) * cos(2*pi*F0*t + Phi)]
%              = 1 * (1/2) * E[cos(2*pi*F0*tau) + cos(2*pi*F0(2t+tau) + 2*Phi)]
%              = 1/2 * cos(2*pi*F0*tau)  (since E[cos(2*Phi + ...)] = 0)
% Sy(F) = FT{Ryy(tau)} = 1/4 * [delta(F - F0) + delta(F + F0)]
