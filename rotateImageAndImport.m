function rotateImageAndImport(session, imageId)
% rotateImageAndImport(session, imageId)
%Rotate an image to the horizontal based on a line ROI

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
global session

plane = getPlane(session, imageId, 0, 0, 0);
imageObj = getImages(session, imageId);
pixels = imageObj.getPrimaryPixels;
imageName = char(imageObj.getName.getValue.getBytes)';
physX = pixels.getPhysicalSizeX.getValue;
physY = pixels.getPhysicalSizeY.getValue;
try
    physZ = pixels.getPhysicalSizeZ.getValue;
catch
    physZ = 1;
end

rois = getROIsFromImageId(imageId);
X1 = rois{1}.shape1.getX1.getValue;
Y1 = rois{1}.shape1.getY1.getValue;
X2 = rois{1}.shape1.getX2.getValue;
Y2 = rois{1}.shape1.getY2.getValue;
slope = (Y2 - Y1) ./ (X2 - X1);
ang = atan2d(slope,1);

planeRot = imrotate(plane, ang);
[sizeY, sizeX, sizeZ, sizeC, sizeT] = size(planeRot);

newImage = createNewImage(session, [imageName '_rotate'], {525}, 'uint16', physX, physY, physZ, sizeX, sizeY, sizeZ, sizeT);
importPlanesToOmero(session, uint16(planeRot), newImage);
