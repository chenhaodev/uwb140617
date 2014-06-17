function [y] = monocycle(fs, ts, t, t1, A, pulse_order)
% This function generates one Gaussian pulse
% pulse_order - derivative of Gaussian pulse, if:
%             0 - Gaussian pulse
%             1 - First derivative of Gaussian pulse
%             2 - Second derivative of Gaussian pulse
% fs - Sample rate
% ts - Sample period
% t - Vector with sample instants
% t1 - Pulse width
% A - Positive value gives negative going monopulse;
%     negative value gives positive going monopulse
% y - Output, generated Gaussian pulse

x=(2*t/t1).*(2*t/t1);%x=(t^2/t1^2)(square of (t/t1)

if pulse_order == 0
    y=(1/(sqrt(6.28)*t1))*exp(.5*(-x));%Gaussian pulse function
elseif pulse_order == 1
    y=A*(t/t1).*exp(-x);%first derivative of Gaussian pulse function
elseif pulse_order == 2
    y=A*(1/(sqrt(6.28)*t1))*(1-x).*exp(.5*(-x));%second derivative of Gaussian pulse function
else
    error(' There is no such derivative ! pulse_order can get values from 1 to 3');
end


% figure(1)
% plot(1E9*t,1E-9*y) %multiply t by 1 nanosec to get nanosec instead of sec
% xlabel('Nanoseconds'); ylabel('Amplitude');
% if pulse_order == 0
%     title('Gaussian pulse function');%Gaussian pulse function
% elseif pulse_order == 1
%     title('First derivative of Gaussian pulse function');%first derivative of Gaussian pulse function
% elseif pulse_order == 2
%     title('Second derivative of Gaussian pulse function');%second derivative of Gaussian pulse function
% end
% grid on