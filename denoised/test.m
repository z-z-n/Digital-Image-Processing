clear all;
warning('off','all')

im_name = '2.tif';
%% ************************* Gaussian curvature *********************************************
im = imread(im_name);
if size(im,3)>1
    im = rgb2gray(im);
end

im = imresize(im, [256 256]);
FilterType = 5;
Iteration = 10;

disp('** running time includes the time for computing energy. **')

tic
[result,energy]=CFilter(im,FilterType, Iteration);
mytime = toc;

%% show the running time and the result
mystr = strcat('GC filter performance: ', num2str(mytime/size(energy,1)),' seconds per iteration (', num2str(size(im,1)),'X', num2str(size(im,2)), ' image)');
disp(mystr)
imwrite(mat2gray(result),'myfig2.jpg')

figure, imagesc([double(im),result,double(im)-result]), daspect([1,1,1]), colorbar
title('original(left), GCFilter(mid), difference(right)')
figure,plot(energy,'linewidth',4),xlabel('Iteration'), ylabel('Gaussian Curvature Energy'),title('Energy profile')