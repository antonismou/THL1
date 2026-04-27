%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mfile for the demostration of modulated WSS stochastic processes  %
%          with and without random phase                            %
%                                                                   %
% A. P. Liavas, March 17, 2026                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In the following, I focus on simplicity and not on efficiency of the code...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear, clc, clf, %close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generation of realizations of stationary random process via filtering of white noise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Design a lowpass filter
n = 101; % length of impulse responses
% Design filter
f = [0 0.1 0.2 1]; m = [1 1 0 0];          % Specifications
h(:,1) = fir2(n, f, m); h = h/norm(h);     % Normalize impulse response

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate and filter white noise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R = 300;      % number of realizations - "play" with R
F_0 = .01;    % Frequency of the sinusoid (we are in discrete time and frequency...) - "play" with F_0
N = 1000;

for iR = 1:R
    W(:,iR) = randn(N, 1);           % Generate realization of common input white noise
    X(:,iR) = conv(W(:,iR), h);      % Compute output of h
    cos_term(:,1) = cos(2 * pi * F_0 * [1:length(X(:,iR))]);  % Generate sinusoid with NO phase
    Y1(:,iR) = X(:,iR) .* cos_term;  % Modulation with sinusoidal signal with NO phase
    Phi = 2 * pi * rand;
    cos_term(:,1) = cos(2 * pi * F_0 * [1:length(X(:,iR))] + Phi);  % Generate sinusoid with uniform phase
    Y2(:,iR) = X(:,iR) .* cos_term;   % Modulation with sinusoidal signal with uniform PHASE
end


% We observe the modulated signals through different time windows - what do you observe?
% First time window
t1 = 200;
t2 = 400;
figure(1), plot([t1:t2], Y1(t1:t2,:)), title('Part of X1'), grid on
figure(2), plot([t1:t2], Y2(t1:t2,:)), title('Part of X2'), grid on
fprintf('\nWe plot realizations of modulated WSS X(t). First time window...')


% Second time window
t1 = 400;
t2 = 600;
figure(3), plot([t1:t2], Y1(t1:t2,:)), title('Part of X1'), grid on
figure(4), plot([t1:t2], Y2(t1:t2,:)), title('Part of X2'), grid on
fprintf('\nWe plot realizations of modulated WSS X(t). Second time window...')

% Third time window
t1 = 600;
t2 = 800;
figure(5), plot([t1:t2], Y1(t1:t2,:)), title('Part of X1'), grid on
figure(6), plot([t1:t2], Y2(t1:t2,:)), title('Part of X2'), grid on
fprintf('\nWe plot realizations of modulated WSS X(t). Third time window...\n')