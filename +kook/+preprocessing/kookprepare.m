function [newImg] = kookprepare(II1)
%KOOKPREPARE : Apply image preprocessing as follows from Kook's paper
%   Code pulled from Kook et. al, modified by Samuel Ma
%   June 2019
%   II1 must be a matrix of doubles


%% Initialization

SelfSubt = 0.8; % Self-subtraction level
maxImgCount = 255; % Maximum image count for 8-bit image
mf = 1; % Median filter [x x] if needed
alpha = 0.1; % Shape of the negative Laplacian “unsharp” filter 0?1

OriginalImg = II1;

%% - step 1: invert
if size(OriginalImg,1) > 900
 II1(950:size(II1,1), 1:250) = 0;% ignore scale bar in the TEM image x 1-250 pixel and y 950-max pixel
end
II1_bg=SelfSubt*II1; % Self-subtration from the original image
II1=maxImgCount-II1;
II1=II1-II1_bg;
II1(II1<0)=0;
figure();imshow(II1, []);title('Step 1: Inversion and self-subtraction');

%% - step 2: median filter to remove noise
II1_mf=medfilt2(II1, [mf mf]);
figure();imshow(II1_mf, []);title('Step 2: Median filter');

%% - step 3: Unsharp filter
f = fspecial('unsharp', alpha);
II1_lt = imfilter(II1_mf, f);
figure();imshow(II1_lt, []);title('Step 3: Unsharp filter');

%% - step 4: return the image
newImg = II1_lt;

end

