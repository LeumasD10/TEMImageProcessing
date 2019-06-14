% MATLAB IMAGE PREPROCESSING SCRIPT
% Written by: Samuel Ma, June 2019
% Loads images one at a time, removes footer, applies background
% subtraction and further image processing techniques


%% Housekeeping - clear all windows and variables
close all; clear all;

%% Initailization of Script Parameters
lid = 10;   % Script can hold 10 aggregates

%% Obtain image - display result
[img,img_directory] = uigetfile('*.tif');
img0 = imread([img_directory,img]);

% ui.displayimg(img0,'figure 1'); % Verify correct image selected


%% Remove footer from image - display result
[img_cropped,img_top] = imgtools.footerremove(img0); % crop footer

%% Collect TEM_scale data
[~,TEM_scale] = imgtools.get_footer_scale(img_top);

% ui.displayimg(img_cropped,'figure 2');

%% Obtain binary images

aggregateBin = {};
aggregate_quit = 0;
binIndex = 1;

while aggregate_quit == 0
    aggregateBin{binIndex} = thresholding.Agg_det_Slider(img_cropped);
    binIndex = binIndex + 1;
    answer = questdlg('Are there more aggregates to analyze?', ...
            'Check', ...
            'Yes','No','Prompt');
    switch answer
        case 'Yes'
            aggregate_quit = 0;
        case 'No'
            aggregate_quit = 1;
    end
end


% img_binary = thresholding.Agg_det_Slider(img_cropped);
% ui.displayimg(img_binary,'figure 3');

%% Further Processing

% Background Subtraction
img_new = double(img_cropped).*img_binary;
ui.displayimg(img_new,'figure 4');

% Utilization of Kook's Algorithm
% se = strel('disk',3);
img_new2 = kook.preprocessing.kookprepare(img_new);
[dp,centersCED,metricCED] = kook.methods.performkook(img_new2,TEM_scale,img_cropped);
figure(); histogram(dp); title('Distribution of Primary Particle Diameters');   % Plot Histogram of Data
ylabel('Number of Occurences');
xlabel('Particle Diameter (nm)');

ui.displayimg(img_new2,'figure 5');