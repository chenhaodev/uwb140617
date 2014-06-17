% This function calculates Tag's position using Least square Algorithm

function [Error] = toa(AP, Tag, time_dur, light_speed)

L = time_dur .* light_speed;
n = length(AP);
% Here we use LEAST SQUARES estimation for estimated Tag's location

for i = 2:n
    P(i-1,1) = AP(i,1);
    P(i-1,2) = AP(i,2);
end

B(1,:) = (AP(2,1)^2 + AP(2,2)^2) - L(2)^2 + L(1)^2;
B(2,:) = (AP(3,1)^2 + AP(3,2)^2) - L(3)^2 + L(1)^2;

k = (P'*P)^(-1)*P'*B*0.5;
Error = sqrt((Tag(1) - k(1))^2 + (Tag(2) - k(2))^2);
