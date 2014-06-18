function [toa_error, time_dur] = uwb_posistion_toa(tag_x,tag_y,EbNo,pulse_order);

pkg load signal
disp('load <signal> package .. ');

[toa_error, time_dur] = uwb_posistion_toa(tag_x,tag_y,EbNo,pulse_order)
[cs_rx_toa_error, cs_rx_time_dur] = uwb_posistion_cs_rx_toa(tag_x,tag_y,EbNo,pulse_order)
[cs_tx_toa_error, cs_tx_time_dur] = uwb_posistion_cs_tx_toa(tag_x,tag_y,EbNo,pulse_order)

disp('results generated .. done');
