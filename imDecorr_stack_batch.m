% % set path and load some data
addpath('funcs')
clear all;
fileFolderIn = 'D:\Project_multiStepDL\AO_data_FromChad\Zebrafish\depth_DeAbe\DeAbe_RCAN\';
fileOut = 'D:\Project_multiStepDL\AO_data_FromChad\Zebrafish\depth_DeAbe\FRC_DeAbe_RCAN';
fileNameBase = 'scan_';
imgNumStart = 1;
imgNumEnd = 15;
% fileIn = 'I:\AO_Project\DeepLearning\TwoPhotonChris\DL_results\Tom20_Heart\DL_DeAbe\img_6.tif';
fileIn = [fileFolderIn, fileNameBase, num2str(imgNumStart), '.tif'];
img0 = double(ReadTifStack(fileIn));
pixelSize = 108; % nm

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

dNum = (imgNumEnd - imgNumStart + 1);
resValues = zeros(dNum, Sz);
tStart = tic;
for i = imgNumStart:imgNumEnd
    cTime1 = toc(tStart);
    disp(['Image i #: ', num2str(i)]);
    fileImgSample = [fileFolderIn, fileNameBase, num2str(i), '.tif'];
    img0 = double(ReadTifStack(fileImgSample));
    img = alignsize3d(img0, imSize);
    for j = 1:Sz
        % % apodize image edges with a cosine function
        imSlice = apodImRect(img(:,:,j), apSize);
        % % compute resolution

        figID = 100;
        if GPU
            g = gpuDevice(1);
            [kcMax,A0] = getDcorr(gpuArray(imSlice),r,Ng,figID);
        else
            [kcMax,A0] = getDcorr(imSlice,r,Ng,figID);
        end
        disp(['   kcMax : ',num2str(kcMax,3),', A0 : ',num2str(A0,3)])
        kcMaxs(j) = kcMax;
        close all;
    end
    ress = pixelSize * 2./kcMaxs;

    resValues(i, :) =ress;
    cTime2 = toc(tStart);
    disp(['... time cost: ', num2str(cTime2-cTime1)]);
end
resMean = mean(resValues,2);
resSD = std(resValues',1)';
clear img0 img
csvwrite([fileOut, '.csv'], resValues);
csvwrite([fileOut, '_mean_SD.csv'], [resMean resSD]);
save([fileOut, '.mat']);
cTime = toc(tStart);
disp(['Processing completed!!! Total time cost:', num2str(cTime), ' s']);

fileFolderIn = 'D:\Project_multiStepDL\AO_data_FromChad\Zebrafish\depth_raw\noAO\';
fileOut = 'D:\Project_multiStepDL\AO_data_FromChad\Zebrafish\depth_DeAbe\FRC_noAO';
fileNameBase = 'scan_';
imgNumStart = 1;
imgNumEnd = 15;
% fileIn = 'I:\AO_Project\DeepLearning\TwoPhotonChris\DL_results\Tom20_Heart\DL_DeAbe\img_6.tif';
fileIn = [fileFolderIn, fileNameBase, num2str(imgNumStart), '.tif'];
img0 = double(ReadTifStack(fileIn));
pixelSize = 108; % nm

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

dNum = (imgNumEnd - imgNumStart + 1);
resValues = zeros(dNum, Sz);
tStart = tic;
for i = imgNumStart:imgNumEnd
    cTime1 = toc(tStart);
    disp(['Image i #: ', num2str(i)]);
    fileImgSample = [fileFolderIn, fileNameBase, num2str(i), '.tif'];
    img0 = double(ReadTifStack(fileImgSample));
    img = alignsize3d(img0, imSize);
    for j = 1:Sz
        % % apodize image edges with a cosine function
        imSlice = apodImRect(img(:,:,j), apSize);
        % % compute resolution

        figID = 100;
        if GPU
            g = gpuDevice(1);
            [kcMax,A0] = getDcorr(gpuArray(imSlice),r,Ng,figID);
        else
            [kcMax,A0] = getDcorr(imSlice,r,Ng,figID);
        end
        disp(['   kcMax : ',num2str(kcMax,3),', A0 : ',num2str(A0,3)])
        kcMaxs(j) = kcMax;
        close all;
    end
    ress = pixelSize * 2./kcMaxs;

    resValues(i, :) =ress;
    cTime2 = toc(tStart);
    disp(['... time cost: ', num2str(cTime2-cTime1)]);
end
resMean = mean(resValues,2);
resSD = std(resValues',1)';
clear img0 img
csvwrite([fileOut, '.csv'], resValues);
csvwrite([fileOut, '_mean_SD.csv'], [resMean resSD]);
save([fileOut, '.mat']);
cTime = toc(tStart);
disp(['Processing completed!!! Total time cost:', num2str(cTime), ' s']);
