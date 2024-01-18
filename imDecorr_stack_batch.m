% % set path and load some data
addpath('funcs')
clear all;
fileFolderIn = 'D:\AO_Project\DeepLearning\SynObj\Test_GT\';
fileOut = 'D:\AO_Project\DeepLearning\SynObj\Test_compOrders\Abe_7_order_poisson\SSIM_PSNR_Aberrated';
fileNameBase = 'scan_';
imgNumStart = 1;
imgNumEnd = 15;
% fileIn = 'I:\AO_Project\DeepLearning\TwoPhotonChris\DL_results\Tom20_Heart\DL_DeAbe\img_6.tif';
tic
img0 = double(ReadTifStack(fileIn));
pixelSize = 108; % nm
zStepSize = 0.5; % um

imSize0 = size(img0);
exSize = [10, 10, 10];
imSize = imSize0 - exSize * 2;

pps = 5; % projected pixel size of 15nm
% typical parameters for resolution estimate
Nr = 50;
Ng = 10;
r = linspace(0,1,Nr);
GPU = 1;

Sz = imSize(3);
kcMaxs = zeros(1, Sz);
apSize =20;

dNum1 = (imgNumEnd - imgNumStart + 1);
dValues = zeros(dNum1, Sz);

for i = imgNumStart:imgNumEnd
    cTime1 = toc(tStart);
    disp(['Image i #: ', num2str(i)]);
    fileImgSample = [fileFolderIn, fileNameBase, num2str(i), '.tif'];
    img0 = double(ReadTifStack(fileImgSample));
    
    fileImgSample = [fileFolderIn2, fileNameBase, num2str(i), '.tif'];
    img1 = single(ReadTifStack(fileImgSample));
    [sValue, pValue] = calculate_SSIM_PSNR(img1, img0);
    dValues(i, :) =[sValue, pValue];
    cTime2 = toc(tStart);
    disp(['... time cost: ', num2str(cTime2-cTime1)]);
end
dMean = mean(dValues);
dSD = std(dValues);
clear img0 img1
csvwrite([fileOut, '.csv'], dValues);
save([fileOut, '.mat']);
cTime = toc(tStart);
disp(['Processing completed!!! Total time cost:', num2str(cTime), ' s']);

img = alignsize3d(img0, imSize);
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