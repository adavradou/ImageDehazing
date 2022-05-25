   
    img_hazy=double(img_hazy)./255;
    dehazed_image=run_cnn(img_hazy);
    
% baseFileName = 'DehazeNet.jpg'; 
% fullFileName = fullfile(folder_results, baseFileName);
% imwrite(dehazed_image, fullFileName);

%     figure; imshow(dehazed_image);title('DehazeNet'); 
%     figure;subplot(221);imshow(imread(hazy_images{i}));title('Haze');
%     subplot(222);imshow(orimg);title('Original');
%     subplot(223);imshow(dehaze);title('Dehazed');
%        

