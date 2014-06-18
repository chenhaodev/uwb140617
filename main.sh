#!/bin/bash
tag_x=$1
tag_y=$2
EbNo=$3
pulse_order=$4
debug=$5
 
echo "# Tag position: [$tag_x $tag_y]" >> log
echo "# EbNo = $EbNo dB"   >> log
~/.octave38/bin/octave -qf maintest.m $tag_x $tag_y $EbNo $pulse_order $debug >> log
echo "generated ...done "   >> log
