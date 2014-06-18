args = argv; 

tag_x       = str2num(args{1})
tag_y       = str2num(args{2})
EbNo        = str2num(args{3})
pulse_order = str2num(args{4})
debug       = str2num(args{5})


pkg load signal
disp('load <signal> package .. ');

%[toa_error, time_dur] = uwb_posistion_toa(tag_x,tag_y,EbNo,pulse_order)
%[cs_rx_toa_error, cs_rx_time_dur] = uwb_posistion_cs_rx_toa(tag_x,tag_y,EbNo,pulse_order)
%[cs_tx_toa_error, cs_tx_time_dur] = uwb_posistion_cs_tx_toa(tag_x,tag_y,EbNo,pulse_order)

[toa_error, ~] = uwb_posistion_toa(tag_x,tag_y,EbNo,pulse_order)
[cs_rx_toa_error, ~] = uwb_posistion_cs_rx_toa(tag_x,tag_y,EbNo,pulse_order)
[cs_tx_toa_error, ~] = uwb_posistion_cs_tx_toa(tag_x,tag_y,EbNo,pulse_order)
disp('results generated .. done');

