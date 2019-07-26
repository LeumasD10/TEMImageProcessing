function [outputArg1,outputArg2,outputArg3] = performkook(II1_lt,TEMscale,OriginalImg)
%PERFORMKOOK Perform Kook's data extraction algorithm on provided image
%   Code adapted from Kook et. al's research paper

%% Initialization of constants
rmax = 50; % Maximum radius in pixel
rmin = 4; % Minimun radius in pixel
sens_val = 0.75; % the sensitivity (0?1) for the circular Hough transform

%% Canny edge detection
BWCED = edge(II1_lt,'canny');
% figure();imshow(BWCED);title('Canny edge detection');

%% Find circles within soot aggregates
[centersCED, radiiCED, metricCED] = imfindcircles(BWCED,[rmin rmax], 'objectpolarity', 'bright', 'sensitivity', sens_val, 'method', 'twostage');
% - draw circles
% figure();imshow(OriginalImg,[]);hold;h = viscircles(centersCED, radiiCED, 'EdgeColor','r');
% title('Primary particles overlaid on the original TEM image');


%% - check the circle finder by overlaying the CHT boundaries on the original image
R = imfuse(BWCED, OriginalImg,'blend');
figure();imshow(R,[],'InitialMagnification',500);hold;h = viscircles(centersCED, radiiCED, 'EdgeColor','r');
title('Primary particles overlaid on the Canny edges and the original TEM image');
dpdist = radiiCED*TEMscale*2;

outputArg1 = dpdist;
outputArg2 = centersCED;
outputArg3 = metricCED;
end
