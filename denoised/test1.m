denoisedImageColor = imread("s0.jpg");
basedImageColor = imread("s0.jpg");
% Calculate UNIQUE 
currImage.unique = mslUNIQUE(denoisedImageColor, basedImageColor);
% Calculate MSL-UNIQUE
currImage.ms_unique = mslMSUNIQUE(denoisedImageColor, basedImageColor);
% Calculate CSV
currImage.csv = csv(denoisedImageColor, basedImageColor);
% Calculate SUMMER
currImage.summer = SUMMER(denoisedImageColor, basedImageColor);