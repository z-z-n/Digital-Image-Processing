%% RUN BF Script
clear all;
warning('off','all')
% Testing will first happen on CURE-TSR images.

% Load in the Ground Truth Images
cur_image_path = 'E:\ZN\6258dataset\cure_or\';
cur_image_save = '..\result\BF\cure_or\';

%\noised\level\texture\device\img
cur_image_files = dir(fullfile(cur_image_path, '\noised\**\*.*'));
cur_image_files = cur_image_files(~[cur_image_files.isdir]);  %remove folders from list

n_files = length(cur_image_files);  
j = 6669;
sigmas = 5;
sigmar = 40;

%tic

for i=1:25:n_files
    curr_image_meta = strsplit(cur_image_files(i).name, '_');
    curImage = imread(strcat(cur_image_files(i).folder, '\', cur_image_files(i).name));
    
    basedFilename = strcat(curr_image_meta{1, 1}, '_', curr_image_meta{1, 2}, '_', curr_image_meta{1, 3}, '_', curr_image_meta{1, 4}, '_', '*.*');
    bsd_image_meta = strsplit(cur_image_files(i).folder, '\');
    t_csize=size(bsd_image_meta,2);
    basedFilepath = strcat(cur_image_path, '\01_no_challenge\', bsd_image_meta{1,t_csize-1}, '\', bsd_image_meta{1,t_csize}, '\');
    bsImagedir = dir(fullfile(basedFilepath, basedFilename));
    %bsImagedir = dir(fullfile(cur_image_path, '\01_no_challenge\**\', basedFilename));
    basedImage = imread(strcat(bsImagedir.folder, '\', bsImagedir.name));
    
    if size(basedImage,3)>1
        basedImageColor = imresize(basedImage, [256 256]);
        basedImage_gray = im2gray(imresize(basedImage, [256 256]));
    else
        basedImageColor(:, :, 1) = imresize(basedImage(:, :, 1), [256 256]);
        basedImageColor(:, :, 2) = imresize(basedImage(:, :, 1), [256 256]);
        basedImageColor(:, :, 3) = imresize(basedImage(:, :, 1), [256 256]);
        basedImage_gray = imresize(basedImage, [256 256]);
    end
    
    if size(curImage,3)>1
        denoisedImageColor = imresize(curImage, [256 256]);
        denoisedImage_gray = im2gray(imresize(curImage, [256 256]));
    else
        denoisedImageColor(:, :, 1) = imresize(curImage(:, :, 1), [256 256]);
        denoisedImageColor(:, :, 2) = imresize(curImage(:, :, 1), [256 256]);
        denoisedImageColor(:, :, 3) = imresize(curImage(:, :, 1), [256 256]);
        denoisedImage_gray = imresize(curImage, [256 256]);
    end
    [denoisedImage_gray, param_gray] = shiftableBF(double(denoisedImage_gray), sigmas, sigmar);
    [denoisedImageColor(:, :, 1), param1] = shiftableBF(double(denoisedImageColor(:, :, 1)), sigmas, sigmar);
    [denoisedImageColor(:, :, 2), param2] = shiftableBF(double(denoisedImageColor(:, :, 2)), sigmas, sigmar);
    [denoisedImageColor(:, :, 3), param3] = shiftableBF(double(denoisedImageColor(:, :, 3)), sigmas, sigmar);
    
    denoisedImage_gray = im2uint8(mat2gray(denoisedImage_gray));
    denoisedImageColor = im2uint8(denoisedImageColor);
    basedImageColor = im2uint8(basedImageColor);

    t_name=strcat(cur_image_save,cur_image_files(i).name);
    %imwrite(denoisedImageColor,t_name);

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
    
    t_num1 = floor((i - 1)/62500);
    t_num = floor((i - 1 - t_num1*62500)/2500);
    csv_name = strcat(cur_image_save, 'IQA_', num2str(t_num1 + 1), '_', num2str(t_num+1),'.csv');
    writematrix(record,csv_name,'WriteMode','append');

    progress = num2str(i/n_files * 100);
    disp(strcat('Progress : ', progress,  '%'));
    %j = j + 4;

end
%toc