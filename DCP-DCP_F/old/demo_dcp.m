
    img_hazy = double(img_hazy)/255; 
    
    result = dehaze(img_hazy, 0.95, 15);
  
%     figure; imshow(result);title('Dark Channel')
    
 