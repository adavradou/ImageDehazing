% addpath(genpath('.'));

% This MatConvNet is compiled under Win7, you can also compile MatConvNet
% under Linux, Mac, and Windows, then run our "demo_MSCNNdehazing.m".

run(fullfile(fileparts(mfilename('fullpath')), './matlab/vl_setupnn.m')) ;

gamma = 1; 
dehazedImageRGB = mscnndehazing(hazy_images{j}, gamma, folder_hazy);
        
%     figure; imshow(orimg);title('Clear image');
%     figure; imshow(imread(fullfile(folder_hazy, char(hazy_images(i)))));title('Hazy image')
%     figure; imshow(dehazedImageRGB);title('MSCNN')    

