function [outputArg1,outputArg2] = performkook(II1_lt)
%PERFORMKOOK Perform Kook's data extraction algorithm on provided image
%   Code adapted from Kook et. al's research paper
%   Modified by Samuel Ma June 2019

%% Initialization of constants
rmax = 30; % Maximum radius in pixel
rmin = 4; % Minimun radius in pixel

%% Canny edge detection
BWCED = edge(II1_lt,'canny');
figure();imshow(BWCED);title('Step 4: Canny edge detection');

%% Find circles within soot aggregates
[centersCED, radiiCED, metricCED] = imfindcircles(BWCED,[rmin rmax], ‘objectpolarity’, ‘bright’, ‘sensitivity’, sens_val, ‘method’, ‘twostage’);
% - draw circles
figure();imshow(OriginalImg,[]);hold;h = viscircles(centersCED, radiiCED, ‘EdgeColor’,‘r’);
title(‘Step 5: Parimary particles overlaid on the original TEM image’);

outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

