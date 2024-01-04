%denoisedImageColor = imread("2.tif");
basedImageColor = imread("./img/img0000.jpg");
%denoisedImageColor = imnoise(basedImageColor,'gaussian');
%denoisedImageColor = imnoise(basedImageColor,'salt & pepper');
denoisedImageColor = imnoise(basedImageColor, 'poisson');
imshow(denoisedImageColor)
sigmas = 3;
sigmar = 40;
[denoisedImage_gray, param_gray] = shiftableBF(double(basedImageColor), sigmas, sigmar);
denoisedImage_gray=mat2gray(denoisedImage_gray);
imshow(denoisedImage_gray)