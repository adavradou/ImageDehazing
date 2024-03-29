DEFADE Software release.


========================================================================

-----------COPYRIGHT NOTICE STARTS WITH THIS LINE------------
Copyright (c) 2015 The University of Texas at Austin
All rights reserved.

Permission is hereby granted, without written agreement and without license or royalty fees, to use, copy, 
modify, and distribute this code (the source files) and its documentation for
any purpose, provided that the copyright notice in its entirety appear in all copies of this code, and the 
original source of this code, Laboratory for Image and Video Engineering (LIVE, http://live.ece.utexas.edu)
at The University of Texas at Austin (UT Austin,http://www.utexas.edu), 
is acknowledged in any publication that reports research using this code. The research
is to be cited in the bibliography as:

1. L. K. Choi, J. You, and A. C. Bovik, "Referenceless Prediction of Perceptual Fog Density and Perceptual Image Defogging,"
IEEE Transactions on Image Processing, vol. 24, no. 11, pp. 3888-3901, Nov. 2015.
2. L. K. Choi, J. You, and A. C. Bovik, "Referenceless perceptual image defogging," 
in Proc. IEEE Southwest Symp. Image Anal. Interpret., Apr. 2014, pp. 165-168.
3. L. K. Choi, J. You, and A. C. Bovik, "DEFADE Software Release," 
URL: http://live.ece.utexas.edu/research/fog/DEFADE_release.zip, 2015.

IN NO EVENT SHALL THE UNIVERSITY OF TEXAS AT AUSTIN BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, 
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OF THIS DATABASE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF TEXAS
AT AUSTIN HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

THE UNIVERSITY OF TEXAS AT AUSTIN SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE DATABASE PROVIDED HEREUNDER IS ON AN "AS IS" BASIS,
AND THE UNIVERSITY OF TEXAS AT AUSTIN HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

-----------COPYRIGHT NOTICE ENDS WITH THIS LINE------------%

Author  : Lark Kwon Choi
Version : 1.0

The authors are with the Laboratory for Image and Video Engineering
(LIVE), Department of Electrical and Computer Engineering, The
University of Texas at Austin, Austin, TX.

Kindly report any suggestions or corrections to larkkwonchoi@gmail.com

========================================================================

This is a demonstration of the DEnsity of Fog Assessment-based DEfogger (DEFADE).
It is an implementation of the DEFADE in the reference.
The algorithm is described in:
L. K. Choi, J. You, and A. C. Bovik, "Referenceless Prediction of Perceptual Fog Density and Perceptual Image Defogging,"
IEEE Transactions on Image Processing, vol. 24, no. 11, pp. 3888-3901, Nov. 2015.

You can change this program as you like and use it anywhere, but please
refer to its original source (cite our paper and our web page at
http://live.ece.utexas.edu/research/fog/DEFADE_release.zip).

Input : A foggy 8bits/pixel color image loaded in a 3-D array.
Output: A defogged image. 

Usage:

1. Load the image, for example
  image = imread('test_image1.png');

2. Call this function to defog the input foggy image:
  Defogged_image = DEFADE(image);

Sample demo is also shown through DEFADE_example.m


Files (provided with release):
MATLAB files:  DEFADE.m, DEFADE_example.m CE.m border_in.m border_out.m FADE_overlapped.m 
               W_chrominance.m W_contrast.m W_luminance.m W_saturation.m 
Image files:   test_image1.png test_image2.jpg test_image3.jpg
Data files:    natural_fogfree_features_overlapped_patch_ps8.mat natural_foggy_features_overlapped_patch_ps8.mat 
Dependencies:  I used some codes from other research as follows,
  Guided filter [13]:         boxfilter.m, guidedfilter.m
  Multiscale refinement [55]: downsample.m gaussian_pyramid.m laplacian_pyramid.m pyramid_filter.m 
                              reconstruct_laplacian_pyramid.m set_border.m upsample.m 
  Saliency [53]:              W_saliency.m
  Whilt balance [52]:         white_balance.m
  
    
This release version of DEFADE is based on a corpus of 500 fog-free images and another corpus of 500 foggy images
with patch size set to 8 X 8. The foggy and fog-free images that were used in our experiments can be found at
http://live.ece.utexas.edu/research/fog/index.html.

This code has been tested on Windows. 
========================================================================
