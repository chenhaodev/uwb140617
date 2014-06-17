function [A,y] = randmodu(x,M)
%------------------------------------------------------------------------------
%                          Random Demodulation
% Algorithm as described in "Analog-to-Information Conversion via Random
% Demodulation" by Kirolos, Sami etc.
% Key info: y = Ax, where size(x) = [N,1]; size(y) = [M,1]; size(A) =
% [M,N]; and M << N
% Programmed by Chenhao
% version 1.0
% -  z: Solution found by the algorithm
% -  K: sparsity of x 
% -  y: measured vector
% -  tol : tolerance for approximation between successive solutions. 
% e.g. [A, y] = randmodu(x,20)
% e.g. z = cosamp(A,y,1,1e-5,20)
%------------------------------------------------------------------------------

%n_pulse_pri = round(pri/ts);    
N = length(x);		
r = floor(N/M);
A = zeros(M,N);
for i = 1:M
    for j = 1:r
        A(i,(i-1)*r+j) = randi([0 1],1,1);
    end
end
y = A*x; 
