%% RUN CF Script
clear all;
warning('off','all')
% Testing will first happen on CURE-TSR images.

% Load in the Ground Truth Images
cur_image_path = '..\dataset\set12\';
cur_image_save = '..\result\CF\set12\';

cur_image_files = dir(fullfile(cur_image_path, '**\*.*'));
cur_image_files = cur_image_files(~[cur_image_files.isdir]);  %remove folders from list

n_files = length(cur_image_files);  

FilterType = 4;
Iteration = 4;

for i=13:n_files
    curImage = imread(strcat(cur_image_files(i).folder, '\', cur_image_files(i).name));
    bsImagedir = dir(strcat(cur_image_path, '0_gt\',cur_image_files(i).name));
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
    
    t_num = floor((i - 13)/12);
    t_name=strcat(cur_image_save, num2str(t_num), cur_image_files(i).name);
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
    
    
    csv_name = strcat(cur_image_save, 'IQA',num2str(t_num),'.csv');
    writematrix(record,csv_name,'WriteMode','append');

    progress = num2str(i/n_files * 100);
    disp(strcat('Progress : ', progress,  '%'));
    %j = j + 20;

end
