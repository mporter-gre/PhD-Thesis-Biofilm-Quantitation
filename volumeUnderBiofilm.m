function [volumes, volSum] = volumeUnderBiofilm(session, dsId)
%[volumes, volSum] = volumeUnderBiofilm(session, dsId)
%Create volume map images and calculate the volume under the sample.

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

%Fetch each image stack in the dataset, reformat into XZ ortho-slices and 
%traverse each for upper-most occupied z position. Calculate the sum.
[~, imageIds]= getImageIdsAndNamesFromDatasetIds(dsId);
for thisImage = 1:length(imageIds)
    tic;
    disp(thisImage);
    for thisT = 1:25
        stack = getStack(session, imageIds(thisImage), 0, thisT-1);
        [sizeY, sizeX, sizeZ] = size(stack);
        stackSeg = logical(seg3D(double(stack), 0, 1, 0));
        vol = zeros(sizeY, sizeX);
        
        for y = 1:sizeY
            oSliceSeg = flip(squeeze(stackSeg(y, :, :))');
            for x = 1:sizeX
                vec = oSliceSeg(:, x);
                idx = find(vec, 1);
                if idx
                    vol(y, x) = sizeZ-idx;
                end
            end
        end
        
        volumes{thisImage}(:,:,thisT) = vol;
        volSum(thisImage, thisT) = sum(sum(vol));
    end
    toc;
end

volSum = volSum';