%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% m file for the demonstration of simple properties  %
%   of random variables and random vectors           %
%                                                    %
% A. P. Liavas, March 5, 2026                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear, clc, close all

% Generation of i.i.d. X_i ~ {\cal N}(0,1)
% It can be considered as N independent realizations of a random variable X ~ {\cal N}(0,1) 
N = 10^4; % number of random iid Gaussian samples
x = randn(N,1);
figure(1), plot(x)
fprintf('\nPress a key to continue...'), pause
figure(2), hist(x, 100)
fprintf('\nPress a key to continue...'), pause
figure(3), plot(x, zeros(N,1), 'o')
fprintf('\nPress a key to continue...'), pause

% Generation of i.i.d. Gaussian pairs
N = 10^5;
X = randn(N,2);
figure(4), plot(X(:,1), X(:,2), 'o'), grid on
edges = [min(min(X)):.1:max(max(X))];
figure(5), histogram2(X(:,1), X(:,2), edges, edges), xlabel('x1'), ylabel('x2'), zlabel('2-d hist')
fprintf('\nPress a key to continue...'), pause


% Generation of linearly dependent X and Y: Y = a X + b, with X ~ {\cal N}(0,1)
N = 10^5;
a = .5; b = 1;
X = randn(N,1);
Y = a * X + b;
figure(4), plot(X, Y, 'o'), xlabel('x'), ylabel('y'), grid on
edges = [min(min([X Y])):.1:max(max([X Y]))];
figure(5), histogram2(X, Y, edges, edges), xlabel('x'), ylabel('y'), zlabel('2-d hist')
fprintf('\nPress a key to continue...'), pause

% Generation of approximately linearly dependent X and Z: Z = a * X + b + W
N = 10^5;
X = randn(N,1);
W = 0.3 * randn(N,1);
Z = a * X + b + W;
figure(4), plot(X, Z, 'o'), grid on
edges = [min(min([X Z])):.1:max(max([X Z]))];
figure(5), histogram2(X, Y, edges, edges), xlabel('x'), ylabel('z'), zlabel('2-d hist')
fprintf('\nPress a key to continue...'), pause

% Generation of independent Gaussian random variables (Y_1, Y_2) with different variances
N = 10^5;
X = randn(2, N);
A = [1 0; 0 3]; % try other diagonal matrices
Y = A * X;
figure(4), plot(Y(1,:), Y(2,:), 'o'), xlabel('y1'), ylabel('y2'), grid on, axis('equal')
edges = [min(min(Y)):.1:max(max(Y))];
figure(5), histogram2(Y(1,:)', Y(2,:)', edges, edges), xlabel('y1'), ylabel('y2'), zlabel('2-d hist')
fprintf('\nPress a key to continue...'), pause

% Generation of dependent Gaussian random variables (Y_1, Y_2) with covariance matrix C = A * A'
N = 10^5;
for ii=1:5
    X = randn(2,N);
    A = randn(2,2);
    Y = A * X;
    figure(4), plot(Y(1,:), Y(2,:), 'o'), xlabel('y1'), ylabel('y2'), grid on, axis('equal')
    edges = [min(min(Y)):.1:max(max(Y))];
    figure(5), histogram2(Y(1,:)', Y(2,:)', edges, edges), xlabel('y1'), ylabel('y2'), zlabel('2-d hist')
    fprintf('\nPress a key to continue...'), pause
end

