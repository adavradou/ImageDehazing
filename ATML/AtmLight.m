%Finds and returns the Atmospheric light color (orientation and magnitude) of the given image
% Artusi 26/10/2018: converted to a function

function [dh_img] = AtmLight(h_img)

showFigures = 0;
h_img = double(h_img)./255.0;
%img_hazy = img_hazy.^1.5; %gamma correction might help orientation recovery

A = findOrientation(h_img,showFigures);

%mag = findMagnitude(img_hazy,A,showFigures);
[mag, dh_img] = findMagnitude(h_img,A,showFigures);

% figure; imshow(dehazed_image); title('Sulami et al.');



    