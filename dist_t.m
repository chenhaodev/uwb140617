function distn = dist_t(x,y)
% This function calculates distance between two points
% x and y is a 1 by 2 matrix which containes coordinates of two points
% Example: x (12, 26), y (5, 0);
distn = sqrt((x(1) - y(1))^2 + (x(2) - y(2))^2);