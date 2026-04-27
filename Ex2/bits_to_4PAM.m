function [X] = bits_to_4PAM(b)
% bits_to_4PAM: Maps pairs of bits to 4-PAM symbols
% Mapping: 
% 00 -> +3
% 01 -> +1
% 11 -> -1
% 10 -> -3

N = length(b);
if mod(N, 2) ~= 0
    error('Number of bits must be even for 4-PAM mapping.');
end

X = zeros(1, N/2);
for i = 1:N/2
    bits = b(2*i-1 : 2*i);
    if bits(1) == 0 && bits(2) == 0
        X(i) = 3;
    elseif bits(1) == 0 && bits(2) == 1
        X(i) = 1;
    elseif bits(1) == 1 && bits(2) == 1
        X(i) = -1;
    elseif bits(1) == 1 && bits(2) == 0
        X(i) = -3;
    end
end
end
