%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the demo code to generate the results in paper:
% Chen Chen, Minh N. Do, Jue Wang, "Robust Image and Video Dehazing with Visual Artifact Suppression via Gradient Residual Minimization", European Conference on Computer Vision (ECCV), 2016.

% Artusi 26/10/2018: converted to function
% usage: 
% [radiance, A, transmission, E] = robustdehaze(im,w,t0,post,A)
% Input:
%       im:   input image.
%       w:    dehazing ratio. [0-1]. Default: 0.95.
%       t0:   minimum transmission value. [0-1] Default: 0.3.
%       post: post processing method. [0: none (default). 1: matting
%             Laplacian 2: guided filter].
%       A:    atmospheric light. [1*3 vector of RGB values]. (can be fixed for video processing)
% Output: 
%       radiance:     output image.
%       A:            estimated atmospheric light if no input A. 
%       transmission: estimated transmission.
%       E:            error term.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [dh_img] = grm(h_img) 
    h_img = double(h_img)/255.0;   

% filename = 'tower.png';
% img_hazy = double(imread(filename))/255;

    [dh_img, A, transmission, E] = robustdehaze(h_img,0.95,0.3,0);

%     figure; imshow(radiance);title('GRM')
 

