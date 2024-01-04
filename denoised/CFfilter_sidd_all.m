%% RUN CF Script
clear all;
warning('off','all')
% Testing will first happen on CURE-TSR images.

% Load in the Ground Truth Images
cur_image_path = '..\dataset\sidd\test';
cur_image_save = '..\result\CF\sidd\denoised\';

%\noised\img
cur_image_files = dir(fullfile(cur_image_path, '\noisy\*.*'));
cur_image_files = cur_image_files(~[cur_image_files.isdir]);  %remove folders from list

csv_name = strcat(cur_image_save, 'IQA_sidd.csv');

n_files = length(cur_image_files);  
j = 1;

FilterType = 4;
Iteration = 4;

%tic
for i=1:n_files
    curr_image_meta = strsplit(cur_image_files(i).name, '_');
    curImage = imread(strcat(cur_image_files(i).folder, '\', cur_image_files(i).name));
    
    basedFilename = strcat(curr_image_meta{1, 1}, '_', curr_image_meta{1, 2}, '_', '*.*');
    bsImagedir = dir(fullfile(cur_image_path, '\gt\', basedFilename));
    basedImage = imread(strcat(bsImagedir.folder, '\', bsImagedir.name));
    
    if size(basedImage,3)>1
        basedImageColor(:, :, 1) = imresize(basedImage(:, :, 1), [256 256]);
        basedImageColor(:, :, 2) = imresize(basedImage(:, :, 2), [256 256]);
        basedImageColor(:, :, 3) = imresize(basedImage(:, :, 3), [256 256]);
        basedImage_gray = im2gray(basedImage);
    else
        basedImageColor(:, :, 1) = imresize(basedImage(:, :, 1), [256 256]);
        basedImageColor(:, :, 2) = imresize(basedImage(:, :, 1), [256 256]);
        basedImageColor(:, :, 3) = imresize(basedImage(:, :, 1), [256 256]);
        basedImage_gray = basedImage;
    end
    basedImage_gray = imresize(basedImage_gray, [256 256]);
    %imshow(basedImageColor)

    if size(curImage,3)>1
        denoisedImageColor(:, :, 1) = imresize(curImage(:, :, 1), [256 256]);
        denoisedImageColor(:, :, 2) = imresize(curImage(:, :, 2), [256 256]);
        denoisedImageColor(:, :, 3) = imresize(curImage(:, :, 3), [256 256]);
        denoisedImage_gray = im2gray(curImage);
    else
        denoisedImageColor(:, :, 1) = imresize(curImage(:, :, 1), [256 256]);
        denoisedImageColor(:, :, 2) = imresize(curImage(:, :, 1), [256 256]);
        denoisedImageColor(:, :, 3) = imresize(curImage(:, :, 1), [256 256]);
        denoisedImage_gray = curImage;
    end
    denoisedImage_gray = imresize(denoisedImage_gray, [256 256]);
    [denoisedImage_gray,energy_gray]=CFilter(denoisedImage_gray,FilterType, Iteration);
    [denoisedImageColor(:, :, 1),energy1]=CFilter(denoisedImageColor(:, :, 1),FilterType, Iteration);
    [denoisedImageColor(:, :, 2),energy2]=CFilter(denoisedImageColor(:, :, 2),FilterType, Iteration);
    [denoisedImageColor(:, :, 3),energy3]=CFilter(denoisedImageColor(:, :, 3),FilterType, Iteration);
    denoisedImage_gray = im2uint8(mat2gray(denoisedImage_gray));
    denoisedImageColor = im2uint8(denoisedImageColor);
    basedImageColor = im2uint8(basedImageColor);
    %imwrite(denoisedImageColor,'myfig1.jpg')
    %imwrite(basedImageColor,'myfig.jpg')

    t_name=strcat(cur_image_save,cur_image_files(i).name);
    imwrite(denoisedImageColor,t_name);

    % Calculate the PSNR 
    currImage.psnr = psnr(denoisedImageColor, basedImageColor);
    % Calculate SSIM
    currImage.ssim = ssim(denoisedImage_gray, basedImage_gray);
    % Calculate CW-SSIM 
    currImage.cw_ssim = cwssim(denoisedImage_gray, basedImage_gray, 6, 16, 0, 0);
    % Calculate UNIQUE 
    currImage.unique = mslUNIQUE(denoisedImageColor, basedImageColor);
    % Calculate MSL-UNIQUE
    currImage.ms_unique = mslMSUNIQUE(denoisedImageColor, basedImageColor);
    % Calculate CSV
    currImage.csv = csv(denoisedImageColor, basedImageColor);
    % Calculate SUMMER
    currImage.summer = SUMMER(denoisedImageColor, basedImageColor);
    
    numericParts = regexp(cur_image_files(i).name, '\d', 'match');
    combinedNumericString = strjoin(numericParts, '');
    numericValue = str2double(combinedNumericString);
    record=[numericValue, currImage.psnr,currImage.ssim,currImage.cw_ssim,currImage.unique,currImage.ms_unique,currImage.csv,currImage.summer];
    
    writematrix(record,csv_name,'WriteMode','append');

    progress = num2str(i/n_files * 100);
    disp(strcat('Progress : ', progress,  '%'));

end
%toc