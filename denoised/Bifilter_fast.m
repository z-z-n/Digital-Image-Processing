%% RUN Bifilter Script
clear all;
warning('off','all')
% Testing will first happen on CURE-TSR images.

% Load in the Ground Truth Images
cure_tsr_image_path = 'D:\CURE-TSR\Real_Test\';

cure_tsr_image_files = dir(fullfile(cure_tsr_image_path, '**\*.*'));
cure_tsr_image_files = cure_tsr_image_files(~[cure_tsr_image_files.isdir]);  %remove folders from list

n_files = length(cure_tsr_image_files);  
j = 1;
sigmas = 10;
sigmar = 50;

basedImage = imread('s0.jpg');
if size(basedImage,3)>1
    basedImageColor = imresize(basedImage, [256 256]);
    basedImage_gray = im2gray(imresize(basedImage, [256 256]));
else
    basedImageColor(:, :, 1) = imresize(basedImage(:, :, 1), [256 256]);
    basedImageColor(:, :, 2) = imresize(basedImage(:, :, 1), [256 256]);
    basedImageColor(:, :, 3) = imresize(basedImage(:, :, 1), [256 256]);
    basedImage_gray = imresize(basedImage, [256 256]);
end

curImage = imread('s1.jpg');
if size(curImage,3)>1
    denoisedImageColor = imresize(curImage, [256 256]);
    denoisedImage_gray = im2gray(imresize(curImage, [256 256]));
else
    denoisedImageColor(:, :, 1) = imresize(curImage(:, :, 1), [256 256]);
    denoisedImageColor(:, :, 2) = imresize(curImage(:, :, 1), [256 256]);
    denoisedImageColor(:, :, 3) = imresize(curImage(:, :, 1), [256 256]);
    denoisedImage_gray = imresize(curImage, [256 256]);
end
%imshow(curImage)
[denoisedImage_gray, param_gray] = shiftableBF(double(denoisedImage_gray), sigmas, sigmar);
[denoisedImageColor(:, :, 1), param1] = shiftableBF(double(denoisedImageColor(:, :, 1)), sigmas, sigmar);
[denoisedImageColor(:, :, 2), param2] = shiftableBF(double(denoisedImageColor(:, :, 2)), sigmas, sigmar);
[denoisedImageColor(:, :, 3), param3] = shiftableBF(double(denoisedImageColor(:, :, 3)), sigmas, sigmar);

%denoisedImage_gray = imbilatfilt(denoisedImage_gray);
%denoisedImageColor = imbilatfilt(denoisedImageColor);
denoisedImage_gray = im2uint8(mat2gray(denoisedImage_gray));
denoisedImageColor = im2uint8(denoisedImageColor);
basedImageColor = im2uint8(basedImageColor);
imwrite(denoisedImageColor,'myfig1.jpg')
imwrite(basedImageColor,'myfig.jpg')

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
disp(currImage.psnr)
