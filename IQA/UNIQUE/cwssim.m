img1 = imread('Demo Images/Original Image.BMP');
img2 = imread('Demo Images/Distorted Image.bmp');

%%
% Call mslUNIQUE which returns the perceived quality. Value nearer to 1
% represents a better quality image

quality = cwssim_index(img1, img2,6,16,0,0);