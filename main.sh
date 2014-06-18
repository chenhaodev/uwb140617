#!/bin/bash

tag_x=$1
tag_y=$2
EbNo=$3
pulse_order=$4


 
octave38 maintest.m 
octave38 maintest(tag_x,tag_y,EbNo,pulse_order)
