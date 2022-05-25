% Artusi 26/10/2018
% - Converted to a function
% - output image double
function [dh_img] = Fattal(h_img, absolute) 

    [r,c,rc]=size(h_img);
   
    I=zeros(r*c,3);
    I(:,1)=reshape(double(h_img(:,:,1))/255.0,r*c,1);  
    I(:,2)=reshape(double(h_img(:,:,2))/255.0,r*c,1);
    I(:,3)=reshape(double(h_img(:,:,3))/255.0,r*c,1);

    A = [0.8 0.8 0.9]';
%     A = [0.755, 0.77, 0.77]'; %Find A estimates here: http://www.cs.huji.ac.il/~raananf/projects/dehaze_cl/results/
    if (absolute)
       [est_t est_l est_eta] = estimate_absolute(A, I);
    else
       [est_t est_l est_eta] = estimate_zeros(A, I);
    end
    R=[175 172 172];
    t = reshape(est_t,r,c);
    
    min1=min(min(t));   %Normalization of t
    max1=max(max(t));
    t=(t-min1)/(max1-min1);  
    t=max(t,0.1);
    
    for ii=1:3
        dh_img(:,:,ii) = 1.0*((double(h_img(:,:,ii)) - (1-t)*double(R(ii)))./t); %uint8(1.0*((double(h_img(:,:,ii)) - (1-t)*double(R(ii)))./t));
    end

    
    
    