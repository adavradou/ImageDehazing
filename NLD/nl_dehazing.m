% This is a demo script demonstrating the non-local image dehazing algorithm
% described in the paper:
% Non-Local Image Dehazing. Berman, D. and Treibitz, T. and Avidan S., CVPR2016,
% which can be found at:
% www.eng.tau.ac.il/~berman/NonLocalDehazing/NonLocalDehazing_CVPR2016.pdf
% If you use this code, please cite our paper.
% 
% Please read the instructions on README.md in order to use this code.
%
% Author: Dana Berman, 2016. 
% 
% The software code of the Non-Local Image Dehazing algorithm is provided
% under the attached LICENSE.md
function [dh_img,trans_refined] = nl_dehazing(h_img, gamma)

% Load the gamma from the param file. 
% These values were given by Ra'anan Fattal, along with each image:
% http://www.cs.huji.ac.il/~raananf/projects/dehaze_cl/results/
% fid = fopen(['images/',image_name,'_params.txt'],'r');
% [C] = textscan(fid,'%s %f');
% fclose(fid);
    

% Estimate air-light using our method described in:
% Air-light Estimation using Haze-Lines. Berman, D. and Treibitz, T. and 
% Avidan S., ICCP 2017
    %A = reshape(estimate_airlight(im2double(img_hazy).^(gamma)),1,1,3);
    A = reshape(estimate_airlight(h_img.^(gamma)),1,1,3);

% Dehaze the image	
    [dh_img, trans_refined] = non_local_dehazing(h_img, A, gamma );


