close all;
% % set path and load some data
addpath('funcs')
% fileIn = 'I:\AO_Project\DeepLearning\TwoPhotonChris\Prepro\Tom20_Heart\img_6.tif';
fileIn = 'Z:\Xuesong\SWM\2021_06_30_001_U2OS_Tom20\PBS\Test\Resoluton_comparison\Wiener_dir_1_DL.tif';
tic
img = double(ReadTifStack(fileIn));
pixelSize = 35.45; % nm

pps = 5; % projected pixel size of 15nm
% typical parameters for resolution estimate
Nr = 50;
Ng = 10;
r = linspace(0,1,Nr);
GPU = 1;

apSize =20;

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
ress = pixelSize * 2./kcMax;
disp(['   kcMax : ',num2str(kcMax,3),', ress : ',num2str(ress,3), ' nm'])
cTime = toc;