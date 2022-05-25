% Artusi 25/10/2018:
% - Converted to function:
% input: h_img - path hazy image
% output: dh_img - dehazed image

function dh_img = CAP(h_img)
    r = 15;
    beta = 1.0;

    %----- Parameters for Guided Image Filtering -----
    gimfiltR = 60;
    eps = 10^-3;
    %-------------------------------------------------
    
    [dR, dP] = calVSMap(h_img, r);
    refineDR = imguidedfilter(dR, h_img, 'NeighborhoodSize', [gimfiltR, gimfiltR], 'DegreeOfSmoothing', eps);
    tR = exp(-beta*refineDR);
    tP = exp(-beta*dP);

    a = estA(h_img, dR);
    t0 = 0.05;
    t1 = 1;
    h_img= double(h_img)/255;
    [h w c] = size(h_img);
    dh_img = zeros(h,w,c);
    dh_img(:,:,1) = h_img(:,:,1)-a(1);
    dh_img(:,:,2) = h_img(:,:,2)-a(2);
    dh_img(:,:,3) = h_img(:,:,3)-a(3);

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

dh_img(:,:,1) = dh_img(:,:,1)./t;
dh_img(:,:,2) = dh_img(:,:,2)./t;
dh_img(:,:,3) = dh_img(:,:,3)./t;

dh_img(:,:,1) = dh_img(:,:,1)+a(1);
dh_img(:,:,2) = dh_img(:,:,2)+a(2);
dh_img(:,:,3) = dh_img(:,:,3)+a(3);

  
  