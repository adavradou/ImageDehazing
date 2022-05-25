
% Increase clip_range to remove more haze - at the risk of overenhancement
    clip_range = 0.010;


    amef_im = amef(im2double(img_hazy), clip_range);


%     figure; imshow(amef_im);title('AMEF')
    
