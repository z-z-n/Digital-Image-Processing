%% RUN BF Script
clear all;
warning('off','all')
% Testing will first happen on CURE-TSR images.

% Load in the Ground Truth Images
cure_tsr_image_path = '..\dataset\NWPU_RESISC45\';
% cure_tsr_image_save = '..\result\BF\cure_tsr\Decolorization-1\';
cure_tsr_image_save = '..\result\BF\NWPU_RESISC45\';
csv_name = strcat(cure_tsr_image_save, 'IQA.csv');

cure_tsr_image_files = dir(fullfile(cure_tsr_image_path, '**\*.*'));
%cure_tsr_image_files = dir(fullfile(cure_tsr_image_path, 'Decolorization-1\*.*'));
cure_tsr_image_files = cure_tsr_image_files(~[cure_tsr_image_files.isdir]);  %remove folders from list

n_files = length(cure_tsr_image_files);  
j = 1;
sigmas = 5;
sigmar = 40;

for i=1:10:n_files
    curr_image_meta = strsplit(cure_tsr_image_files(i).name, '_');
    curImage_t = imread(strcat(cure_tsr_image_files(i).folder, '\', cure_tsr_image_files(i).name));
    basedImage = curImage_t;
    %curImage = imnoise(curImage_t,'gaussian', 0, 0.05);
    %curImage = imnoise(curImage_t,'salt & pepper');
    curImage = imnoise(curImage_t, 'poisson');
    %imshow(curImage);
    %imshow(basedImage);

    %bsImagedir = dir(strcat(cure_tsr_image_path, 'ChallengeFree\',curr_image_meta{1, 1}, '_', curr_image_meta{1, 2}, '_', '*', curr_image_meta{1, 5}));
    %basedImage = imread(strcat(bsImagedir.folder, '\', bsImagedir.name));
    
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
    t_name=strcat(cure_tsr_image_save,cure_tsr_image_files(i).name);
    %imwrite(denoisedImageColor,t_name);
    %curImage = imresize(curImage, [256 256]);
    %imshow(denoisedImageColor);

    % Calculate the PSNR 
    currImage.psnr = psnr(denoisedImageColor, basedImageColor);
    % Calculate SSIM
    currImage.ssim = ssim(denoisedImageColor, basedImageColor);
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

    %t_name = str2double(regexp(cure_tsr_image_files(i).name, '\d', 'match'));
    numericParts = regexp(cure_tsr_image_files(i).name, '\d', 'match');
    combinedNumericString = strjoin(numericParts, '');
    numericValue = str2double(combinedNumericString);
    record=[numericValue, currImage.psnr,currImage.ssim,currImage.cw_ssim,currImage.unique,currImage.ms_unique,currImage.csv,currImage.summer];
    
    %t_num = floor((i - 1)/700);
    %csv_name = strcat(cure_tsr_image_save, 'IQA',num2str(t_num),'.csv');
    writematrix(record,csv_name,'WriteMode','append');

    progress = num2str(i/n_files * 100);
    disp(strcat('Progress : ', progress,  '%'));
    %j = j + 10;

end