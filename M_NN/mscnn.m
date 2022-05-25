% Artusi 25/10/2018:
% - Converted to function:
% input: filename - path hazy image
% output: dh_img - dehazed image

function dh_img = mscnn(filename)

gamma = 1.0; 
run(fullfile(fileparts(mfilename('fullpath')), './matlab/vl_setupnn.m')) ;

dh_img = mscnndehazing(filename, gamma);
