function [R] = rotmatrix(X,K)
% Programmed by Chenhao
% version 1.0
% generate a matrix R using a 
% right shifted vector X
% demo [R] = rotmatrix(X,4)
% where K <= length(X)
% input: X = [1 2 3 4 5]
% output: R =
%   1  2  3  4  5
%   5  1  2  3  4
%   4  5  1  2  3
     
n = length(X);
tmp = zeros(n);
for j=1:n
    tmp(j,:)=circshift(X,[0,j-1]);
end
R = tmp([1:K],:);
