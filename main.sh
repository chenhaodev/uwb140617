#!/bin/bash
tag_x=$1
tag_y=$2
EbNo=$3
pulse_order=$4
debug=$5
 
~/.octave38/bin/octave -qf maintest.m $tag_x $tag_y $EbNo $pulse_order $debug
