% MATLAB IMAGE PREPROCESSING SCRIPT
% Written by: Samuel Ma LeumasD10, June 2019
% Loads images one at a time, removes footer, applies background
% subtraction and further image processing techniques


%% Housekeeping - clear all windows and variables
close all; clear all;

%% Obtain image - display result
[img,img_directory] = uigetfile('*.tif');
img0 = imread([img_directory,img]);

% ui.displayimg(img0,'figure 1'); % Verify correct image selected

%% Remove footer from image - display result
img_cropped = imgtools.footerremove(img0); % crop footer
% ui.displayimg(img_cropped,'figure 2');

%% Obtain binary image
img_binary = thresholding.Agg_det_Slider(img_cropped);
% ui.displayimg(img_binary,'figure 3');

%% Further Processing
img_new = double(img_cropped).*img_binary;
ui.displayimg(img_new,'figure 4');

% se = strel('disk',3);
img_new2 = kook.preprocessing.kookprepare(img_new);
ui.displayimg(img_new2,'figure 5');