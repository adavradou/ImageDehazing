
    %img_hazy= imread('inputImgs/girl2.png');
    r = 15;
    beta = 1.0;

    %----- Parameters for Guided Image Filtering -----
    gimfiltR = 60;
    eps = 10^-3;
    %-------------------------------------------------
    
    [dR, dP] = calVSMap(img_hazy, r);
    refineDR = imguidedfilter(dR, img_hazy, 'NeighborhoodSize', [gimfiltR, gimfiltR], 'DegreeOfSmoothing', eps);
    tR = exp(-beta*refineDR);
    tP = exp(-beta*dP);

    a = estA(img_hazy, dR);
    t0 = 0.05;
    t1 = 1;
    img_hazy= double(img_hazy)/255;
    [h w c] = size(img_hazy);
    J = zeros(h,w,c);
    J(:,:,1) = img_hazy(:,:,1)-a(1);
    J(:,:,2) = img_hazy(:,:,2)-a(2);
    J(:,:,3) = img_hazy(:,:,3)-a(3);

    t = tR;
    [th tw] = size(t);
    
for y=1:th
    for x=1:tw
        if t(y,x)<t0
            t(y,x)=t0;
        end
    end
end

for y=1:th
    for x=1:tw
        if t(y,x)>t1
            t(y,x)=t1;
        end
    end
end

J(:,:,1) = J(:,:,1)./t;
J(:,:,2) = J(:,:,2)./t;
J(:,:,3) = J(:,:,3)./t;

J(:,:,1) = J(:,:,1)+a(1);
J(:,:,2) = J(:,:,2)+a(2);
J(:,:,3) = J(:,:,3)+a(3);
% 
%     baseFileName = 'CAP.jpg'; 
%     fullFileName = fullfile(folder_results, baseFileName);
%     imwrite(J, fullFileName);

%     figure; imshow(J);title('CAP')
  
  