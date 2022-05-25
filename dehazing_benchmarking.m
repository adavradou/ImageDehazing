%---------------------------------------------------------------------------------------------------------------
% Inputs:
% 1. clear_path - the dataset path where the clear images are, a common BASE_PATH
%                 is encoded in the code; final path will be BASE_PATH +
%                 clear_path;
% 2. hazy_path -  the dataset path where the hazy images are, a common BASE_PATH
%                 is encoded in the code; final path will be BASE_PATH +
%                 hazy_path;
% 3. methods - hazy method 'method' or list of hazy methods to test ['method1'
%              'method2' etc.]
%              Implemented methods are:
%              'MSCNN'     - 
%              'DEHAZENET' - 
%              'AODNET'    - 
%              'NLD'       - Non-Local Image Dehazing. Berman, D. and Treibitz, T. and Avidan S., CVPR2016
%              'CAP'       - 
%              'GRM'       - 
%              'AMEF'      - 
%              'DEFADE'    -
%              'ATML' - 
%              'BCCR' - 
%              'TFV' - 
%              'ABSL' - 
%              'ZERO' - 
%              '' - 
%              '' - 
%              '' - ;
% 4. metric - objective metric used for evaluation possible choices:
%              'PSNR'      - Peak Signal to Noise Ratio
%              'MSE'       - Mean Square Error
%              'SSIM'      - Structural Similarity Index Metric
%              'HDRVDP'    - HDR-VDP set up for SDR images;
%
% 5. clipping - 1 does teh clipping to [0,1] after the imgae has been dehazed, 0 does normalization in [0, 1];        
%---------------------------------------------------------------------------------------------------------------
function dehazing_benchmarking(clear_path, hazy_path, methods, metric, clipping)

% Common PATH for both input data - images - and results; different syntax
% for MAC and WINDOWS OS

MAC = 1;
if MAC
    BASE_PATH = '/Volumes/KIOS Storage/04_Personal_Documents/aartus01/';
else
    BASE_PATH = '//kiosfilesvr2.ucy.ac.cy/KIOS Storage/04_Personal_Documents/aartus01/';
end

% PATHS for the images - DATA_PATH and where the results will be stored - RESULTS_PATH 
DATA_PATH = [BASE_PATH 'Haze-Datasets/'];
RESULTS_PATH = [BASE_PATH 'Results/Benchmarking/'];

% Creatig the folder where the resuts are stored
if ~exist([RESULTS_PATH clear_path metric], 'dir')
   [status, sms, smsid] = mkdir([RESULTS_PATH clear_path metric]);
   clear sms smsid;
   if ~(status)
       disp('Folder results has not been created we need to terminate');
       exit(status);
   end
end

% extracting the type of dataset name
dataset = strtok(clear_path, '/');

% extracting images names
HAZY_PATH = [DATA_PATH hazy_path];
CLEAR_PATH = [DATA_PATH clear_path];
h_paths = find_dataset(HAZY_PATH, dataset);
cl_paths = find_dataset(CLEAR_PATH, dataset);
% number of images
n_img = length(cl_paths');
    
for k=1:length(methods)
    % Initialization metrics
    metric_err = zeros(1, n_img);
    %j_old = 0;
    for j = 1:n_img     
        
        % Reading both clear and hazy images
          % cLear image
        cl_filename = char(cl_paths(j));
        cl_path = [CLEAR_PATH, cl_filename];
        cl_img = double(imread(cl_path))./255.0;
          % hazy image
        h_filename = char(h_paths(j));
        h_path = [HAZY_PATH, h_filename];
        h_img = double(imread(h_path))./255.0;
        
        % NTIRE 2108 dataset contain hig resolution images, 
        % we downsample it to reduce memory management issues
        if strcmp(dataset, 'NITRE')
            h_img = imresize(h_img, 0.25, 'lanczos2');
            cl_img = imresize(cl_img, 0.25, 'lanczos2');
        end
        
        % Methods selection -
        
        % 1. Multi Scale Conv NN
        if any(strcmp(methods,'MSCNN'))
           current_method = 'MSCN';
           dh_img = mscnn(h_img);
        end
        
        % 2. Dehazenet
        if any(strcmp(methods,'DEHAZENET'))
           current_method = 'DEHAZENET';
           dh_img = run_cnn(h_img);
        end
        
        % 3. AOD NET
        if any(strcmp(methods,'AOD NET'))
           current_method = 'AOD NET'; 
           dh_img = aodnet(h_img);
        end
        
        % 4. Dark Channel Prior
        if any(strcmp(methods,'DCP'))
           current_method = 'DCP'; 
           dh_img = dehaze(h_img, 0.95, 15);
        end
        
        % 5. NLD
        if any(strcmp(methods,'NLD'))
           current_method = 'NLD';
           gamma = 2.2;
           [dh_img, tr] = nl_dehazing(h_img, gamma);
           clear tr;
        end
        
        % 6. CAP
        if any(strcmp(methods,'CAP'))
           current_method = 'CAP';  
           dh_img = CAP(h_img);
        end
        
         % 7. 
        if any(strcmp(methods,'GRM'))
           current_method = 'GRM';
           dh_img = grm(h_img);
        end
        
        % 8. 
        if any(strcmp(methods,'AMEF'))
           current_method = 'AMEF';
           clip_range = 0.010;
           dh_img = amef(h_img, clip_range);
        end
        
        % 9. 
        if any(strcmp(methods,'DEFADE'))
           current_method = 'DEFADE';
           dh_img = DEFADE(h_img);
        end
        
        % 10. 
        if any(strcmp(methods,'ATML'))
           current_method = 'ATML';
           dh_img = AtmLight(h_img);
        end
        
        % 11. 
        if any(strcmp(methods,'BCCR'))
           current_method = 'BCCR';            
           dh_img = bccr(h_img);
        end
        
        % 12. 
        if any(strcmp(methods,'TFV'))
           current_method = 'TFV';
           dh_img = tfv(h_img);
        end
        
        % 13. Fattal absolute and zeros
        if any(strcmp(methods,'ABSL'))
           current_method = 'ABSL';
           absolute = 1;
           dh_img = Fattal(h_img, absolute);
        end
        
        % 14. 
        if any(strcmp(methods,'ZERO'))
           current_method = 'ZERO';
           absolute = 0;
           dh_img = Fattal(h_img, absolute);
        end
        
        
        
           
%             case 14
%                 current_method = methods_names{14};
%                 %Delete existing results in the results folder
%                 folder_to_delete = '/home/agapi/Documents/Other_approaches/03_AOD-Net-master/data/result';
%                 % Get a list of all files in the folder with the desired file name pattern.
%                 filePattern = fullfile(folder_to_delete, '*.jpg'); % Change to whatever pattern you need.
%                 theFiles = dir(filePattern);
%                 for k = 1 : length(theFiles)
%                   baseFileName = theFiles(k).name;
%                   fullFileName = fullfile(folder_to_delete, baseFileName);
%                   disp('Now deleting images from Results folder of the AOD method');
%                   delete(fullFileName);
%                 end
%                 
%                 systemCommand = ['sudo python3.6 /home/agapi/Documents/Other_approaches/03_AOD-Net-master/test/test.py'];
%                 cell2pylist1(h_img(j), '/home/agapi/Documents/Other_approaches/hazy_data.txt')
%                 cell2pylist2(cl_img(j), '/home/agapi/Documents/Other_approaches/clear_data.txt')
%                 system(systemCommand);
%                 
%                 myFolder = '/home/agapi/Documents/Other_approaches/03_AOD-Net-master/data/result';
%                 filePattern = fullfile(myFolder, '*.jpg');
%                 jpegFiles = dir(filePattern);
%                 %     Read files from different directories. Best way to do it is by using fullfilename.
%                 %     Check this: http://matlab.wikia.com/wiki/FAQ#How_can_I_process_a_sequence_of_files.3F
%                 baseFileName = jpegFiles.name;
%                 disp(baseFileName)
%                 fullFileName = fullfile(myFolder, baseFileName);
%                 dehazed_image = imread(fullFileName);
%             case 15
%                 current_method = methods_names{15};
%                 %Delete existing results in the results folder
%                 folder_to_delete = '/home/agapi/Documents/Other_approaches/13_2009_Kratz_Factorizing_Scene_Albedo/result';
%                 % Get a list of all files in the folder with the desired file name pattern.
%                 filePattern = fullfile(folder_to_delete, '*.jpg'); % Change to whatever pattern you need.
%                 theFiles = dir(filePattern);
%                 for k = 1 : length(theFiles)
%                   baseFileName = theFiles(k).name;
%                   fullFileName = fullfile(folder_to_delete, baseFileName);
%                   disp('Now deleting images from Results folder of the Kratz method');
%                   delete(fullFileName);
%                 end                
%                 systemCommand = ['sudo python3.6 /home/agapi/Documents/Other_approaches/13_2009_Kratz_Factorizing_Scene_Albedo/defog.py'];
%                 cell2pylist1(h_img(j), '/home/agapi/Documents/Other_approaches/hazy_data.txt')
%                 cell2pylist2(cl_img(j), '/home/agapi/Documents/Other_approaches/clear_data.txt')
%                 system(systemCommand);
%                 
%                 myFolder = '/home/agapi/Documents/Other_approaches/13_2009_Kratz_Factorizing_Scene_Albedo/result/';
%                 filePattern = fullfile(myFolder, '*.jpg');
%                 jpegFiles = dir(filePattern);
%                 %     Read files from different directories. Best way to do it is by using fullfilename.
%                 %     Check this: http://matlab.wikia.com/wiki/FAQ#How_can_I_process_a_sequence_of_files.3F
%                 baseFileName = jpegFiles.name;
%                 disp(baseFileName)
%                 fullFileName = fullfile(myFolder, baseFileName);
%                 dehazed_image = imread(fullFileName);                 
        
        % assure that the dh_img is always double
        if (isa(class(dh_img), 'uint8'))
            dh_img = double(dh_img)./255.0;
        end
        % Clipping or Normalize the dehazed image to [0,1]
        if ~(clipping) % Image Normalization
           dh_min = min(min(min(dh_img)));
           dh_max = max(max(max(dh_img)));
           if dh_min < 0 || dh_max >1
              dh_img = ((dh_img - dh_min)./(dh_max - dh_min));
           end
        else % Clipping to [0,1]
            idx0 = find(dh_img < 0);
            idx1 = find(dh_img > 1);
            dh_img(idx0) = 0;
            dh_img(idx1) = 1;
        end
        
        %%%%%% Calculate metrics for each pair of images of one method %%%%
        switch metric 
            case 'PSNR'   % PSNR metric   
                metric_err(j) = psnr(dh_img, cl_img); 
            case 'MSE'    % MSE metric
                metric_err(j) = immse(dh_img, cl_img); 
            case 'SSIM'   % SSIM metric 
                metric_err(j) = ssim(dh_img, cl_img); 
            case 'HDRVDP' % HDRVDP metric
               % Parameters for HDR-VDP metric for case LDR Images
               gamma = 2.2;
               L_max = 100;
               L_min = 0.5;
               [r c ch] = size(cl_img);
               clear r c;

               R = (double(cl_img/255.0).^gamma * (L_max-L_min) + L_min);
               T = (dh_img).^gamma * (L_max-L_min) + L_min;
               if(ch == 3)
                   color_encoding = 'rgb-bt.709';
                   %else % case of grayscale
                   %color_encoding = 'luma';  
                end
                ppd = hdrvdp_pix_per_deg(47, [1920 1080], 1.9);
                p = hdrvdp( R + (T-R)*0.1, R, color_encoding, ppd, {'peak_sensitivity', 2.0 } );
                clear T R ppd;
                
                metric_err(j) = p.Q;
                
        end % switch metrics
       
        if(j == 1) % need to do only one time per method
          csv_fname = strcat([RESULTS_PATH clear_path metric '/'], char(metric), '_', current_method, '.csv');
        end
        csv_id = fopen(csv_fname, 'a');
        
        fprintf(csv_id, '%s, ', char(h_paths(j)));
        fprintf(csv_id, '%.10f\n', metric_err(j));
    end  % end for n_img
    
    fclose(csv_id); % closing the csv file where the results are stored
end % end for methods

