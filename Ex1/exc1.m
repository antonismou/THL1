% Telecommunication Systems I - Exercise 1
% Baseband communication with 2-PAM and truncated SRRC pulses

clear; clc; close all;

%% Common Parameters
T = 1e-2;           % Symbol period in seconds
over = 10;          % Oversampling factor
Ts = T / over;      % Sampling period
A = 4;              % Half-length of the truncated pulse in symbol periods
a_values = [0, 0.5, 1]; % Roll-off factors

%% A.1 Construct and Plot SRRC pulses
figure('Name', 'A.1: Truncated SRRC Pulses', 'NumberTitle', 'off');
hold on; grid on;
colors = ['r', 'b', 'g'];

for i = 1:length(a_values)
    a = a_values(i);
    [phi, t] = srrc_pulse(T, over, A, a);
    plot(t, phi, 'Color', colors(i), 'LineWidth', 1.5, 'DisplayName', ['a = ', num2str(a)]);
end

xlabel('Time (s)');
ylabel('\phi(t)');
title('Truncated SRRC Pulses for different roll-off factors');
legend('Location', 'best');
hold off;

%% A.2 Fourier Transforms and Energy Spectral Density
N_f = 2048; % Number of frequency points
Fs = 1/Ts;  % Sampling frequency
F = linspace(-Fs/2, Fs/2 - Fs/N_f, N_f); % Frequency axis

figure('Name', 'A.2a: Energy Spectral Density (Linear)', 'NumberTitle', 'off');
hold on; grid on;
for i = 1:length(a_values)
    a = a_values(i);
    [phi, ~] = srrc_pulse(T, over, A, a);
    
    % Compute continuous FT approximation
    PHI = fftshift(fft(phi, N_f)) * Ts; 
    ESD = abs(PHI).^2;
    
    plot(F, ESD, 'Color', colors(i), 'LineWidth', 1.5, 'DisplayName', ['a = ', num2str(a)]);
end
xlabel('Frequency (Hz)');
ylabel('|\Phi(F)|^2');
title('Energy Spectral Density (Linear Plot)');
legend('Location', 'best');
xlim([-150 150]);
hold off;

figure('Name', 'A.2b: Energy Spectral Density (Semilogy)', 'NumberTitle', 'off');
hold on; grid on;
c1 = T / 1e3;
c2 = T / 1e5;

for i = 1:length(a_values)
    a = a_values(i);
    [phi, ~] = srrc_pulse(T, over, A, a);
    PHI = fftshift(fft(phi, N_f)) * Ts; 
    ESD = abs(PHI).^2;
    yscale("log");
    
    semilogy(F, ESD, 'Color', colors(i), 'LineWidth', 1.5, 'DisplayName', ['a = ', num2str(a)]);
end

% Draw horizontal lines for practical bandwidth
yline(c1, '--m', ['c = T/10^3 (', num2str(c1), ')'], 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');
yline(c2, '--g', ['c = T/10^5 (', num2str(c2), ')'], 'LabelHorizontalAlignment', 'left', 'HandleVisibility', 'off');

xlabel('Frequency (Hz)');
ylabel('|\Phi(F)|^2 (Log Scale)');
title('Energy Spectral Density (Semilogy Plot)');
legend('Location', 'best');
xlim([-300 300]);
ylim([1e-12 1e-1]);
hold off;

%% A.3 Theoretical Bandwidth
fprintf('--- A.3 Theoretical Bandwidth ---\n');
for i = 1:length(a_values)
    a = a_values(i);
    BW_th = (1 + a) / (2 * T);
    fprintf('Theoretical BW for a = %.1f is %.1f Hz\n', a, BW_th);
end
fprintf('\n');

%% B.1 Orthonormality Properties
fprintf('--- B.1 Orthonormality Integrals ---\n');
k_values = [0, 1, 2, 3];

% Plot for a=0.5
a_b1 = 0.5;
[phi_b1, t_phi] = srrc_pulse(T, over, A, a_b1);

figure('Name', 'B.1: Pulse Shifts and Products (a=0.5)', 'NumberTitle', 'off');
for idx = 1:length(k_values)
    k = k_values(idx);
    
    % Shifted pulse
    t_shift = t_phi + k*T;
    phi_shift = phi_b1; % Values are the same, just time axis is shifted
    
    % To multiply them, we need a common time axis
    t_common = min(t_phi(1), t_shift(1)) : Ts : max(t_phi(end), t_shift(end));
    
    % Interpolate/map to common axis (filling with 0 outside support)
    phi1_common = zeros(size(t_common));
    phi2_common = zeros(size(t_common));
    
    start1 = find(abs(t_common - t_phi(1)) < 1e-10);
    phi1_common(start1 : start1 + length(t_phi) - 1) = phi_b1;
    
    start2 = find(abs(t_common - t_shift(1)) < 1e-10);
    phi2_common(start2 : start2 + length(phi_shift) - 1) = phi_shift;
    
    product = phi1_common .* phi2_common;
    
    subplot(4, 2, 2*idx - 1);
    plot(t_common, phi1_common, 'b', t_common, phi2_common, 'r--', 'LineWidth', 1.2);
    title(['\phi(t) and \phi(t - ', num2str(k), 'T)']);
    grid on;
    
    subplot(4, 2, 2*idx);
    plot(t_common, product, 'g', 'LineWidth', 1.2);
    title(['Product \phi(t)\phi(t - ', num2str(k), 'T)']);
    grid on;
end

% Compute Integrals for all a and k
fprintf('Integrals of phi(t)*phi(t-kT):\n');
fprintf('k \t a=0 \t\t a=0.5 \t\t a=1\n');
for k = k_values
    fprintf('%d \t', k);
    for a = a_values
        [phi_temp, t_temp] = srrc_pulse(T, over, A, a);
        t_shift = t_temp + k*T;
        
        t_comm = min(t_temp(1), t_shift(1)) : Ts : max(t_temp(end), t_shift(end));
        p1 = zeros(size(t_comm)); p2 = zeros(size(t_comm));
        
        s1 = find(abs(t_comm - t_temp(1)) < 1e-10);
        p1(s1 : s1 + length(t_temp) - 1) = phi_temp;
        
        s2 = find(abs(t_comm - t_shift(1)) < 1e-10);
        p2(s2 : s2 + length(phi_temp) - 1) = phi_temp;
        
        integral_val = sum(p1 .* p2) * Ts;
        fprintf('%.6f \t', integral_val);
    end
    fprintf('\n');
end
fprintf('\n');

%% C. Baseband PAM System
N = 50;
a_C = 0.5;

% C.1 Generate N bits
b = (sign(randn(N, 1)) + 1) / 2;

% C.2.1 Convert bits to 2-PAM
X = bits_to_2PAM(b);

% C.2.2 Simulate X_delta(t)
X_delta = (1/Ts) * upsample(X, over);
t_delta = 0 : Ts : (N*over - 1)*Ts;

figure('Name', 'C.2.2: X_delta(t)', 'NumberTitle', 'off');
plot(t_delta, X_delta, 'b');
title('X_\delta(t) (Impulse Train)');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

% C.2.3 Simulate X(t)
[phi_C, t_phi_C] = srrc_pulse(T, over, A, a_C);
X_t = conv(X_delta, phi_C) * Ts;
t_X = t_delta(1) + t_phi_C(1) : Ts : t_delta(end) + t_phi_C(end);

figure('Name', 'C.2.3: Transmitted Signal X(t)', 'NumberTitle', 'off');
plot(t_X, X_t, 'r', 'LineWidth', 1.2);
title('Transmitted Signal X(t) = X_\delta(t) * \phi(t)');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

% C.2.4 Simulate Z(t)
phi_minus_t = phi_C(end:-1:1);
t_phi_minus = -t_phi_C(end:-1:1);

Z_t = conv(X_t, phi_minus_t) * Ts;
t_Z = t_X(1) + t_phi_minus(1) : Ts : t_X(end) + t_phi_minus(end);

figure('Name', 'C.2.4: Received Signal Z(t) and Sampling', 'NumberTitle', 'off');
hold on; grid on;
plot(t_Z, Z_t, 'b', 'LineWidth', 1.5, 'DisplayName', 'Z(t)');

% Overlay stems
t_samples = (0:N-1) * T;
stem(t_samples, X, 'r', 'filled', 'LineWidth', 1.5, 'DisplayName', 'Transmitted Symbols X_k');
title('Receiver Matched Filter Output Z(t)');
xlabel('Time (s)'); ylabel('Amplitude');
legend('Location', 'best');
hold off;