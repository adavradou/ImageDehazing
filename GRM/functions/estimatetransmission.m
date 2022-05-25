function transmission = estimatetransmission(im, A, win_size, omega)

eps = 0.1^2;
for c = 1:size(im,3)
   normlizedI(:,:,c) = im(:,:,c)/A(c);  
end

dark = darkchannel(normlizedI, win_size);
% figure;imshow(dark);
transmissionold = 1-omega*dark;

se = strel('square',win_size);
transmission = imerode(transmissionold,se);






