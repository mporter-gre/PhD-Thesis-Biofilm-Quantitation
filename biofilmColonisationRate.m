function [meanPatch, minMaxMeanPatch, grads, fdhm] = biofilmColonisationRate(session, imageId, c)
% [meanPatch, minMaxMeanPatch, grads, fdhm] = biofilmColonisationRate(session, imageId, c)
%for each ROI, get the correct time-order of each shape, take a mean of the
%intensities, normalise them to min/max, find the gradient, fit a curve,
%calculate rates.

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

rois = getROIsFromImageId(imageId);
numROIs = length(rois);

for thisROI = 1:numROIs
    patch = getPatchFromRectROI(session, imageId, rois{thisROI}, c);
    for thisShape = 1:rois{thisROI}.numShapes
        ts(thisShape) = rois{thisROI}.(['shape' num2str(thisShape)]).getTheT.getValue;
        [~, idx] = sort(ts);
        counter = 1;
    end
    ts = [];
    for thisT = idx
        meanPatch(thisROI, counter) = mean(mean(patch(:,:,thisT)));
        counter = counter + 1;
    end
    minMaxMeanPatch(thisROI,:) = (meanPatch(thisROI,:)-min(meanPatch(thisROI,:)))/(max(meanPatch(thisROI,:))-min(meanPatch(thisROI,:)));
    grads = gradient(minMaxMeanPatch(thisROI,:));
    [f, gof] = fit([1:length(grads)]', grads', 'gauss1');
    fdhm(thisROI) = f.c1 * 2.35482;
    rsq(thisROI) = gof.rsquare;
end
end
