% MATLAB IMAGE PREPROCESSING SCRIPT
% Written by: Samuel Ma, June 2019
% Loads images one at a time, removes footer, applies background
% subtraction and further image processing techniques


%% Housekeeping - clear all windows and variables
close all; clear all;

%% Initialization of Script Parameters
lid = 10;   % Script can hold 10 aggregates
aggregateBin = cell(0,lid); % Bin of aggregates to process
resultsBin = cell(0,lid); % Bin of result objects from corresponding aggregates
colorarray = ['r','o','y','g','b'];

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
aggregate_quit = 0;
binIndex = 1;

% Capture all aggregate in image of interest
while aggregate_quit == 0
    try
        aggregateBin{binIndex} = thresholding.Agg_det_Slider(img_cropped);
        % Attempt thresholding, if operation is aborted midway, stop
        % thresholding process
    catch ERR
        is_interrupted = questdlg('Operation was interrupted; was this intentional?',...
            'Ignore current aggregate?',...
            'Yes','No','Input');
        switch is_interrupted
            case 'Yes'
                disp('Thresholding Process aborted by user');
                break;
            case 'No'
                rethrow(ERR);
        end
    end
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


%% Process each Image using Kook's Techniques
for i = 1:1:size(aggregateBin,2)
    [d,c,m] = perform(img_cropped,aggregateBin{i},i,TEM_scale);
    resultsBin{i}.dist = d;
    resultsBin{i}.cents = c;
    resultsBin{i}.metr = m;
end

%% Overlay detected primary particles for each aggregate
figure();imshow(img_cropped,[]); hold;
% title('Primary particles overlaid on the original TEM image');
for i = 1:1:size(aggregateBin,2)
    radii = resultsBin{i}.dist./2;
    centers = resultsBin{i}.cents;
    h = viscircles(centers,radii,'EdgeColor','r');
    text(avecenter(1,1),avecenter(1,2),'1');
end
title('Primary particles overlaid on the original TEM image');

% img_binary = thresholding.Agg_det_Slider(img_cropped);
% ui.displayimg(img_binary,'figure 3');

%% Further Processing

% % Background Subtraction
% img_new = double(img_cropped).*img_binary;
% ui.displayimg(img_new,'figure 4');
%
% % Utilization of Kook's Algorithm
% % se = strel('disk',3);
% img_new2 = kook.preprocessing.kookprepare(img_new);
% [dp,centersCED,metricCED] = kook.methods.performkook(img_new2,TEM_scale,img_cropped);
% figure(); histogram(dp); title('Distribution of Primary Particle Diameters');   % Plot Histogram of Data
% ylabel('Number of Occurences');
% xlabel('Particle Diameter (nm)');
%
% ui.displayimg(img_new2,'figure 5');
