%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mfile for the demostration of simple properties of   %
%                stochastic processes                  %
%                                                      %
% A. P. Liavas, March 14, 2026                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In the following, I focus on simplicity and not on efficiency of the code...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear, clc, clf, %close all

N_f = 1024; % length of DFTs

% Generation of realizations of Random Walk
% Perhaps, the simplest NON-stationary stochastic process is the random walk, defined as
%  for n=1,...,N: 
%
%   X_n = \sum_{k=1}^n Y_k = X_{n-1} + Y_n, with Y_k, k=1,...,N iid {\cal N}(0,1)
%

N = 1000; % length of each realization of the random walk
R = 500;  % number of realizations to generate
for iR=1:R
    Y = randn(N,1); % Generate the realization of Y
    X(1,iR) = Y(1);
    for iN=2:N  % Generate the realization of X
        X(iN,iR) = X(iN-1,iR) + Y(iN);
    end
end
figure(1), plot(X), xlabel('Time n'), title('Realizations of Random Walk'), 
fprintf('\nWe plot realizations of Random Walk. Press a key...'), pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generation of realizations of stationary random process via filtering of white noise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Design two lowpass filter with different cut-off frequencies
n = 101; % length of impulse responses
% Design first filter
f1 = [0 0.1 0.2 1]; m1 = [1 1 0 0];          % Specifications
h1(:,1) = fir2(n, f1, m1); h1 = h1/norm(h1); % Normalize impulse response
H1 = abs(fftshift(fft(h1, N_f))).^2;         % Energy Spectral Density

% Design second filter
f2 = [0 0.3 0.4 1]; m2 = [1 1 0 0];          % Specifications
h2(:,1) = fir2(n, f2, m2); h2 = h2/norm(h2); % Normalize impulse response
H2 = abs(fftshift(fft(h2, N_f))).^2;         % Energy Spectral Density

% Plot impulse responses in common plot
figure(2), plot([h1 h2]), title('Filter Impulse Responses')

% Generate Frequency axis and plot Energy Spectral Densities in common semilogy
f_axis = [-0.5:1/N_f:0.5-1/N_f];  % Axis of Discrete Frequencies
figure(3), semilogy(f_axis, [H1 H2]), xlabel('Discrete Frequency f'), title('Filter Energy Spectrak Densities')
axis([-.5 0.5 10^(-13), 10])
fprintf('\nWe plot the impulse responses and the energy spectral densities of the filters. Press a key...'), pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate and filter white noise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R = 5;  % number of realizations - "play" with R
for iR = 1:R
    Y(:,iR) = randn(N,1);          % Generate realization of common input
    X1(:,iR) = conv(Y(:,iR), h1);  % Compute output of h1
    X2(:,iR) = conv(Y(:,iR), h2);  % Compute output of h2
end
% Time interval to plot - "play" with the time interval
t1 = 300;
t2 = 500;
figure(4), plot([t1:t2], Y(t1:t2,:)), title('Part of the common input (white noise)')
figure(5), plot([t1:t2], X1(t1:t2,:)), title('Part of X1')
figure(6), plot([t1:t2], X2(t1:t2,:)), title('Part of X2')
fprintf('\nWe plot (part of) the realizations the input (white noise) and the outputs...\n')

