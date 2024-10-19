% % set path and load some data
addpath('funcs')
clear all;
filePath = 'D:\Project_hybridModel\paper-Result\Cell Actin\Statistics\';
fileOut = [filePath, 'FRC_Statistics'];

pixelSize = 108; % nm
pps = 5; % projected pixel size of 15nm
% typical parameters for resolution estimate
Nr = 50;
Ng = 10;
r = linspace(0,1,Nr);
GPU = 1;
apSize =20;
tStart = tic;

folderIn = 'GT\';
fileFolderIn = [filePath, folderIn];
files = dir(fullfile(fileFolderIn, '*.tif'));
imgNumStart = 1;
imgNumEnd = length(files);
dNum = (imgNumEnd - imgNumStart + 1);
resValues = zeros(4, dNum);
for i = imgNumStart:imgNumEnd
    cTime1 = toc(tStart);
    disp(['Image i #: ', num2str(i)]);
    fileIn = [fileFolderIn, files(i).name];
    img0 = double(ReadTifStack(fileIn));
    imSize0 = size(img0);
    exSize = [40, 40];
    img = img0(exSize(1)+1:imSize0(1)-exSize(1), exSize(2)+1:imSize0(2)-exSize(2));
    % % apodize image edges with a cosine function
    imSlice = apodImRect(img, apSize);
    % % compute resolution
    figID = 100;
    if GPU
        g = gpuDevice(1);
        [kcMax,A0] = getDcorr(gpuArray(imSlice),r,Ng,figID);
    else
        [kcMax,A0] = getDcorr(imSlice,r,Ng,figID);
    end
    disp(['   kcMax : ',num2str(kcMax,3),', A0 : ',num2str(A0,3)])
    close all;
    ress = pixelSize * 2/kcMax;
    resValues(1, i) =ress;
    cTime2 = toc(tStart);
    disp(['... time cost: ', num2str(cTime2-cTime1)]);
end

folderIn = 'raw\';
fileFolderIn = [filePath, folderIn];
files = dir(fullfile(fileFolderIn, '*.tif'));
imgNumStart = 1;
imgNumEnd = length(files);
dNum = (imgNumEnd - imgNumStart + 1);
% resValues = zeros(4, dNum);
for i = imgNumStart:imgNumEnd
    cTime1 = toc(tStart);
    disp(['Image i #: ', num2str(i)]);
    fileIn = [fileFolderIn, files(i).name];
    img0 = double(ReadTifStack(fileIn));
    imSize0 = size(img0);
    exSize = [60, 60];
    img = img0(exSize(1)+1:imSize0(1)-exSize(1), exSize(2)+1:imSize0(2)-exSize(2));
    % % apodize image edges with a cosine function
    imSlice = apodImRect(img, apSize);
    % % compute resolution
    figID = 100;
    if GPU
        g = gpuDevice(1);
        [kcMax,A0] = getDcorr(gpuArray(imSlice),r,Ng,figID);
    else
        [kcMax,A0] = getDcorr(imSlice,r,Ng,figID);
    end
    disp(['   kcMax : ',num2str(kcMax,3),', A0 : ',num2str(A0,3)])
    close all;
    ress = pixelSize * 2/kcMax;
    resValues(2, i) =ress;
    cTime2 = toc(tStart);
    disp(['... time cost: ', num2str(cTime2-cTime1)]);
end

folderIn = 'DeAbe\';
fileFolderIn = [filePath, folderIn];
files = dir(fullfile(fileFolderIn, '*.tif'));
imgNumStart = 1;
imgNumEnd = length(files);
dNum = (imgNumEnd - imgNumStart + 1);
% resValues = zeros(4, dNum);
for i = imgNumStart:imgNumEnd
    cTime1 = toc(tStart);
    disp(['Image i #: ', num2str(i)]);
    fileIn = [fileFolderIn, files(i).name];
    img0 = double(ReadTifStack(fileIn));
    imSize0 = size(img0);
    exSize = [40, 40];
    img = img0(exSize(1)+1:imSize0(1)-exSize(1), exSize(2)+1:imSize0(2)-exSize(2));
    % % apodize image edges with a cosine function
    imSlice = apodImRect(img, apSize);
    % % compute resolution
    figID = 100;
    if GPU
        g = gpuDevice(1);
        [kcMax,A0] = getDcorr(gpuArray(imSlice),r,Ng,figID);
    else
        [kcMax,A0] = getDcorr(imSlice,r,Ng,figID);
    end
    disp(['   kcMax : ',num2str(kcMax,3),', A0 : ',num2str(A0,3)])
    close all;
    ress = pixelSize * 2/kcMax;
    resValues(3, i) =ress;
    cTime2 = toc(tStart);
    disp(['... time cost: ', num2str(cTime2-cTime1)]);
end

folderIn = 'HD2Net\';
fileFolderIn = [filePath, folderIn];
files = dir(fullfile(fileFolderIn, '*.tif'));
imgNumStart = 1;
imgNumEnd = length(files);
dNum = (imgNumEnd - imgNumStart + 1);
% resValues = zeros(4, dNum);
for i = imgNumStart:imgNumEnd
    cTime1 = toc(tStart);
    disp(['Image i #: ', num2str(i)]);
    fileIn = [fileFolderIn, files(i).name];
    img0 = double(ReadTifStack(fileIn));
    imSize0 = size(img0);
    exSize = [40, 40];
    img = img0(exSize(1)+1:imSize0(1)-exSize(1), exSize(2)+1:imSize0(2)-exSize(2));
    % % apodize image edges with a cosine function
    imSlice = apodImRect(img, apSize);
    % % compute resolution
    figID = 100;
    if GPU
        g = gpuDevice(1);
        [kcMax,A0] = getDcorr(gpuArray(imSlice),r,Ng,figID);
    else
        [kcMax,A0] = getDcorr(imSlice,r,Ng,figID);
    end
    disp(['   kcMax : ',num2str(kcMax,3),', A0 : ',num2str(A0,3)])
    close all;
    ress = pixelSize * 2/kcMax;
    resValues(4, i) =ress;
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

