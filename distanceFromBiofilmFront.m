function [distFromFront, stats, gof] = distanceFromBiofilmFront(session, imageId, rightMost, pointCoords)
% [distFromFront, stats, gof] = distanceFromBiofilmFront(session, imageId, rightMost, pointCoords)

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

%Collect image metadata and ROIs
imageObj = getImages(session, imageId);
pixels = imageObj.getPrimaryPixels;
physX = pixels.getPhysicalSizeX.getValue;
[numROI, ~] = size(pointCoords);
numT = length(rightMost);

%Use right-most pixel position from segmented image to calculate distance,
%in um, for each point at each time point. Fit a linear function to each
%ROI
for thisROI = 1:numROI
    for thisT = 1:numT
        distFromFront(thisROI, thisT) = rightMost(thisT) - pointCoords(thisROI, thisT) * physX;
    end
    distToFit = distFromFront(thisROI, :)';
    xdata = 1:numT;
    if isnan(distToFit)
        stats{thisROI} = [];
        gof{thisROI} = [];
    else
        distNans = isnan(distToFit);
        if find(distNans)
            maxIdx = find(distNans, 1, 'first')-1;
            xdata = 1:maxIdx;
            distToFit = distFromFront(thisROI, 1:maxIdx)';
        end
        [stats{thisROI}, gof{thisROI}] = fit(xdata', distToFit, 'poly1');
    end
end
