  
    img_hazy = im2double(img_hazy);
   

% Color example of visibility restoration
%     orig=double(imread('sweden.jpg'))/255.0;
    sv=2*floor(max(size(img_hazy))/50)+1;
    % ICCV'2009 paper result (NBPC)
%     res=nbpc(img_hazy,sv,0.80,0.5,1,1.3);
    res=nbpc(img_hazy,sv,0.95,0.5,1,1.3);
%     figure;imshow(img_hazy);title('Hazy');
%     figure;imshow(res);title('Tarel 09');
     