%This code is not optimised and badly commented

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Crop input spline image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Metadata
% Written by    : Nathanaël Esnault
% Verified by   : N/A
% Creation date : 2017-02-16
% Version       : 1.0 (finished on ...)
% Modifications :
% Known bugs    :

%% Functions associated with this code :

%% Possible Improvements


%% DETERMINE bounding box for cropping
BBstats = regionprops(object{k},'BoundingBox');
[r,c] = find(object{k});%Nathan, explanation: find the index of the position of the white (1) in the matrix

%% CROP image
maxBorder(k) = max(size(object{k})); %init to something huge but wise
%Check of the left
if BBstats.BoundingBox(1)-border <= 0 %then we reached the left limit
    maxBorder(k) = BBstats.BoundingBox(1);
end
%Check of the top
if BBstats.BoundingBox(2)-border <= 0 %then we reached the top limit
    maxBorder(k) = min([BBstats.BoundingBox(2) maxBorder(k)]);
end
%Check of the right
if BBstats.BoundingBox(3)+border >= size(object{k},1) %then we reached the right limit
    maxBorder(k) = min([(size(object{k},2)-BBstats.BoundingBox(3)-BBstats.BoundingBox(1)) maxBorder(k)]);
end
%Check of the bottom
if BBstats.BoundingBox(4)+border >= size(object{k},1) %then we reached the bottom limit
    maxBorder(k) = min([(size(object{k},1)-BBstats.BoundingBox(4)) maxBorder(k)]);
end

if maxBorder(k) > border %then the border is smaller than the cropping box and we use the border as a parameter
    
else % then the object is too close to the border of the screen and we use maxBorder as a parameter
    border = maxBorder(k); %redifine the variable border to something acceptable
end
BB = [BBstats.BoundingBox(1)-border,BBstats.BoundingBox(2)-border,...
    BBstats.BoundingBox(3)+2*border,BBstats.BoundingBox(4)+2*border];

%% Draw
if Plot_debug
    figure();subplot(1,2,1);imshow(object{k}); subplot(1,2,2);imshow(imcrop(object{k},BB));
    close all
end