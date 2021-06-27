function imgStack = ReadTifStack(fileTif)
% function imgStack = ReadTifStack(fileTif) reads TIFF Stack based on MATLAB
% Tiff class
% 1) Only 8-bit, 16-bit, 32-bit 3D images are supported.
% 2) 4D or 5D images will be converted to 3D.

% Oct 3, 2020

warning('off');

InfoImage = imfinfo(fileTif);
Sx = InfoImage.Height;
Sy = InfoImage.Width;
NumberImages = length(InfoImage);
bitNum = InfoImage.BitsPerSample;
switch(bitNum)
    case 8
        dtType = 'uint8';
    case 16
        dtType = 'uint16';
    case 32
        dtType = 'single';
    otherwise
        error('Unknown Bit Type *** only 8-bit, 16-bit, 32-bit supported.')
end
imgStack = zeros(Sx, Sy, NumberImages, dtType);
TifLink = Tiff(fileTif, 'r');
for i = 1:NumberImages
    TifLink.setDirectory(i);
    imgStack(:,:,i) = TifLink.read();
end
TifLink.close();
end