function [grad, rsq, micronsPerMinute] = biofilmGrowthRate(session, imageId, c, tRange)
% [grad, rsq, micronsPerMinute] = biofilmGrowthRate(session, imageId, c, tRange)

% Copyright (C) 2013-2020 University of Dundee & Open Microscopy Environment.
% All rights reserved.
% 
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License along
% with this program; if not, write to the Free Software Foundation, Inc.,
% 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

img = double(getMovie(session, imageId, c, tRange));
image = getImages(session, imageId);
pixels = image.getPrimaryPixels;
physX = pixels.getPhysicalSizeX.getValue;

numT = length(tRange);
%rightMost = zeros(1,numT);
rightMost = [];

for thisT = 1:numT
    imgSeg = logical(seg2D(img(:,:,:,thisT),0, 0, 10));
    %imgSegMaj = bwmorph(imgSeg, 'Majority');
    imgSum = sum(imgSeg);
    try
        rightMost(end+1) = min(find(imgSum==0));
    catch
        continue;
    end
end

xdata = 1:length(rightMost);
[thisFit, gof] = fit(xdata', rightMost', 'poly1');
grad = thisFit.p1;
rsq = gof.rsquare;

micronsPerMinute = (grad*physX)/10;

% rightMostDiff = diff(rightMost);
% rightMostDiffMean = mean(rightMostDiff);
% rightMostDiffStd = std(rightMostDiff);
% meanDistPerTime = physX * rightMostDiffMean;
% meanStdPerTime = physX * rightMostDiffStd;

