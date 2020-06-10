function [startDistVsGrad, distFromFrontVsStep] = distFromBiofilmFrontVsStepGrad(distFromFront, steps)
% [startDistVsGrad, distFromFrontVsStep] = distFromBiofilmFrontVsStepGrad(distFromFront, steps)

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

numImages = length(steps);
grads = [];
distAtStart = [];
distFromFrontAllT = [];
stepsAllT = [];

for thisImage = 1:numImages
    theseSteps = steps{thisImage};
    [numROIs, numT] = size(theseSteps);
    xdata = [1:numT]';
    for thisROI = 1:numROIs
        dist1 = distFromFront{thisImage}(thisROI,1);
        if dist1 > 281
            continue;
        end
        thisFit = fit(theseSteps(thisROI,:)', xdata, 'poly1');
        grads(end+1) = thisFit.p1;
        distAtStart(end+1) = dist1;
        for thisT = 1:numT
            try
                distFromFrontAllT(end+1) = distFromFront{thisImage}(thisROI, thisT);
                stepsAllT(end+1) = theseSteps(thisROI, thisT);
            catch
                continue;
            end
        end
    end 
end

startDistVsGrad(:,1) = distAtStart';
startDistVsGrad(:,2) = grads';
distFromFrontVsStep(:,1) = distFromFrontAllT';
distFromFrontVsStep(:,2) = stepsAllT';
