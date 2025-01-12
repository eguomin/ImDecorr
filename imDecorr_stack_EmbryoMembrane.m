% % set path and load some data
addpath('funcs')
% fileIn = 'I:\AO_Project\DeepLearning\TwoPhotonChris\Prepro\Tom20_Heart\img_6.tif';
fileIn = 'C:\Users\LabStation\OneDrive\TempWorkOnGoing\Project_multiStepDL\Manuscript_multiStep_DL\Demon_shallowSide\SPIMA-50.tif';
tic
img0 = double(ReadTifStack(fileIn));
pixelSize = 162.5; % nm
zStepSize = 1; % um

imSize0 = size(img0);
exSize = [0, 0, 4];
imSize = imSize0 - exSize * 2;

img = alignsize3d(img0, imSize);
pps = 5; % projected pixel size of 15nm
% typical parameters for resolution estimate
Nr = 50;
Ng = 10;
r = linspace(0,1,Nr);
GPU = 1;

Sz = imSize(3);
kcMaxs = zeros(1, Sz);
apSize =20;
for i = 1:Sz
    disp(['Processing slice number : ',num2str(i)])
    % % apodize image edges with a cosine function
    imSlice = apodImRect(img(:,:,i), apSize);
    
    % % compute resolution
    
    figID = 100;
    if GPU
        g = gpuDevice(1);
        [kcMax,A0] = getDcorr(gpuArray(imSlice),r,Ng,figID);
    else
        [kcMax,A0] = getDcorr(imSlice,r,Ng,figID);
    end
    disp(['   kcMax : ',num2str(kcMax,3),', A0 : ',num2str(A0,3)])
    kcMaxs(i) = kcMax;
    close all;
end
ress = pixelSize * 2./kcMaxs;
cTime = toc

figure, plot([1:Sz]* zStepSize, ress, 'LineWidth', 2);
xlabel('Z depth (um)');
ylabel('De-correlation Resolution (nm)');
title('De-correlation Analysis');