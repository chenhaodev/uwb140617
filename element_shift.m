function [R] = rotmatrix()

A = [1     2     3     0     0     0]
n=length(A);
N=zeros(n);
for j=1:n
N(j,:)=circshift(A,[0,j-1]);
end
R = N([1:4],:)