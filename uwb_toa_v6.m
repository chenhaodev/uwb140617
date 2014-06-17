%------------------------------------------------------------------------------
%                          UWB positioning system
% Programmed by Chenhao
% version 5.0 (revised based on version 4.0)
% Find a random projection matrix, which makes compressive sensing (CS) framework 
% outperfroms the conventional systems  
% version 4.0
% Add random projection on transimitter
% - CS sampling: random sample small points of the pulse on transimitter 
% - CS recovery: CoSaMP algorithm
% version 3.0 (revised based on version 2.0)
% Find a CS sampling matrix, which makes compressive sensing (CS) framework 
% outperfroms the conventional systems  
% - Tag's position is fixed as [1,1]
% version 2.0
% Add compressive sensing (CS) framework
% - CS sampling: random demodulator
% - CS recovery: CoSaMP algorithm
% version 1.0 
% - 1 Tag and 3 Receivers
% - locationg algorithm: TOA 
% - PPM repetition pulse
% - Indoor channel ieee802.15.4a, LOS, CM1
%------------------------------------------------------------------------------

clear all;
close all;
clc;

%------------------------------------------------------------------------------
% Initialization
%------------------------------------------------------------------------------

% Speed of Light
light_speed = 3e8;

fs = 20e9; %sample rate-10 times the highest frequency in GHz
ts = 1/fs; %sample period
t = [(-1.5E-9-ts):ts:(1.5E-9-ts)]; %vector with sample instants
t1 = .5E-9; %pulse width(0.5 nanoseconds)

% Pulse repetition interval, PRI
pri = 200e-9;

% The SNR range (in dB)
EbNo = -15;
 
% Number of bits
num_bits = 10;

% Compressed Sensing
rand_proj_valid = 1; 
channel_matrix_valid = 2;
cosamp_valid = 0;

%------------------------------------------------------------------------------
% locations
%------------------------------------------------------------------------------

% Tag's initial coordinate
Tag = [1 1];

% Coordinates of APs
AP = [0 0; 0 10; 10 0]; % in meters

% Number of Access Points (AP)
num_ap = length(AP);

%------------------------------------------------------------------------------
% Gaussian pulse generation
%------------------------------------------------------------------------------

pulse_order = 1; % 0-Gaussian pulse, 1-First derivative of Gaussian pulse, 2 - Second derivative;
A = 1; %positive amplitude
[y] = monocycle(fs, ts, t, t1, A, pulse_order); ref = y;
n_pulse_pri = round(pri/ts);          % Sampling of PRI
sig = zeros(1,n_pulse_pri);    
sig(1:length(y)) = y;                 % One pulse in one PRI

%------------------------------------------------------------------------------
% random projection on pulse generation
%------------------------------------------------------------------------------

% random projection matrix
load randinx.mat;
D = zeros(length(sig),length(sig));
%D = eye(length(sig));
for i=1:length(rand_index) 
    D(rand_index(i),rand_index(i))=1;
end    

sig_cs = zeros(1,length(sig)); 
sig_cs(rand_index) = sig(rand_index);
if rand_proj_valid==1
    sig = sig_cs; 
end

%-----------------------------------------------------------------
% LOS distance estimation
%-----------------------------------------------------------------

% Distance calculation between each AP and the Tag, IDEAL case
for ii = 1:num_ap
    dist_ap_tag(ii) = dist_t(AP(ii,:), Tag);
    % Time from each AP to Tag
    time_ap_tag(ii) = dist_ap_tag(ii)/light_speed;
end

%------------------------------------------------------------------------------
% Indoor channel ieee802.15.4a
%------------------------------------------------------------------------------

load ieee802.15.4a.cm1.10chan.mat
hi = abs(h);

%------------------------------------------------------------------------------
% Transmission
%------------------------------------------------------------------------------

for j = 1:num_bits
    for i = 1:num_ap
        % delayed signals 
        del_sample_ap_tag = round(time_ap_tag(i)/ts);
        xx = zeros(1,del_sample_ap_tag);
        del_sig_ap_tag(j,:) = [xx sig(1:end-length(xx))]; %
        
        % traversal channels 
        h = hi(:,j);
        conv_data = conv(del_sig_ap_tag(j,:), h);
        ap_tag_chan(j,:,i) = conv_data(1:length(sig)); %
        end
end

%------------------------------------------------------------------------------
% Equval Matrix for channel convolution 
% e.g. figure; plot((channel_matrix_tmp(:,:,1)'*sig')')
%------------------------------------------------------------------------------
if rand_proj_valid == 1
    if channel_matrix_valid == 1
        for j = 1:num_bits
            channel_matrix_tmp(:,:,j) = rotmatrix([hi(:,j)' zeros(1,(length(sig)-length(hi(:,j))))],length(sig));
        end
        [chm,chn] = size(channel_matrix_tmp(:,:,1));
        channel_matrix = zeros(chm,chn);
        for j = 1:num_bits
            channel_matrix = channel_matrix + channel_matrix_tmp(:,:,j);
        end
        channel_matrix = channel_matrix/num_bits;
    elseif channel_matrix_valid == 2
        load ~/Dropbox/Codes/channel_matrix_sum.mat
    end
end

%-------------------------------------------------------
% additive white gaussian noise (AWGN)  
%-------------------------------------------------------

noise_var = 10^(-EbNo/10);
for j = 1:num_bits
    for i = 1:num_ap
        ap_tag_chan_wgn(j,:,i) = ap_tag_chan(j,:,i)/std(ap_tag_chan(j,:,i)) + randn(1,length(ap_tag_chan(j,:,i))) .* sqrt(noise_var);
    end
end

%-------------------------------------------------------
% Receive and Xccorlation, Compressed Sensing Framework
%-------------------------------------------------------
    
for i = 1:num_ap
    
    %receive signal from all channels
    ap_tag_chan_wgn_tmp = ap_tag_chan_wgn(:,:,i);
    received_signl_ap = sum(ap_tag_chan_wgn_tmp)/num_bits;
       
    %xccorlation
    xc = xcorr(ref, received_signl_ap); 
    [a,delay(i)]=max(xc);
    TOA(i) = (length(sig) - delay(i)) * ts;
    
    %-----------------------------
    %compressed sensing framework
    %-----------------------------
    if cosamp_valid==1    
        load randmodu.mat
        y_cs = A*received_signl_ap';
        received_signl_ap_cs = cosamp(A,y_cs,1,1e-5,20);
    
    %----------------------------
    %random projection framework
    %----------------------------
    %elseif rand_proj_valid == 1
    %    received_signl_ap_cs = cosamp(D,received_signl_ap',1,1e-5,20);
    elseif channel_matrix_valid > 0
        received_signl_ap_cs = cosamp(D*channel_matrix',received_signl_ap',1,1e-5,20);
    end
    
    %compressive sensing xccorlation
    xc_cs = xcorr(ref, received_signl_ap_cs);
    [a,cs_delay(i)]=max(xc_cs);
    CS_TOA(i) = (length(sig) - cs_delay(i)) * ts;
        
end

%-------------------------------------------------------
% TOA locationing  
%-------------------------------------------------------

time_ap_tag = time_ap_tag
time_dur = TOA
toa_error = toa(AP, Tag, time_dur, light_speed)

%-------------------------------------------------------
% CS(compressed sensing) + TOA locationing  
%-------------------------------------------------------

cs_time_dur = CS_TOA
cs_toa_error = toa(AP, Tag, cs_time_dur, light_speed)
