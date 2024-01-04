%% RUN CF Script
clear all;
warning('off','all')
% Testing will first happen on CURE-TSR images.

% Load in the Ground Truth Images
cure_tsr_image_path = '..\dataset\NWPU_RESISC45\';
%cure_tsr_image_save = '..\result\CF\cure_tsr\Decolorization-1\';
cure_tsr_image_save = '..\result\CF\NWPU_RESISC45\';
%csv_name = '..\result\CF\cure_tsr\Decolorization-1\IQA.csv';

cure_tsr_image_files = dir(fullfile(cure_tsr_image_path, '**\*.*'));
%cure_tsr_image_files = dir(fullfile(cure_tsr_image_path, 'Decolorization-1\*.*'));
cure_tsr_image_files = cure_tsr_image_files(~[cure_tsr_image_files.isdir]);  %remove folders from list

n_files = length(cure_tsr_image_files);  
j = 1;
% currentimage = imread(strcat(cure_tsr_image_files(i).folder, '\', cure_tsr_image_files(i).name));
FilterType = 4;
Iteration = 4;
for i=1:10:n_files
    curr_image_meta = strsplit(cure_tsr_image_files(i).name, '_');
    curImage_t = imread(strcat(cure_tsr_image_files(i).folder, '\', cure_tsr_image_files(i).name));
    %bsImagedir = dir(strcat(cure_tsr_image_path, 'ChallengeFree\',curr_image_meta{1, 1}, '_', curr_image_meta{1, 2}, '_', '*', curr_image_meta{1, 5}));
    %basedImage = imread(strcat(bsImagedir.folder, '\', bsImagedir.name));
    basedImage = curImage_t;
    %curImage = imnoise(curImage_t,'gaussian');
    curImage = imnoise(curImage_t,'salt & pepper');
    
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
    t_name=strcat(cure_tsr_image_save,cure_tsr_image_files(i).name);
    % imwrite(denoisedImageColor,t_name);

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
    
    numericParts = regexp(cure_tsr_image_files(i).name, '\d', 'match');
    combinedNumericString = strjoin(numericParts, '');
    numericValue = str2double(combinedNumericString);
    record=[numericValue, currImage.psnr,currImage.ssim,currImage.cw_ssim,currImage.unique,currImage.ms_unique,currImage.csv,currImage.summer];
    
    t_num = floor((i - 1)/700);
    csv_name = strcat(cure_tsr_image_save, 'IQA',num2str(t_num),'.csv');
    writematrix(record,csv_name,'WriteMode','append');

    progress = num2str(i/n_files * 100);
    disp(strcat('Progress : ', progress,  '%'));
    %j = j + 20;

end
