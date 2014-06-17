function Sest = cosamp(Phi,u,K,tol,maxiterations)
%------------------------------------------------------------------------------
%                          CoSaMP algorithm
% Programmed by Chenhao
% version 1.0
% - 1 Tag and 3 Receivers
% - locationg algorithm: TOA 
% - PPM repetition pulse
% - Indoor channel ieee802.15.4a, LOS, CM1
%   Input
%  K : sparsity of Sest
%  Phi : measurement matrix
%  u: measured vector
%  tol : tolerance for approximation between successive solutions. 
%  Output
%  Sest: Solution found by the algorithm
%------------------------------------------------------------------------------


% Cosamp algorithm
%   Input
%       K : sparsity of Sest
%       Phi : measurement matrix
%       u: measured vector
%       tol : tolerance for approximation between successive solutions. 
%   Output
%       Sest: Solution found by the algorithm
%
% Algorithm as described in "CoSaMP: Iterative signal recovery from 
% incomplete and inaccurate samples" by Deanna Needell and Joel Tropp.
% e.g. Sest = cosamp(RD,y,1,1e-5,20)


% This implementation was written by David Mary, 
% but modified 20110707 by Bob L. Sturm to make it much clearer,
% and corrected multiple times again and again.
% To begin with, see: http://media.aau.dk/null_space_pursuits/2011/07/ ...
% algorithm-power-hour-compressive-sampling-matching-pursuit-cosamp.html
%
% This script/program is released under the Commons Creative Licence
% with Attribution Non-commercial Share Alike (by-nc-sa)
% http://creativecommons.org/licenses/by-nc-sa/3.0/
% Short Disclaimer: this script is for educational purpose only.
% Longer Disclaimer see  http://igorcarron.googlepages.com/disclaimer

% Initialization
Sest = zeros(size(Phi,2),1); %cc N*1
v = u;
t = 1; 
numericalprecision = 1e-12;
T = [];
while (t <= maxiterations) && (norm(v)/norm(u) > tol) %cc meaning of maxit.. and tol
  y = abs(Phi'*v);
  [vals,z] = sort(y,'descend');
  Omega = find(y >= vals(2*K) & y > numericalprecision);
  T = union(Omega,T);
  b = pinv(Phi(:,T))*u;
  [vals,z] = sort(abs(b),'descend');
  Kgoodindices = (abs(b) >= vals(K) & abs(b) > numericalprecision);
  T = T(Kgoodindices);
  Sest = zeros(size(Phi,2),1);
  b = b(Kgoodindices);
  Sest(T) = b;
  v = u - Phi(:,T)*b;
  t = t+1;
end
