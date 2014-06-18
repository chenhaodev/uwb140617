#!/usr/bin/python

import os
import sys
#pattern=sys.argv[1]
#filename=sys.argv[2]
#nfilename=sys.argv[2]+".tmp"
#lines=f.readlines()
#fn=open(nfilename, "w")

tag_x = 1;
tag_y = 1;
EbNo = -15;
pulse_order = 1;
debug = 1;

for i in range(0,2):
  cmd1="./main.sh "+str(tag_x)+" "+str(tag_y)+" "+str(EbNo)+" "+str(pulse_order)+" "+str(debug)
  os.system(cmd1)
  tag_x = tag_x + 1;
  tag_y = tag_y + 1;
