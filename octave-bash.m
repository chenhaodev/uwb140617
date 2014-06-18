%octave-bash.m
%this is a tutorial telling you how to send parameters to octave through bash
args = argv; 
disp(2*str2num(args{1})) 

%Then you execute:  octave38 -qf para.m 123
%output is 246 
