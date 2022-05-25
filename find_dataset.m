function output = find_dataset(path, set)

% Get list of all images files in a folder
% DIR returns as a structure array.  You will need to use () and . to get
% the file names.

% Artusi 25/10/2018:
% - modified to accept strings for the dataset names strcmp
% - modified to select automatically all the images in the folder

if strcmp(set, 'D-HAZY') %The D-Hazy dataset has .bmp hazy images and .png clear images
    imagefiles = dir([path '/*.bmp' ]);
    imagefiles = [imagefiles dir([path '/*.png' ])];
else
    imagefiles = dir([path '/*.jpg' ]);
end


for i=1:length(imagefiles)
    output{i} = imagefiles(i).name;
end