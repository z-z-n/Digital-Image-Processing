%% RUN BLSGSM Script
clear all;
warning('off','all')
% Testing will first happen on CURE-TSR images.

% Load in the Ground Truth Images
cure_tsr_image_path = 'D:\CURE-TSR\Real_Test\';

cure_tsr_image_files = dir(fullfile(cure_tsr_image_path, '**\*.*'));
cure_tsr_image_files = cure_tsr_image_files(~[cure_tsr_image_files.isdir]);  %remove folders from list

n_files = length(cure_tsr_image_files);  
j = 1;
% currentimage = imread(strcat(cure_tsr_image_files(i).folder, '\', cure_tsr_image_files(i).name));
gtImage = imread('2.png');
st = imfinfo('2.png'); 
%st.ColorType
gtImageColor(:, :, 1) = double(imresize(gtImage(:, :, 1), [256 256]));
gtImageColor(:, :, 2) = double(imresize(gtImage(:, :, 1), [256 256]));
gtImageColor(:, :, 3) = double(imresize(gtImage(:, :, 1), [256 256]));
gtImage_gray = im2gray(gtImageColor);
gtImage_gray = imresize(gtImage_gray, [256 256]);

% denoisedimage = imread(strcat(cure_tsr_image_files(i).folder, '\', cure_tsr_image_files(i).name));
denoisedimage = imread('d1.png');
denoisedImage(:, :, 1) = double(imresize(denoisedimage(:, :, 1), [256 256]));
denoisedImage(:, :, 2) = double(imresize(denoisedimage(:, :, 1), [256 256]));
denoisedImage(:, :, 3) = double(imresize(denoisedimage(:, :, 1), [256 256]));
denoisedimage_gray = im2gray(denoisedImage);
denoisedimage_gray = imresize(denoisedimage_gray, [256 256]);

% Calculate the PSNR 
currImage.psnr = psnr(denoisedImage, gtImageColor);
% Calculate SSIM
currImage.ssim = ssim(denoisedImage, gtImageColor);
% Calculate CW-SSIM 
currImage.cw_ssim = cwssim(denoisedimage_gray, gtImage_gray, 6, 16, 0, 0);
% Calculate UNIQUE 
currImage.unique = mslUNIQUE(denoisedImage, gtImageColor);
% Calculate MSL-UNIQUE
currImage.ms_unique = mslMSUNIQUE(denoisedImage, gtImageColor);
% Calculate CSV
currImage.csv = csv(denoisedImage, gtImageColor);
% Calculate SUMMER
currImage.summer = SUMMER(denoisedImage, gtImageColor);
