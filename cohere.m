function [u] = cohere(N,A,B)
%cohere.m

max_inner = 0;
for i = 1:N
  for j = 1:N
    inner = abs( A(i,:)*B(:,j) );
    inner = inner./(norm(A(i,:)) + norm(B(:,j)));
    if inner > max_inner
      max_inner = inner; 
    end
  end 
end

u = max_inner.*sqrt(N)

