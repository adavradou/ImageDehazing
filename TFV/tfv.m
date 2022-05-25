  
function [dh_img] = tfv(h_img)
    
    %h_img = im2double(h_img);
    h_img = double(h_img)./255.0;
   

% Color example of visibility restoration
%     orig=double(imread('sweden.jpg'))/255.0;
    sv=2*floor(max(size(h_img))/50)+1;
    % ICCV'2009 paper result (NBPC)
%     res=nbpc(img_hazy,sv,0.80,0.5,1,1.3);
    dh_img = nbpc(h_img,sv,0.95,0.5,1,1.3);
%     figure;imshow(img_hazy);title('Hazy');
%     figure;imshow(res);title('Tarel 09');
     