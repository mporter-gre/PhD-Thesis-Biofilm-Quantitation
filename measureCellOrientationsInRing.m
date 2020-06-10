function props = measureCellOrientationsInRing(session, imageId)
% props = measureCellOrientationsInRing(session, imageId)
%Rotate an image to the horizontal based on a line ROI
%global session

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
roi = rois{1};
patch = getPatchFromRectROI(session, imageId, roi, 0);
patchSeg = logical(seg2D(patch,0,0,20));

props = regionprops(patchSeg, 'Orientation', 'MajorAxisLength', 'Eccentricity');
disp('check');




