function [distr, centers, metr] = perform(img_cropped,img_binary,i,colorarray,TEM_scale)
%PERFORM Applies background subtraction and Kook's processing technique on images
%   Runs through images of a specified index, requires the original cropped
%   image and binary image, returns array of primary particle diameters and
%   useful figures
%   Written by: Samuel Ma, June 2019

%% Further Processing

% Background Subtraction
img_new = double(img_cropped).*img_binary;
% ui.displayimg(img_new,['Background Subtraction for Aggregate ' i]);

% Utilization of Kook's Algorithm
% se = strel('disk',3);
img_new2 = kook.preprocessing.kookprepare(img_new);
[dp,c,m] = kook.methods.performkook(img_new2,TEM_scale,img_cropped);
if (i>length(colorarray))
    col=colorarray(1);
else
    col=colorarray(i);
end
figure(); histogram(dp,'FaceColor',num2str(col)); title(['Distribution of Primary Particle Diameters for Aggregate ' num2str(i)]);   % Plot Histogram of Data
ylabel('Number of Occurences');
xlabel('Particle Diameter (nm)');

% ui.displayimg(img_new2,['Image after Kook Preprocessing for Aggregate ' i]);

distr = dp;
centers = c;
metr = m;

end
